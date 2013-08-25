require 'sqlite3'

db = SQLite3::Database.new('vending-machine.db')
db.execute_batch  <<SQL 
			CREATE TABLE IF NOT EXISTS items (
				idx INTEGER PRIMARY KEY, 
				code VARCHAR(255),  
				type INTEGER,
				description VARCHAR(255),  
				price DOUBLE,  
				quantity INT);
		
	DELETE FROM ITEMS;
	insert into items(code,type, description, price, quantity) values('A1',2,'Almond Joy', 0.50, 5);	
	insert into items(code,type, description, price, quantity) values('B1',2,'Mounds', 0.50, 4);
	insert into items(code,type, description, price, quantity) values('C1',2,'Nestle Crunch', 0.65, 7);
	insert into items(code,type, description, price, quantity) values('D1',2,'Popcorn', 0.95, 10);
SQL

