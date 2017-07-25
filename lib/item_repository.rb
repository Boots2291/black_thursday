require './lib/item'
require 'pry'

class ItemRepository
  attr_reader :items

  def initialize(items_file_path, se)
    @items = []
    contents = CSV.open items_file_path,
                 headers: true,
                 header_converters: :symbol
    contents.each do |row|
      id = (row[:id]).to_i
      name = row[:name]
      description = row[:description]
      unit_price = (row[:unit_price]).to_i
      created_at = row[:created_at]
      updated_at = row[:updated_at]
      merchant_id = (row[:merchant_id]).to_i
      item = Item.new(id, name, description, unit_price,
                     created_at, updated_at, merchant_id)
      @items << item
    end
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
    prices_to_search = range.to_a
    @items.find_all do |item|
      prices_to_search.include?(item.unit_price)
    end
  end

  def find_all_by_merchant_id(id)
    @items.find_all do |item|
      item.merchant_id == id
    end
  end

end

