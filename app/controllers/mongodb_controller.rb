require 'mongodb_manager'

class MongodbController < ApplicationController
  protect_from_forgery except: :create
  
  def create
  	counter = MongodbManager.collection.count
    MongodbManager.collection.insert({ :counter => counter + 1 })
    render :nothing => true, :status => 200, :content_type => 'text/html'
  end

end
