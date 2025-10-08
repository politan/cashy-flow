-- migration: create profiles table
-- description: extends auth.users with application-specific user data
-- affected objects: profiles table
-- special considerations: one-to-one relationship with auth.users, cascading delete on user removal

-- create profiles table to store application-specific user data
-- this table extends the supabase auth.users table with custom fields
create table profiles (
  -- primary key references auth.users for one-to-one relationship
  -- cascading delete ensures profile is removed when user account is deleted
  id uuid primary key references auth.users(id) on delete cascade,
  
  -- timestamp of profile creation, automatically set on insert
  created_at timestamptz not null default now(),
  
  -- timestamp of last profile modification, updated via trigger
  updated_at timestamptz not null default now()
);

-- enable row level security on profiles table
-- ensures users can only access their own profile data
alter table profiles enable row level security;

-- rls policy: allow authenticated users to read their own profile
-- rationale: users need to view their own profile information
create policy "allow authenticated users to select own profile"
on profiles for select
to authenticated
using (auth.uid() = id);

-- rls policy: allow anonymous users to read their own profile
-- rationale: supports scenarios where profile data might be accessed during registration
create policy "allow anonymous users to select own profile"
on profiles for select
to anon
using (auth.uid() = id);

-- rls policy: allow authenticated users to insert their own profile
-- rationale: users can create their profile during onboarding
create policy "allow authenticated users to insert own profile"
on profiles for insert
to authenticated
with check (auth.uid() = id);

-- rls policy: allow authenticated users to update their own profile
-- rationale: users need to modify their own profile information
create policy "allow authenticated users to update own profile"
on profiles for update
to authenticated
using (auth.uid() = id);

-- rls policy: allow authenticated users to delete their own profile
-- rationale: supports account deletion workflows
create policy "allow authenticated users to delete own profile"
on profiles for delete
to authenticated
using (auth.uid() = id);

-- create trigger to automatically update updated_at timestamp
-- this ensures the updated_at field always reflects the last modification time
create trigger on_update_profiles
before update on profiles
for each row
execute procedure handle_updated_at();
