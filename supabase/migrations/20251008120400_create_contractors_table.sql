-- migration: create contractors table
-- description: stores information about business contractors (clients and suppliers)
-- affected objects: contractors table
-- special considerations: unique constraint on (company_id, nip) ensures no duplicate contractors per company

-- create contractors table to store business partners information
-- contractors can be either clients (for sales invoices) or suppliers (for cost invoices)
create table contractors (
  -- unique identifier for the contractor record
  id uuid primary key default gen_random_uuid(),
  
  -- foreign key to companies table
  -- cascading delete removes all contractors when company is deleted
  company_id uuid not null references companies(id) on delete cascade,
  
  -- name of the contractor (company or individual)
  name text not null,
  
  -- nip (tax identification number) for the contractor
  -- used to uniquely identify contractors within a company
  nip text not null,
  
  -- timestamp of contractor record creation
  created_at timestamptz not null default now(),
  
  -- timestamp of last contractor record modification
  updated_at timestamptz not null default now(),
  
  -- composite unique constraint ensures nip is unique per company
  -- allows the same contractor to exist in different companies
  unique (company_id, nip)
);

-- enable row level security on contractors table
-- ensures users can only access contractors belonging to their company
alter table contractors enable row level security;

-- rls policy: allow authenticated users to read their company's contractors
-- rationale: users need to view contractors for invoice creation and management
create policy "allow authenticated users to select own company contractors"
on contractors for select
to authenticated
using (company_id = get_my_company_id());

-- rls policy: allow anonymous users to read their company's contractors
-- rationale: supports public access scenarios if needed
create policy "allow anonymous users to select own company contractors"
on contractors for select
to anon
using (company_id = get_my_company_id());

-- rls policy: allow authenticated users to create contractors for their company
-- rationale: users need to add new contractors
create policy "allow authenticated users to insert own company contractors"
on contractors for insert
to authenticated
with check (company_id = get_my_company_id());

-- rls policy: allow authenticated users to update their company's contractors
-- rationale: users need to modify contractor information
create policy "allow authenticated users to update own company contractors"
on contractors for update
to authenticated
using (company_id = get_my_company_id());

-- rls policy: allow authenticated users to delete their company's contractors
-- rationale: users need to remove contractors
create policy "allow authenticated users to delete own company contractors"
on contractors for delete
to authenticated
using (company_id = get_my_company_id());

-- create trigger to automatically update updated_at timestamp
create trigger on_update_contractors
before update on contractors
for each row
execute procedure handle_updated_at();

-- create index on company_id for efficient filtering by company
create index idx_contractors_company_id on contractors(company_id);

-- create index on (company_id, nip) for efficient uniqueness checks and lookups
create index idx_contractors_company_nip on contractors(company_id, nip);
