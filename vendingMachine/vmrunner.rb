require_relative 'VendingMachine'
require_relative 'DAL.rb'
class VMRunner
end

data = VMDataAccessSqlite.new('vending-machine.db')
VendingMachine.new(data).start