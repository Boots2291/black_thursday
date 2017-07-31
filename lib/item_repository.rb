require_relative 'item'
require_relative 'loader'
require 'pry'

class ItemRepository

  include Loader

  attr_reader :items,
              :se

  def initialize(items_file_path, se)
    @se = se
    @items_file_path = items_file_path
    @items = []
    load_items(items_file_path, se)
  end

  def all
    @items
  end

  def find_by_id(item_id)
    @items.find do |item|
      item.id == item_id
    end
  end

  def find_by_name(item_name)
    @items.find do |item|
      item.name.downcase == item_name.downcase
    end
  end

  def find_all_with_description(fragment)
    @items.find_all do |item|
      item.description.downcase.include?(fragment.downcase)
    end
  end

  def find_all_by_price(price)
    @items.find_all do |item|
      item.unit_price == price
    end
  end

  def find_all_by_price_in_range(range)
    @items.find_all do |item|
      range.include?(item.unit_price)
    end
  end

  def find_all_by_merchant_id(id)
    @items.find_all do |item|
      item.merchant_id == id
    end
  end

  def fetch_items_merchant_id(merchant_id)
    se.fetch_items_merchant_id(merchant_id)
  end

  def inspect
    "#<#{self.class} #{@items.size} rows>"
  end

end

