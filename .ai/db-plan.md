# CashyFlow - PostgreSQL Database Schema

This document outlines the database schema for the CashyFlow application, designed for PostgreSQL and integration with Supabase.

## 1. Table Definitions

### ENUM Types

```sql
-- Defines the type of invoice (sales or cost)
CREATE TYPE invoice_type AS ENUM ('sales', 'cost');

-- Defines the payment status of an invoice
CREATE TYPE invoice_status AS ENUM ('paid', 'unpaid');
```

### `profiles`

Stores application-specific user data, extending the `auth.users` table from Supabase.

| Column       | Data Type     | Constraints                                                  | Description                                          |
| :----------- | :------------ | :----------------------------------------------------------- | :--------------------------------------------------- |
| `id`         | `uuid`        | `PRIMARY KEY`, `REFERENCES auth.users(id) ON DELETE CASCADE` | One-to-one relationship with the user's auth record. |
| `created_at` | `timestamptz` | `NOT NULL`, `DEFAULT now()`                                  | Timestamp of profile creation.                       |
| `updated_at` | `timestamptz` | `NOT NULL`, `DEFAULT now()`                                  | Timestamp of last profile update.                    |

### `companies`

Stores information about a user's company. In the MVP, each profile is associated with one company.

| Column                 | Data Type        | Constraints                                                       | Description                                           |
| :--------------------- | :--------------- | :---------------------------------------------------------------- | :---------------------------------------------------- |
| `id`                   | `uuid`           | `PRIMARY KEY`, `DEFAULT gen_random_uuid()`                        | Unique identifier for the company.                    |
| `profile_id`           | `uuid`           | `NOT NULL`, `UNIQUE`, `REFERENCES profiles(id) ON DELETE CASCADE` | Foreign key linking to the user's profile.            |
| `name`                 | `text`           | `NOT NULL`                                                        | Name of the company.                                  |
| `initial_cash_balance` | `numeric(15, 2)` | `NOT NULL`, `DEFAULT 0.00`                                        | The starting cash balance for financial calculations. |
| `created_at`           | `timestamptz`    | `NOT NULL`, `DEFAULT now()`                                       | Timestamp of company creation.                        |
| `updated_at`           | `timestamptz`    | `NOT NULL`, `DEFAULT now()`                                       | Timestamp of last company update.                     |

### `contractors`

Stores information about contractors, unique per company based on their NIP.

| Column       | Data Type     | Constraints                                              | Description                                            |
| :----------- | :------------ | :------------------------------------------------------- | :----------------------------------------------------- |
| `id`         | `uuid`        | `PRIMARY KEY`, `DEFAULT gen_random_uuid()`               | Unique identifier for the contractor.                  |
| `company_id` | `uuid`        | `NOT NULL`, `REFERENCES companies(id) ON DELETE CASCADE` | Foreign key linking to the company.                    |
| `name`       | `text`        | `NOT NULL`                                               | Name of the contractor.                                |
| `nip`        | `text`        | `NOT NULL`                                               | Contractor's tax identification number (NIP).          |
| `created_at` | `timestamptz` | `NOT NULL`, `DEFAULT now()`                              | Timestamp of contractor creation.                      |
| `updated_at` | `timestamptz` | `NOT NULL`, `DEFAULT now()`                              | Timestamp of last contractor update.                   |
|              |               | `UNIQUE (company_id, nip)`                               | Ensures a contractor's NIP is unique within a company. |

### `invoices`

The central table for storing all sales and cost invoices.

