require_relative 'sales_engine'
require_relative 'calculator'
require 'pry'

class SalesAnalyst

  include Math
  include Calculator

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

  def total_revenue_by_date(date)
    invoices_on_date = get_invoices_on_date(date)
    invoice_ids = get_invoice_ids(invoices_on_date)
    invoice_items = @se.fetch_invoice_items_with_invoice_id(invoice_ids.uniq)
    sum_invoice_items(invoice_items)
  end

  def get_invoices_on_date(date)
    @se.call_invoices.find_all do |invoice|
      invoice.created_at.strftime("%Y-%m-%d") == date.strftime("%Y-%m-%d")
    end
  end

  def get_invoice_ids(invoices_on_date)
    invoices_on_date.map do |invoice|
      invoice.id
    end
  end

  def sum_invoice_items(invoice_items)
    invoice_items[0].map do |item|
      (item.unit_price * item.quantity.to_i)
    end.sum
  end

  def top_revenue_earners(x = 20)
    merchant_ids = @se.call_merchants.map do |merchant|
      merchant.id
    end
    merchant_invoice_hash = {}
    merchant_ids.each do |merchant_id|
      merchant_invoice_hash[merchant_id] =
      @se.invoices.find_all_by_merchant_id(merchant_id)
    end
    new_hash = {}
    merchant_invoice_hash.each do |merchant_id, invoice_array|
      new_hash[merchant_id] = hash_converter(invoice_array)
    end
    new_array = new_hash.sort_by(&:last)
    results = []
    counter = x
    while counter > 0
      results << new_array.pop
      counter -= 1
    end
    results.map! do |result|
      @se.merchants.find_by_id(result[0])
    end
  end

  def hash_converter(invoice_array)
    invoice_ids = get_invoice_ids_from_array(invoice_array)
    invoice_items = get_invoice_items(invoice_ids)
    sum_prices(invoice_items)
  end

  def get_invoice_ids_from_array(invoice_array)
    invoice_array.map do |invoice|
      if invoice.is_paid_in_full?
        invoice.id
      end
    end
  end

  def get_invoice_items(invoice_ids_array)
    invoice_ids_array.map do |invoice_id|
      @se.invoices.fetch_invoice_items_from_invoice_id(invoice_id)
    end
  end

  def sum_prices(invoice_items_array)
    invoice_items_array.map do |invoice_item_array|
      iterate_invoice_items(invoice_item_array)
    end.sum
  end

  def iterate_invoice_items(invoice_item_array)
    invoice_item_array.map do |invoice_item|
      (invoice_item.unit_price * invoice_item.quantity.to_i)
    end.sum
  end

end












