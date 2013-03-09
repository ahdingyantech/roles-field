require 'mysql2'
require 'active_record'

dbconfig = {
  :adapter  => 'mysql2',
  :database => 'roles-field-test',
  :username => 'root',
  :encoding => 'utf8'
}

database = dbconfig.delete(:database)

ActiveRecord::Base.establish_connection(dbconfig)

begin
  ActiveRecord::Base.connection.create_database database
rescue ActiveRecord::StatementInvalid => e # database already exists
end

ActiveRecord::Base.establish_connection(dbconfig.merge(:database => database))

ActiveRecord::Migration.verbose = false