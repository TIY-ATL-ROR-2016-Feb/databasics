module Databasics
  class Order < ActiveRecord::Base
    belongs_to :item
  end
end
