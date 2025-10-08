-- migration: create companies table
-- description: stores company information for each user profile
-- affected objects: companies table
-- special considerations: one-to-one with profiles in mvp, unique profile_id constraint

-- create companies table to store business entity information
-- in the mvp, each profile has exactly one company (enforced by unique constraint)
create table companies (
  -- unique identifier for the company record
  id uuid primary key default gen_random_uuid(),
  
  -- foreign key to profiles table, one-to-one relationship in mvp
  -- unique constraint ensures each profile can only have one company
  -- cascading delete removes company when profile is deleted
  profile_id uuid not null unique references profiles(id) on delete cascade,
  
  -- name of the company or business entity
  name text not null,
  
  -- starting cash balance for financial calculations and cashflow tracking
  -- defaults to zero, can be set during company setup
  initial_cash_balance numeric(15, 2) not null default 0.00,
  
  -- timestamp of company record creation
  created_at timestamptz not null default now(),
  
  -- timestamp of last company record modification
  updated_at timestamptz not null default now()
);

-- enable row level security on companies table
-- ensures users can only access their own company data
alter table companies enable row level security;

-- rls policy: allow authenticated users to read their own company
-- rationale: users need to view their company information
create policy "allow authenticated users to select own company"
on companies for select
to authenticated
using (profile_id = auth.uid());

-- rls policy: allow anonymous users to read their own company
-- rationale: supports scenarios during registration or public access
create policy "allow anonymous users to select own company"
on companies for select
to anon
using (profile_id = auth.uid());

-- rls policy: allow authenticated users to create their own company
-- rationale: users can create their company during onboarding
create policy "allow authenticated users to insert own company"
on companies for insert
to authenticated
with check (profile_id = auth.uid());

-- rls policy: allow authenticated users to update their own company
-- rationale: users need to modify their company information
create policy "allow authenticated users to update own company"
on companies for update
to authenticated
using (profile_id = auth.uid());

-- rls policy: allow authenticated users to delete their own company
-- rationale: supports company deletion workflows
create policy "allow authenticated users to delete own company"
on companies for delete
to authenticated
using (profile_id = auth.uid());

-- create trigger to automatically update updated_at timestamp
create trigger on_update_companies
before update on companies
for each row
execute procedure handle_updated_at();

-- create index on profile_id for efficient lookups
-- this optimizes the get_my_company_id() function performance
create index idx_companies_profile_id on companies(profile_id);

-- create helper function to get the company id for the current user
-- this function simplifies rls policy creation across multiple tables
-- note: this function is created after the companies table and its policies
-- because it references the companies table, but companies table policies use profile_id directly
create or replace function get_my_company_id()
returns uuid as $$
declare
  company_id uuid;
begin
  -- resolve company id by joining companies with profiles
  -- using the authenticated user's id from auth.uid()
  select c.id into company_id
  from companies c
  join profiles p on c.profile_id = p.id
  where p.id = auth.uid()
  limit 1;
  return company_id;
end;
$$ language plpgsql security definer;
