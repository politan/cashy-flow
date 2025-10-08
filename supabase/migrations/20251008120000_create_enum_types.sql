-- migration: create enum types for invoices
-- description: creates custom enum types for invoice_type and invoice_status
-- affected objects: invoice_type enum, invoice_status enum
-- special considerations: these enums must be created before the invoices table

-- create enum type for invoice classification
-- defines whether an invoice represents sales income or business costs
create type invoice_type as enum ('sales', 'cost');

-- create enum type for invoice payment status
-- tracks whether an invoice has been paid or remains outstanding
create type invoice_status as enum ('paid', 'unpaid');
