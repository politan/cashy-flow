-- migration: disable row level security on all tables
-- description: disables rls for testing/debugging purposes
-- affected objects: all application tables
-- ⚠️ warning: this is a destructive operation that removes all security policies
-- ⚠️ warning: use only in development/testing environments, never in production

-- disable rls on profiles table
alter table profiles disable row level security;

-- disable rls on companies table
alter table companies disable row level security;

-- disable rls on contractors table
alter table contractors disable row level security;

-- disable rls on invoices table
alter table invoices disable row level security;

-- disable rls on categories table
alter table categories disable row level security;

-- disable rls on invoice_categories table
alter table invoice_categories disable row level security;

-- disable rls on pending_invoices table
alter table pending_invoices disable row level security;

-- disable rls on ai_reports table
alter table ai_reports disable row level security;
