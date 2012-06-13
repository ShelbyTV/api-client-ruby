class User
  include MongoMapper::Document

  connection Mongo::Connection.new["my_db"]


  key :id, String
 
end
