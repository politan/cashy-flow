-- migration: create pending_invoices table
-- description: temporary storage for invoices uploaded for ocr processing
-- affected objects: pending_invoices table
-- special considerations: stores file paths and ocr data, awaiting user verification

-- create pending_invoices table for ocr workflow
-- this table temporarily stores uploaded invoice files and extracted ocr data
-- until the user verifies and approves the data for final invoice creation
create table pending_invoices (
  -- unique identifier for the pending invoice record
  id uuid primary key default gen_random_uuid(),
  
  -- foreign key to companies table
  -- cascading delete removes pending invoices when company is deleted
  company_id uuid not null references companies(id) on delete cascade,
  
  -- path to the uploaded invoice file in supabase storage
  -- used to retrieve and display the original document
  file_path text not null,
  
  -- raw data extracted by the ocr service in json format
  -- structure depends on the ocr provider (e.g., invoice number, dates, amounts)
  ocr_data jsonb,
  
  -- current processing status of the pending invoice
  -- possible values: 'pending' (awaiting ocr), 'verified' (user approved), 'error' (ocr failed)
  status text not null default 'pending',
  
  -- timestamp of file upload
  created_at timestamptz not null default now(),
  
  -- timestamp of last status update
  updated_at timestamptz not null default now()
);

-- enable row level security on pending_invoices table
-- ensures users can only access pending invoices belonging to their company
alter table pending_invoices enable row level security;

-- rls policy: allow authenticated users to read their company's pending invoices
-- rationale: users need to view pending invoices for verification
create policy "allow authenticated users to select own pending invoices"
on pending_invoices for select
to authenticated
using (company_id = get_my_company_id());

-- rls policy: allow anonymous users to read their company's pending invoices
-- rationale: supports public upload scenarios if needed
create policy "allow anonymous users to select own pending invoices"
on pending_invoices for select
to anon
using (company_id = get_my_company_id());

-- rls policy: allow authenticated users to upload invoices for their company
-- rationale: users need to upload invoice files for ocr processing
create policy "allow authenticated users to insert own pending invoices"
on pending_invoices for insert
to authenticated
with check (company_id = get_my_company_id());

-- rls policy: allow authenticated users to update their company's pending invoices
-- rationale: users need to update status after verification or ocr completion
create policy "allow authenticated users to update own pending invoices"
on pending_invoices for update
to authenticated
using (company_id = get_my_company_id());

-- rls policy: allow authenticated users to delete their company's pending invoices
-- rationale: users need to remove rejected or processed pending invoices
create policy "allow authenticated users to delete own pending invoices"
on pending_invoices for delete
to authenticated
using (company_id = get_my_company_id());

-- create trigger to automatically update updated_at timestamp
create trigger on_update_pending_invoices
before update on pending_invoices
for each row
execute procedure handle_updated_at();

-- create index on company_id for efficient filtering by company
create index idx_pending_invoices_company_id on pending_invoices(company_id);

-- create index on status for efficient filtering by processing status
create index idx_pending_invoices_status on pending_invoices(status);

-- create index on created_at for chronological sorting
create index idx_pending_invoices_created_at on pending_invoices(created_at);
