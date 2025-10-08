-- migration: create categories table
-- description: dictionary table for invoice categorization, managed per company
-- affected objects: categories table
-- special considerations: unique constraint on (company_id, name) prevents duplicate category names

-- create categories table to store invoice classification tags
-- categories help organize and analyze invoices by business area or expense type
create table categories (
  -- unique identifier for the category record
  id uuid primary key default gen_random_uuid(),
  
  -- foreign key to companies table
  -- cascading delete removes all categories when company is deleted
  company_id uuid not null references companies(id) on delete cascade,
  
  -- name of the category (e.g., 'marketing', 'office supplies', 'consulting')
  -- must be unique within a company
  name text not null,
  
  -- timestamp of category record creation
  created_at timestamptz not null default now(),
  
  -- composite unique constraint ensures category names are unique per company
  -- allows different companies to use the same category names
  unique (company_id, name)
);

-- enable row level security on categories table
-- ensures users can only access categories belonging to their company
alter table categories enable row level security;

-- rls policy: allow authenticated users to read their company's categories
-- rationale: users need to view categories for invoice categorization
create policy "allow authenticated users to select own company categories"
on categories for select
to authenticated
using (company_id = get_my_company_id());

-- rls policy: allow anonymous users to read their company's categories
-- rationale: supports public access scenarios if needed
create policy "allow anonymous users to select own company categories"
on categories for select
to anon
using (company_id = get_my_company_id());

-- rls policy: allow authenticated users to create categories for their company
-- rationale: users need to add new categories for organizing invoices
create policy "allow authenticated users to insert own company categories"
on categories for insert
to authenticated
with check (company_id = get_my_company_id());

-- rls policy: allow authenticated users to update their company's categories
-- rationale: users need to rename or modify categories
create policy "allow authenticated users to update own company categories"
on categories for update
to authenticated
using (company_id = get_my_company_id());

-- rls policy: allow authenticated users to delete their company's categories
-- rationale: users need to remove unused categories
create policy "allow authenticated users to delete own company categories"
on categories for delete
to authenticated
using (company_id = get_my_company_id());

-- create index on company_id for efficient filtering by company
create index idx_categories_company_id on categories(company_id);

-- create index on (company_id, name) for efficient uniqueness checks and lookups
create index idx_categories_company_name on categories(company_id, name);
