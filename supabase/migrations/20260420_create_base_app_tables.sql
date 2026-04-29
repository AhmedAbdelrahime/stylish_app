create extension if not exists pgcrypto;

create or replace function public.set_updated_at()
returns trigger
language plpgsql
as $$
begin
  new.updated_at = timezone('utc', now());
  return new;
end;
$$;

create table if not exists public.profiles (
  id uuid primary key references auth.users (id) on delete cascade,
  email text not null,
  full_name text null,
  image text null,
  address text null,
  city text null,
  state text null,
  country text null,
  pincode text null,
  role text not null default 'user',
  created_at timestamptz not null default timezone('utc', now()),
  updated_at timestamptz not null default timezone('utc', now())
);

create index if not exists profiles_email_idx on public.profiles (email);

drop trigger if exists trg_profiles_updated_at on public.profiles;
create trigger trg_profiles_updated_at
before update on public.profiles
for each row
execute function public.set_updated_at();

create or replace function public.handle_new_user_profile()
returns trigger
language plpgsql
security definer
set search_path = public
as $$
begin
  insert into public.profiles (id, email, full_name)
  values (
    new.id,
    coalesce(new.email, ''),
    new.raw_user_meta_data->>'full_name'
  )
  on conflict (id) do update
  set
    email = excluded.email,
    full_name = coalesce(public.profiles.full_name, excluded.full_name);

  return new;
end;
$$;

drop trigger if exists on_auth_user_created_profile on auth.users;
create trigger on_auth_user_created_profile
after insert on auth.users
for each row
execute function public.handle_new_user_profile();

alter table public.profiles enable row level security;

drop policy if exists "Users can view their profile" on public.profiles;
create policy "Users can view their profile"
on public.profiles
for select
using (auth.uid() = id);

drop policy if exists "Users can insert their profile" on public.profiles;
create policy "Users can insert their profile"
on public.profiles
for insert
with check (auth.uid() = id);

drop policy if exists "Users can update their profile" on public.profiles;
create policy "Users can update their profile"
on public.profiles
for update
using (auth.uid() = id)
with check (auth.uid() = id);

create table if not exists public.payment_methods (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references auth.users (id) on delete cascade,
  holder_name text not null,
  last4 text not null,
  brand text not null,
  exp_month integer null,
  exp_year integer null,
  created_at timestamptz not null default timezone('utc', now()),
  updated_at timestamptz not null default timezone('utc', now())
);

create index if not exists payment_methods_user_id_idx
on public.payment_methods (user_id);

drop trigger if exists trg_payment_methods_updated_at on public.payment_methods;
create trigger trg_payment_methods_updated_at
before update on public.payment_methods
for each row
execute function public.set_updated_at();

alter table public.payment_methods enable row level security;

drop policy if exists "Users can view their payment methods" on public.payment_methods;
create policy "Users can view their payment methods"
on public.payment_methods
for select
using (auth.uid() = user_id);

drop policy if exists "Users can insert their payment methods" on public.payment_methods;
create policy "Users can insert their payment methods"
on public.payment_methods
for insert
with check (auth.uid() = user_id);

drop policy if exists "Users can update their payment methods" on public.payment_methods;
create policy "Users can update their payment methods"
on public.payment_methods
for update
using (auth.uid() = user_id)
with check (auth.uid() = user_id);

drop policy if exists "Users can delete their payment methods" on public.payment_methods;
create policy "Users can delete their payment methods"
on public.payment_methods
for delete
using (auth.uid() = user_id);

create table if not exists public.products (
  id uuid primary key default gen_random_uuid(),
  name text not null,
  price numeric(10, 2) not null default 0,
  sale_price numeric(10, 2) null,
  title text not null default '',
  description text not null default '',
  rating numeric(3, 2) not null default 0,
  main_image_url text null,
  image_urls text[] not null default '{}',
  sizes integer[] not null default '{}',
  category_id uuid null,
  stock_quantity integer not null default 0,
  low_stock_threshold integer not null default 5,
  status text not null default 'active',
  featured boolean not null default false,
  sku text null,
  created_at timestamptz not null default timezone('utc', now()),
  updated_at timestamptz not null default timezone('utc', now())
);

create index if not exists products_status_idx on public.products (status);
create index if not exists products_featured_idx on public.products (featured);
create index if not exists products_created_at_idx on public.products (created_at desc);
create index if not exists products_category_id_idx on public.products (category_id);

drop trigger if exists trg_products_updated_at on public.products;
create trigger trg_products_updated_at
before update on public.products
for each row
execute function public.set_updated_at();

alter table public.products enable row level security;

drop policy if exists "Anyone can view products" on public.products;
create policy "Anyone can view products"
on public.products
for select
using (true);

create table if not exists public.reviews (
  id uuid primary key default gen_random_uuid(),
  product_id uuid not null references public.products (id) on delete cascade,
  reviewer_name text not null default 'Customer',
  reviewer_image_url text null,
  comment text not null default '',
  rating numeric(3, 2) not null default 0,
  created_at timestamptz not null default timezone('utc', now())
);

create index if not exists reviews_product_id_idx on public.reviews (product_id);
create index if not exists reviews_created_at_idx on public.reviews (created_at desc);

alter table public.reviews enable row level security;

drop policy if exists "Anyone can view reviews" on public.reviews;
create policy "Anyone can view reviews"
on public.reviews
for select
using (true);
