json.order do
	json.(@order, :id, :total_items, :total_before_tax, :delivery_service, :delivery_price, :delivery_tax_amount, :tax, :total, :model_name, :status)
	json.order_items @order.order_items do |o|
		json.(o, :quantity, :ordered_item, :sub_total, :tax_amount, :total)
	end
end