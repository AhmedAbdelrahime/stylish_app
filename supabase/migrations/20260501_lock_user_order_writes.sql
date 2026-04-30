-- User app order permissions.
-- Customers can create orders and view their own order history.
-- Order status changes, edits, cancellations, and stock handling belong to
-- the separated admin dashboard or trusted backend/service-role workflows.

drop policy if exists "Users can update their orders" on public.orders;
drop policy if exists "Users can delete their orders" on public.orders;

drop policy if exists "Users can update their order items" on public.order_items;
drop policy if exists "Users can delete their order items" on public.order_items;
