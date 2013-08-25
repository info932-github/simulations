require 'test/unit'
require 'stringio'
require_relative '../VendingMachine.rb'
require_relative '../Item'
require_relative '../DAL.rb'
class VendingMachineTests < Test::Unit::TestCase
	attr_accessor:db
	def setup
		@db = VMDataAccessSqlite.new('vending-machine-test.db') 
		@db.db.execute_batch  <<SQL 
			CREATE TABLE IF NOT EXISTS items (
				idx INTEGER PRIMARY KEY, 
				code VARCHAR(255), 
				type INTEGER, 
				description VARCHAR(255),  
				price DOUBLE,  
				quantity INT);
			insert into items(code, type, description, price, quantity) values('A1', 2,'Almond Joy', 0.50, 5);
SQL
		# @db.db.execute(sql)
	end

		def teardown
			if @db
				File.delete('vending-machine-test.db')
			end
		end

	def test_displayItems
		#expect an array of Item objects
		#vm = VendingMachine.new
		vm = VendingMachine.new(@db)
		output = StringIO.new
		vm.output = output	

		vm.displayItems
		# assert_equal 1, vm.items.length
		expected = "A1, 2, Almond Joy, 0.5, 5"
		assert_equal expected, output.string.strip
	end

	def test_inputMoney
		#if not money, raise error
		#vm = VendingMachine.new
		vm = VendingMachine.new(@db)
		output = StringIO.new
		vm.output = output	

		assert_raise(ArgumentError){vm.inputMoney('abcd')}
		#vending machine total should increase by amount given
		ttl = vm.inputMoney(0.25)
		assert_equal(0.25, vm.total)
		assert_equal(ttl, vm.total)
	end

	def test_selectItem_raise_NotFoundException
		#test to make sure the item exists

		# vm = VendingMachine.new
		vm = VendingMachine.new(@db)
		assert_raise(ItemNotFoundException){
			vm.selectItem("b2")	
		}
	end

# #test to make sure the output is that more money is required
	def test_selectItem_more_money_required
		# vm = VendingMachine.new
		vm = VendingMachine.new(@db)
		vm.output = StringIO.new
		item = vm.selectItem("A1")
		assert_equal("more money required", vm.output.string.strip)
	end
# #test to make sure that the item has quantity
	def test_selectItem_must_have_quantity
		# vm = VendingMachine.new
		vm = VendingMachine.new(@db)
		vm.output = StringIO.new
		# vm.items["A1"].quantity = 0
		item = @db.getItem("A1")
		item.quantity = 0
		@db.updateItem(item)
		vm.inputMoney(0.50)
		item = vm.selectItem("A1")
		assert_equal("sold out", vm.output.string.strip)
	end
# #finally test to make sure that the item is correct
	def test_selectItem
		#vm = VendingMachine.new
		vm = VendingMachine.new(@db)
		vm.output = StringIO.new
		# vm.items["A1"].quantity = 1
		vm.inputMoney(0.50)
		item = vm.selectItem("A1")
		assert_not_nil(item)
		assert_equal("A1", item.code)
		assert_equal("Almond Joy", item.description)
	end
# #test dispensing the item
# #test calculating the change
def test_calculateChange
	# vm = VendingMachine.new
	vm = VendingMachine.new(@db)
	vm.output = StringIO.new
	vm.calculateChange(1.00)
	assert_equal("Quarters: 4", vm.output.string.strip)

	vm.output = StringIO.new
	vm.calculateChange(0.37)
	assert_equal("Quarters: 1, Dimes: 1, Pennies: 2", vm.output.string.strip)
end
#test item to_s
	def test_Item_to_s
		item = Item.new(ItemType::FOOD, 'Almond Joy', 'A1',0.50, 0)
		expected = "A1, 2, Almond Joy, 0.5, 0"
		assert_equal(expected, item.to_s)
	end
end
