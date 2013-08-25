require 'sqlite3'
require_relative 'Item'
require_relative 'VMDataAccessBase'

class VMDataAccessSqlite < VMDataAccessBase

	attr_accessor:db

	def initialize(datasource)
		@db = SQLite3::Database.new(datasource)
		@db.results_as_hash = true
	end

	def getItems()

		items = {}
		self.db.execute("select code, type, description, price, quantity from items") do |row|
			items[row["code"]] = Item.new(row["type"], row["description"], row["code"], row["price"], row["quantity"])
		end
		return items
	end

	def getItem(code)
		row = self.db.get_first_row("select code, type, description, price, quantity from items where code = '#{code}'") 
		if row
			#return Item.new(result["code"], result["description"], result["price"], result["quantity"])
			return Item.new(row["type"], row["description"], row["code"], row["price"], row["quantity"])
		end
	end
	
	def addItem(item)
		sql = "insert into items(code, type, description, price, quantity) values('#{item.code}', #{item.type}, '#{item.description}', #{item.price}, #{item.quantity})"
		
		result = self.db.execute(sql)
	end

	def updateItem(item)
		result = self.db.execute("UPDATE items SET type='#{item.type}', description='#{item.description}',
			price = #{item.price}, quantity = #{item.quantity} where code='#{item.code}'")
	end

	def deleteItem(code)
		result = self.db.execute("delete from items where code='#{code}'")
	end
end