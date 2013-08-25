module ItemType
	DRINK = 1
	FOOD = 2
end

class Item
	attr_accessor:type
	attr_accessor:description
	attr_accessor:code
	attr_accessor:price
	attr_accessor:quantity

	def initialize(type, description, code, price, quantity)
		@type = type
		@description = description
		@code = code
		@price = price
		@quantity = quantity
	end

	def to_s
		return "#{@code}, #{@type}, #{@description}, #{@price}, #{@quantity}"
	end
end