| Column            | Data Type        | Constraints                                              | Description                                                          |
| :---------------- | :--------------- | :------------------------------------------------------- | :------------------------------------------------------------------- |
| `id`              | `uuid`           | `PRIMARY KEY`, `DEFAULT gen_random_uuid()`               | Unique identifier for the invoice.                                   |
| `company_id`      | `uuid`           | `NOT NULL`, `REFERENCES companies(id) ON DELETE CASCADE` | Foreign key linking to the company.                                  |
| `contractor_id`   | `uuid`           | `REFERENCES contractors(id) ON DELETE SET NULL`          | Foreign key linking to the contractor.                               |
| `invoice_number`  | `text`           | `NOT NULL`                                               | The official number of the invoice.                                  |
| `type`            | `invoice_type`   | `NOT NULL`                                               | Specifies if it's a sales or cost invoice.                           |
| `status`          | `invoice_status` | `NOT NULL`, `DEFAULT 'unpaid'`                           | The payment status of the invoice.                                   |
| `issue_date`      | `date`           | `NOT NULL`                                               | Date the invoice was issued.                                         |
| `due_date`        | `date`           | `NOT NULL`                                               | Payment due date.                                                    |
| `payment_date`    | `date`           |                                                          | Actual date the invoice was paid.                                    |
| `gross_value`     | `numeric(15, 2)` | `NOT NULL`                                               | The gross amount in the original currency.                           |
| `currency`        | `text`           | `NOT NULL`, `DEFAULT 'PLN'`                              | Currency code (e.g., 'PLN', 'EUR').                                  |
| `exchange_rate`   | `numeric(10, 4)` |                                                          | Exchange rate used for foreign currency conversion.                  |
| `gross_value_pln` | `numeric(15, 2)` |                                                          | The gross amount converted to PLN.                                   |
| `description`     | `text`           |                                                          | Optional description of the invoice items.                           |
| `is_recurring`    | `boolean`        | `NOT NULL`, `DEFAULT false`                              | Flag indicating if this is a template for a recurring invoice.       |
| `recurrence_rule` | `text`           |                                                          | Rule defining the recurrence pattern (e.g., iCalendar RRULE format). |
| `created_at`      | `timestamptz`    | `NOT NULL`, `DEFAULT now()`                              | Timestamp of invoice creation.                                       |
| `updated_at`      | `timestamptz`    | `NOT NULL`, `DEFAULT now()`                              | Timestamp of last invoice update.                                    |
|                   |                  | `UNIQUE (company_id, invoice_number)`                    | Ensures invoice numbers are unique within a company.                 |

### `categories`

A dictionary table for invoice categories, managed per company.

| Column       | Data Type     | Constraints                                              | Description                                         |
| :----------- | :------------ | :------------------------------------------------------- | :-------------------------------------------------- |
| `id`         | `uuid`        | `PRIMARY KEY`, `DEFAULT gen_random_uuid()`               | Unique identifier for the category.                 |
| `company_id` | `uuid`        | `NOT NULL`, `REFERENCES companies(id) ON DELETE CASCADE` | Foreign key linking to the company.                 |
| `name`       | `text`        | `NOT NULL`                                               | Name of the category.                               |
| `created_at` | `timestamptz` | `NOT NULL`, `DEFAULT now()`                              | Timestamp of category creation.                     |
|              |               | `UNIQUE (company_id, name)`                              | Ensures category names are unique within a company. |

### `invoice_categories`

A join table to create a many-to-many relationship between invoices and categories.

| Column        | Data Type | Constraints                                                  | Description                            |
| :------------ | :-------- | :----------------------------------------------------------- | :------------------------------------- |
| `invoice_id`  | `uuid`    | `PRIMARY KEY`, `REFERENCES invoices(id) ON DELETE CASCADE`   | Foreign key to the `invoices` table.   |
| `category_id` | `uuid`    | `PRIMARY KEY`, `REFERENCES categories(id) ON DELETE CASCADE` | Foreign key to the `categories` table. |

### `pending_invoices`

A temporary storage for invoices uploaded for OCR processing, awaiting user verification.

| Column       | Data Type     | Constraints                                              | Description                                            |
| :----------- | :------------ | :------------------------------------------------------- | :----------------------------------------------------- |
| `id`         | `uuid`        | `PRIMARY KEY`, `DEFAULT gen_random_uuid()`               | Unique identifier for the pending invoice.             |
| `company_id` | `uuid`        | `NOT NULL`, `REFERENCES companies(id) ON DELETE CASCADE` | Foreign key linking to the company.                    |
| `file_path`  | `text`        | `NOT NULL`                                               | Path to the uploaded file in Supabase Storage.         |
| `ocr_data`   | `jsonb`       |                                                          | Raw data extracted by the OCR service.                 |
| `status`     | `text`        | `NOT NULL`, `DEFAULT 'pending'`                          | Current status (e.g., 'pending', 'verified', 'error'). |
| `created_at` | `timestamptz` | `NOT NULL`, `DEFAULT now()`                              | Timestamp of upload.                                   |
| `updated_at` | `timestamptz` | `NOT NULL`, `DEFAULT now()`                              | Timestamp of last status update.                       |

### `ai_reports`

Stores the history of weekly AI-generated financial summary reports.

| Column         | Data Type     | Constraints                                              | Description                                 |
| :------------- | :------------ | :------------------------------------------------------- | :------------------------------------------ |
| `id`           | `uuid`        | `PRIMARY KEY`, `DEFAULT gen_random_uuid()`               | Unique identifier for the report.           |
| `company_id`   | `uuid`        | `NOT NULL`, `REFERENCES companies(id) ON DELETE CASCADE` | Foreign key linking to the company.         |
| `content`      | `jsonb`       |                                                          | The content of the report in JSON format.   |
| `generated_at` | `timestamptz` | `NOT NULL`, `DEFAULT now()`                              | Timestamp of when the report was generated. |

