-- migration: create updated_at trigger function
-- description: creates a reusable function to automatically update updated_at timestamps
-- affected objects: handle_updated_at function
-- special considerations: this function is used by multiple tables with updated_at columns

-- create function to automatically update the updated_at column
-- this function is triggered before any update operation on tables
-- it sets the updated_at field to the current timestamp
create or replace function handle_updated_at()
returns trigger as $$
begin
  -- set the updated_at column to current timestamp
  new.updated_at = now();
  return new;
end;
$$ language plpgsql;
