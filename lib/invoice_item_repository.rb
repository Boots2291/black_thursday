require_relative 'invoice_item'
require_relative 'loader'
require 'pry'

class InvoiceItemRepository

  include Loader

  attr_reader :invoice_items,
              :se

  def initialize(invoice_items_file_path, se)
    @se = se
    @invoice_items_file_path = invoice_items_file_path
    @invoice_items = []
    load_invoice_items(invoice_items_file_path, se)
  end

  def all
    @invoice_items
  end

  def find_by_id(invoice_item_id)
    @invoice_items.find do |invoice_item|
      invoice_item.id == invoice_item_id
    end
  end

  def find_all_by_item_id(item_id)
    @invoice_items.find_all do |invoice_item|
      invoice_item.item_id == item_id
    end
  end

  def find_all_by_invoice_id(invoice_id)
    @invoice_items.find_all do |invoice_item|
      invoice_item.invoice_id == invoice_id
    end
  end

  def inspect
    "#<#{self.class} #{@invoice_items.size} rows>"
  end

end
