require 'test/unit'
require 'stringio'
require_relative '../DAL.rb'
require_relative '../Item'
class Testsdb < Test::Unit::TestCase
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

	def test_getItems()	
		#db = VMDataAccessSqlite.new('vending-machine-test.db')

		assert_not_nil(@db.db)
		items = @db.getItems()
		assert_not_nil(items)
		assert_equal(1, items.length)
		item = items['A1']
		assert_equal('A1', item.code)
	end

	def test_getItem
		item = self.db.getItem('A1')
		assert_not_nil(item)
		assert_equal('A1', item.code)
		assert_equal(ItemType::FOOD, item.type)
		assert_equal('Almond Joy', item.description)
		assert_equal(0.5, item.price)
		assert_equal(5, item.quantity)
	end
	
	def test_addItem
		newitem = Item.new(ItemType::FOOD, "Mounds", "B1", 0.45, 2)
		self.db.addItem(newitem)
		#assert that the item was added
		item = self.db.getItem('B1')
		assert_not_nil(item)
		assert_equal('B1', item.code)
		assert_equal(ItemType::FOOD, item.type)
		assert_equal('Mounds', item.description)
		assert_equal(0.45, item.price)
		assert_equal(2, item.quantity)
	end

	def test_updateItem
		newitem = Item.new(ItemType::FOOD, "Mounds", "B1",0.45, 2)
		self.db.addItem(newitem)
		newitem = Item.new(ItemType::DRINK, "Coke", "B1", 0.75, 4)
		self.db.updateItem(newitem)
		#assert that the item was added
		item = self.db.getItem('B1')
		assert_not_nil(item)
		assert_equal('B1', item.code)
		assert_equal(ItemType::DRINK, item.type)
		assert_equal('Coke', item.description)
		assert_equal(0.75, item.price)
		assert_equal(4, item.quantity)
	end

	def test_deleteItem
		self.db.deleteItem("A1")
		item = self.db.getItem('A1')
		assert_nil(item)
	end
end