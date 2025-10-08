-- migration: create invoices table
-- description: central table for storing all sales and cost invoices
-- affected objects: invoices table
-- special considerations: supports both regular and recurring invoices, multi-currency with pln conversion

-- create invoices table to store all invoice records
-- this is the central table for tracking both sales income and business costs
create table invoices (
  -- unique identifier for the invoice record
  id uuid primary key default gen_random_uuid(),
  
  -- foreign key to companies table
  -- cascading delete removes all invoices when company is deleted
  company_id uuid not null references companies(id) on delete cascade,
  
  -- foreign key to contractors table (optional)
  -- set to null if contractor is deleted, preserving invoice history
  contractor_id uuid references contractors(id) on delete set null,
  
  -- official invoice number (must be unique within company)
  invoice_number text not null,
  
  -- type of invoice: 'sales' for income or 'cost' for expenses
  type invoice_type not null,
  
  -- payment status: 'paid' or 'unpaid'
  -- defaults to unpaid when invoice is created
  status invoice_status not null default 'unpaid',
  
  -- date when the invoice was issued
  issue_date date not null,
  
  -- date when payment is due
  due_date date not null,
  
  -- actual date when the invoice was paid (null if unpaid)
  payment_date date,
  
  -- gross amount in the original currency
  gross_value numeric(15, 2) not null,
  
  -- currency code (iso 4217 format, e.g., 'pln', 'eur', 'usd')
  -- defaults to polish zloty
  currency text not null default 'PLN',
  
  -- exchange rate used for foreign currency conversion to pln
  -- null for pln invoices
  exchange_rate numeric(10, 4),
  
  -- gross amount converted to pln for consistent reporting
  -- null for pln invoices (use gross_value directly)
  gross_value_pln numeric(15, 2),
  
  -- optional description of invoice items or notes
  description text,
  
  -- flag indicating if this is a recurring invoice template
  -- recurring invoices are used to generate future invoice predictions
  is_recurring boolean not null default false,
  
  -- recurrence rule in icalendar rrule format (e.g., 'freq=monthly;interval=1')
  -- only applicable when is_recurring is true
  recurrence_rule text,
  
  -- timestamp of invoice record creation
  created_at timestamptz not null default now(),
  
  -- timestamp of last invoice record modification
  updated_at timestamptz not null default now(),
  
  -- composite unique constraint ensures invoice numbers are unique per company
  unique (company_id, invoice_number)
);

-- enable row level security on invoices table
-- ensures users can only access invoices belonging to their company
alter table invoices enable row level security;

-- rls policy: allow authenticated users to read their company's invoices
-- rationale: users need to view invoices for cashflow tracking and reporting
create policy "allow authenticated users to select own company invoices"
on invoices for select
to authenticated
using (company_id = get_my_company_id());

-- rls policy: allow anonymous users to read their company's invoices
-- rationale: supports public dashboard or reporting scenarios if needed
create policy "allow anonymous users to select own company invoices"
on invoices for select
to anon
using (company_id = get_my_company_id());

-- rls policy: allow authenticated users to create invoices for their company
-- rationale: users need to add new invoices manually or via ocr
create policy "allow authenticated users to insert own company invoices"
on invoices for insert
to authenticated
with check (company_id = get_my_company_id());

-- rls policy: allow authenticated users to update their company's invoices
-- rationale: users need to modify invoice details, mark as paid, etc.
create policy "allow authenticated users to update own company invoices"
on invoices for update
to authenticated
using (company_id = get_my_company_id());

-- rls policy: allow authenticated users to delete their company's invoices
-- rationale: users need to remove incorrect or duplicate invoices
create policy "allow authenticated users to delete own company invoices"
on invoices for delete
to authenticated
using (company_id = get_my_company_id());

-- create trigger to automatically update updated_at timestamp
create trigger on_update_invoices
before update on invoices
for each row
execute procedure handle_updated_at();

-- create index on company_id for efficient filtering by company
create index idx_invoices_company_id on invoices(company_id);

-- create index on contractor_id for efficient contractor-based queries
create index idx_invoices_contractor_id on invoices(contractor_id);

-- create composite index for dashboard queries (upcoming payments, overdue invoices)
-- this index optimizes queries that filter by company, status, and sort by due date
create index idx_invoices_company_status_due_date on invoices(company_id, status, due_date);

-- create index on (company_id, invoice_number) for efficient uniqueness checks
create index idx_invoices_company_number on invoices(company_id, invoice_number);

-- create index on issue_date for date-range queries and reporting
create index idx_invoices_issue_date on invoices(issue_date);

-- create index on payment_date for cashflow analysis
create index idx_invoices_payment_date on invoices(payment_date);
