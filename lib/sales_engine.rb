require 'CSV'
require_relative 'item_repository'
require_relative 'merchant_repository'
require_relative 'invoice_repository'
require 'pry'

class SalesEngine

  def self.from_csv(hash)
    SalesEngine.new(hash)
  end

  attr_reader :items,
              :merchants,
              :invoices

  def initialize(hash)
    @items = ItemRepository.new(hash[:items], self)
    @merchants = MerchantRepository.new(hash[:merchants], self)
    @invoices = InvoiceRepository.new(hash[:invoices], self)
  end

  def fetch_merchant_id(merchant_id)
    pass_merchant_id(merchant_id)
  end

  def pass_merchant_id(merchant_id)
    @items.find_all_by_merchant_id(merchant_id)
  end

  def fetch_items_merchant_id(merchant_id)
    pass_items_merchant_id(merchant_id)
  end

  def pass_items_merchant_id(merchant_id)
    @merchants.find_by_id(merchant_id)
  end

  def fetch_invoices_for_merchant(merchant_id)
    @invoices.find_all_by_merchant_id(merchant_id)
  end

  def fetch_merchant_from_invoice_id(merchant_id)
    @merchants.find_by_id(merchant_id)
  end

  def call_merchants
    @merchants.merchants
  end

  def call_items
    @items.items
  end

  def call_invoices
    @invoices.invoices
  end

  def invoices_per_day
    call_invoices.reduce({}) do |days, invoice|
      if days.has_key?(invoice.created_at.strftime('%A'))
        days[invoice.created_at.strftime('%A')] += 1
      else
        days[invoice.created_at.strftime('%A')] = 1
      end
      days
    end
  end

  def invoices_by_status
    invoices.all.reduce({}) do |status, invoice|
      if status.has_key?(invoice.status.to_sym)
        status[invoice.status.to_sym] += 1
      else
        status[invoice.status.to_sym] = 1
      end
      status
    end
  end

end
