require_relative 'sales_engine'
require_relative 'calculator'
require_relative 'merchant_analyzer'
require_relative 'merchant_analyzer_helper'

class SalesAnalyst

  include Math
  include Calculator
  include MerchantAnalyzer
  include MerchantAnalyzerHelper

  def initialize(se)
    @se = se
  end

  def average_items_per_merchant
    (@se.call_items.count.to_f / @se.call_merchants.count.to_f).round(2)
  end

  def average_items_per_merchant_standard_deviation
    merchant_items = number_of_items_per_merchant
    variance = get_variance_merchants(merchant_items)
    sqrt(variance.sum / (@se.call_merchants.count.to_f - 1)).round(2)
  end

  def cost_standard_deviation
    all_costs = get_all_costs
    variance = get_variance_item_costs(all_costs)
    sqrt(variance.sum / (all_costs.length - 1).to_f).round(2)
  end

  def merchants_with_high_item_count
    high_item_merchants = []
    target = average_items_per_merchant +
             average_items_per_merchant_standard_deviation
    @se.call_merchants.each do |merchant_obj|
      merchant_id = merchant_obj.id
      items = @se.items.find_all_by_merchant_id(merchant_id)
      if items.count >= target
        high_item_merchants << merchant_obj
      end
    end
    high_item_merchants
  end

  def average_item_price_for_merchant(merchant_id)
    all_merchant_items = @se.items.find_all_by_merchant_id(merchant_id)
    all_item_prices = all_merchant_items.map do |item|
      item.unit_price
    end
    (all_item_prices.sum / all_item_prices.count).round(2)
  end

  def average_average_price_per_merchant
    merchant_averages = []
    @se.call_merchants.each do |merchant_obj|
      merchant_id = merchant_obj.id
      merchant_averages << average_item_price_for_merchant(merchant_id)
    end
    (merchant_averages.sum / @se.call_merchants.count).round(2)
  end

  def golden_items
    gold_items = []
    target = average_price_per_item +
             (cost_standard_deviation * 2)
    @se.call_items.each do |item|
      if item.unit_price >= target
        gold_items << item
      end
    end
    gold_items
  end

  def average_invoices_per_merchant
    (@se.call_invoices.count.to_f / @se.call_merchants.count.to_f).round(2)
  end

  def average_invoices_per_merchant_standard_deviation
    merchant_invoices = number_of_invoices_per_merchant
    squares = get_squares_invoices(merchant_invoices)
    sqrt(squares.sum / (@se.call_merchants.count.to_f - 1)).round(2)
  end

  def top_merchants_by_invoice_count
    standard_deviation = average_invoices_per_merchant_standard_deviation
    @se.call_merchants.find_all do |merchant|
      (merchant.invoices.count - average_invoices_per_merchant) >=
      (standard_deviation * 2)
    end
  end

  def bottom_merchants_by_invoice_count
    standard_deviation = average_invoices_per_merchant_standard_deviation
    @se.call_merchants.find_all do |merchant|
      (merchant.invoices.count - average_invoices_per_merchant) <=
      -(standard_deviation * 2)
    end
  end

  def invoice_per_day_standard_deviation
    invoices_hash = @se.invoices_per_day
    squares = get_squares_invoices_per_day(invoices_hash)
    sqrt(squares.sum / 6).round(2)
  end

  def top_days_by_invoice_count
    top_days = []
    standard_deviation = invoice_per_day_standard_deviation
    invoices_by_day = @se.invoices_per_day
    invoices_by_day.keys.find_all do |day|
      if (invoices_by_day[day] - average_invoices_per_day) > standard_deviation
        top_days << day
      end
    end
  end

  def invoice_status(status)
    total_invoices = @se.call_invoices.count
    ((@se.invoices_by_status[status].to_f / total_invoices) * 100.0).round(2)
  end

  #analytics on returned items, which customer returned the most items
  #which item was returned the most, which merchant had the most returned items,
  #which merchant had the most returned revenue
end
