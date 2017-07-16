module Shoppe
	module ProductsHelper

		def fetch_product id
			if /\A\d+\z/.match(id)
      			id = id.to_i
      			product =Shoppe::Product.where(active: [true,false]).find(id.to_i)
      		else
				product =Shoppe::Product.where(active: [true,false]).find_by_permalink(id)
			end

			return product
		end

	end
end