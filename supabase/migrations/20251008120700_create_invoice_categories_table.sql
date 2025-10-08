-- migration: create invoice_categories junction table
-- description: implements many-to-many relationship between invoices and categories
-- affected objects: invoice_categories table
-- special considerations: composite primary key, cascading deletes from both sides

-- create invoice_categories junction table
-- this table enables many-to-many relationship: one invoice can have multiple categories,
-- and one category can be assigned to multiple invoices
create table invoice_categories (
  -- foreign key to invoices table
  -- cascading delete removes the association when invoice is deleted
  invoice_id uuid not null references invoices(id) on delete cascade,
  
  -- foreign key to categories table
  -- cascading delete removes the association when category is deleted
  category_id uuid not null references categories(id) on delete cascade,
  
  -- composite primary key ensures each invoice-category pair is unique
  primary key (invoice_id, category_id)
);

-- enable row level security on invoice_categories table
-- ensures users can only access category associations for their company's invoices
alter table invoice_categories enable row level security;

-- rls policy: allow authenticated users to read invoice categories for their company
-- rationale: users need to view which categories are assigned to invoices
create policy "allow authenticated users to select own invoice categories"
on invoice_categories for select
to authenticated
using (
  -- check if the invoice belongs to user's company
  exists (
    select 1 from invoices
    where invoices.id = invoice_categories.invoice_id
    and invoices.company_id = get_my_company_id()
  )
);

-- rls policy: allow anonymous users to read invoice categories for their company
-- rationale: supports public access scenarios if needed
create policy "allow anonymous users to select own invoice categories"
on invoice_categories for select
to anon
using (
  -- check if the invoice belongs to user's company
  exists (
    select 1 from invoices
    where invoices.id = invoice_categories.invoice_id
    and invoices.company_id = get_my_company_id()
  )
);

-- rls policy: allow authenticated users to assign categories to their company's invoices
-- rationale: users need to categorize their invoices
create policy "allow authenticated users to insert own invoice categories"
on invoice_categories for insert
to authenticated
with check (
  -- verify the invoice belongs to user's company
  exists (
    select 1 from invoices
    where invoices.id = invoice_categories.invoice_id
    and invoices.company_id = get_my_company_id()
  )
);

-- rls policy: allow authenticated users to remove categories from their company's invoices
-- rationale: users need to uncategorize or recategorize invoices
create policy "allow authenticated users to delete own invoice categories"
on invoice_categories for delete
to authenticated
using (
  -- verify the invoice belongs to user's company
  exists (
    select 1 from invoices
    where invoices.id = invoice_categories.invoice_id
    and invoices.company_id = get_my_company_id()
  )
);

-- create index on invoice_id for efficient lookup of categories by invoice
create index idx_invoice_categories_invoice_id on invoice_categories(invoice_id);

-- create index on category_id for efficient lookup of invoices by category
create index idx_invoice_categories_category_id on invoice_categories(category_id);
