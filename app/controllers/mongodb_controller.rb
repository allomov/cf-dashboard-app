require 'mongodb_manager'

class MongodbController < ApplicationController
  
  def create
  	counter = MongodbManager.collection.count
    MongodbManager.collection.insert({ :counter => counter + 1 })
  end

end