---

## 2. Relationships

- **`auth.users` <-> `profiles`**: One-to-One. Each user in `auth.users` has exactly one corresponding record in `profiles`.
- **`profiles` <-> `companies`**: One-to-One (for MVP). Each profile is associated with one company. This can be evolved to One-to-Many.
- **`companies` -> `invoices`**: One-to-Many. A company can have multiple invoices.
- **`companies` -> `contractors`**: One-to-Many. A company can have multiple contractors.
- **`companies` -> `categories`**: One-to-Many. A company defines its own set of categories.
- **`companies` -> `pending_invoices`**: One-to-Many. A company can have multiple invoices pending verification.
- **`companies` -> `ai_reports`**: One-to-Many. A company has an archive of its weekly reports.
- **`contractors` -> `invoices`**: One-to-Many. A contractor can be associated with multiple invoices.
- **`invoices` <-> `categories`**: Many-to-Many, implemented via the `invoice_categories` join table. An invoice can have multiple categories, and a category can be assigned to multiple invoices.

---

## 3. Indexes

To ensure query performance, especially for the dashboard and filtering functionalities.

- **Foreign Keys**: Indexes are automatically created for all primary keys. It is best practice to also create indexes on all foreign key columns (`profile_id`, `company_id`, `contractor_id`, `invoice_id`, `category_id`).
- **Composite Index on `invoices`**: A composite index is crucial for quickly fetching invoices for the dashboard (e.g., upcoming payments).
  ```sql
  CREATE INDEX idx_invoices_company_status_due_date ON invoices (company_id, status, due_date);
  ```

---

## 4. Row-Level Security (RLS) Policies

RLS will be enabled on all tables containing business data to ensure users can only access data belonging to their own company.

### Helper Function

This function simplifies policy creation by resolving the company ID for the currently authenticated user.

```sql
CREATE OR REPLACE FUNCTION get_my_company_id()
RETURNS uuid AS $$
DECLARE
  company_id uuid;
BEGIN
  SELECT c.id INTO company_id
  FROM companies c
  JOIN profiles p ON c.profile_id = p.id
  WHERE p.id = auth.uid()
  LIMIT 1;
  RETURN company_id;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;
```

### Policy Definitions

The following policies should be applied to the `companies`, `contractors`, `invoices`, `categories`, `invoice_categories`, `pending_invoices`, and `ai_reports` tables.

```sql
-- Enable RLS on the table
ALTER TABLE table_name ENABLE ROW LEVEL SECURITY;

-- Policy for SELECT operations
CREATE POLICY "Allow read access to own company data"
ON table_name FOR SELECT
USING (company_id = get_my_company_id());

-- Policy for INSERT operations
CREATE POLICY "Allow insert for own company data"
ON table_name FOR INSERT
WITH CHECK (company_id = get_my_company_id());

-- Policy for UPDATE operations
CREATE POLICY "Allow update for own company data"
ON table_name FOR UPDATE
USING (company_id = get_my_company_id());

-- Policy for DELETE operations
CREATE POLICY "Allow delete for own company data"
ON table_name FOR DELETE
USING (company_id = get_my_company_id());

-- Special policy for the 'companies' table itself
CREATE POLICY "Allow access to own company record"
ON companies FOR ALL
USING (id = get_my_company_id());
```

---

## 5. Additional Notes

- **`ai_reports.content` Structure**: The `JSONB` structure for the `content` column in `ai_reports` is not yet defined. A potential structure could be:
  ```json
  {
  	"week_start_date": "2025-10-06",
  	"week_end_date": "2025-10-12",
  	"summary": {
  		"total_income": 12500.0,
  		"total_expense": 4320.5,
  		"net_flow": 8179.5
  	},
  	"forecast": "...",
  	"insights": ["..."]
  }
  ```
- **`invoices.recurrence_rule` Format**: The session notes mention using the iCalendar `RRULE` format (e.g., `FREQ=MONTHLY;INTERVAL=1`). This is a flexible standard but will require application-level logic to parse and generate future invoice predictions. No database-level validation is planned for this field in the MVP.
- **Triggers for `updated_at`**: It is recommended to implement a trigger to automatically update the `updated_at` column on any row modification for tables that have this column.

  ```sql
  CREATE OR REPLACE FUNCTION handle_updated_at()
  RETURNS TRIGGER AS $$
  BEGIN
    NEW.updated_at = now();
    RETURN NEW;
  END;
  $$ LANGUAGE plpgsql;

  CREATE TRIGGER on_update_table_name
  BEFORE UPDATE ON table_name
  FOR EACH ROW
  EXECUTE PROCEDURE handle_updated_at();
  ```
