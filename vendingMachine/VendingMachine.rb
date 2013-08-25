require_relative '../lib/shell'
require_relative 'Item'
class VendingMachine < Shell
	attr_accessor :items
	attr_accessor:total
	attr_accessor:ds
	def initialize(datasource)
		super()
		@ds = datasource
		@total = 0.0
	end

	# def initialize
	# 	super
	# 	@items = {}
	# 	@items["A1"] = Item.new( "A1", "Almond Joy", 0.50, 1)
	# 	@total = 0.0
	# end

	def displayItems
		# self.items.each{|k,v|
		# 	output.puts v
		# }

		items = self.ds.getItems()
		items.each{|k,v|
			output.puts v
		}
	end

	def inputMoney(amount)

		if not amount.to_f > 0.0
			raise ArgumentError, "must be a number greater than 0.00"
		end
		@total += amount.to_f
	end

	def selectItem(code)
		item = ds.getItem(code)

		#if not @items.has_key? id
		if not item
			raise ItemNotFoundException, "selected item was not found."
		end

		#item = @items[id];
		if item.quantity == 0
			output.puts "sold out"
		elsif item.price > @total
			output.puts "more money required"
		else
			dispenseItem(item)
			calculateChange(@total - item.price)
			return item
		end
	end

	def dispenseItem(item)
		output.puts item
	end

	def calculateChange(amount)
		quarters = 0
		dimes = 0
		nickels = 0
		pennys = 0
		rc = ""

		change = (amount *100)

		if change >= 25
			quarters = (change/25).to_i
			change = change % 25

			rc << "Quarters: #{quarters}"
		end
		if change >= 10
			dimes = (change/10).to_i
			change = change % 10

			rc << (rc.length > 0 ? ", " : "")
			rc << "Dimes: #{dimes}"
		end
		if change >= 5
			nickels = (change/5).to_i
			change = change % 5
			rc << (rc.length > 0 ? ", " : "")
			rc << "Nickels: #{nickels}"
		end
		if change >= 1 
			pennys = change.to_i
			rc << (rc.length > 0 ? ", " : "")
			rc << "Pennies: #{pennys}"
		end
		output.puts rc

	end
end


class ItemNotFoundException < Exception

end