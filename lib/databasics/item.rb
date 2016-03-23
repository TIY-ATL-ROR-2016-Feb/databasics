module Databasics
  class Item < ActiveRecord::Base
    has_many :orders
    has_many :cookie
  end
end
