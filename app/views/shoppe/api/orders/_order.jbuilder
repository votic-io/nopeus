json.(order, :id, :total_items, :total_before_tax, :delivery_service, :delivery_price, :delivery_tax_amount, :tax, :total, :model_name, :status, :billing_address1, :billing_address2, :billing_address3, :billing_address4, :email_address, :first_name, :last_name, :phone_number, :customer, :received_at)
json.order_items order.order_items do |o|
	json.(o, :quantity, :sub_total, :tax_amount, :total)
	json.ordered_item do
		json.partial! 'shoppe/api/products/item', p: o.ordered_item
	end
end
json.properties order.properties
json.discounts order.active_discounts
json.errors @errors