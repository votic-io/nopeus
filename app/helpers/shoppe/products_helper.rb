module Shoppe
	module ProductsHelper

		def fetch_product id
			if /\A\d+\z/.match(id)
      			id = id.to_i
      			product =Shoppe::Product.root.find(id.to_i)
      		else
				product =Shoppe::Product.root.find_by_permalink(id)
			end

			return product
		end

	end
end