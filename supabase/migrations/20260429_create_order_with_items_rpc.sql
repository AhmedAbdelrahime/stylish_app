create or replace function public.create_order_with_items(
  order_payload jsonb,
  item_payloads jsonb
)
returns uuid
language plpgsql
security definer
set search_path = public
as $$
declare
  current_user_id uuid := auth.uid();
  created_order_id uuid;
  item_payload jsonb;
begin
  if current_user_id is null then
    raise exception 'User not logged in';
  end if;

  if item_payloads is null
     or jsonb_typeof(item_payloads) <> 'array'
     or jsonb_array_length(item_payloads) = 0 then
    raise exception 'Your cart is empty.';
  end if;

  insert into public.orders (
    user_id,
    status,
    payment_status,
    delivery_status,
    subtotal,
    shipping_fee,
    discount_amount,
    total_amount,
    currency,
    shipping_address,
    notes
  )
  values (
    current_user_id,
    coalesce(order_payload->>'status', 'pending'),
    coalesce(order_payload->>'payment_status', 'pending'),
    coalesce(order_payload->>'delivery_status', 'pending'),
    coalesce((order_payload->>'subtotal')::numeric, 0),
    coalesce((order_payload->>'shipping_fee')::numeric, 0),
    coalesce((order_payload->>'discount_amount')::numeric, 0),
    coalesce((order_payload->>'total_amount')::numeric, 0),
    coalesce(order_payload->>'currency', 'INR'),
    nullif(order_payload->>'shipping_address', ''),
    nullif(order_payload->>'notes', '')
  )
  returning id into created_order_id;

  for item_payload in select value from jsonb_array_elements(item_payloads)
  loop
    insert into public.order_items (
      order_id,
      product_id,
      product_name,
      product_title,
      product_image_url,
      unit_price,
      quantity,
      selected_size
    )
    values (
      created_order_id,
      nullif(item_payload->>'product_id', '')::uuid,
      coalesce(nullif(item_payload->>'product_name', ''), 'Product'),
      nullif(item_payload->>'product_title', ''),
      nullif(item_payload->>'product_image_url', ''),
      coalesce((item_payload->>'unit_price')::numeric, 0),
      coalesce((item_payload->>'quantity')::integer, 1),
      nullif(item_payload->>'selected_size', '')::integer
    );
  end loop;

  return created_order_id;
end;
$$;

revoke all on function public.create_order_with_items(jsonb, jsonb) from public;
grant execute on function public.create_order_with_items(jsonb, jsonb) to authenticated;
