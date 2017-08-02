module MerchantAnalyzerHelper
  def get_merchant_ids
    @se.call_merchants.map do |merchant|
      merchant.id
    end
  end

  def create_merchant_invoice_hash(merchant_ids, merchant_invoice_hash)
    merchant_ids.each do |merchant_id|
      merchant_invoice_hash[merchant_id] =
      @se.invoices.find_all_by_merchant_id(merchant_id)
    end
  end

  def generate_combined_hash(merchant_invoice_hash, combined_hash)
    merchant_invoice_hash.each do |merchant_id, invoice_array|
      combined_hash[merchant_id] = hash_converter(invoice_array)
    end
  end

  def generate_results(x, sorted_by_revenue, results)
    counter = x
    while counter > 0
      results << sorted_by_revenue.pop
      counter -= 1
    end
  end

  def parse_results(results)
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

  def generate_all_merchant_list(sorted_by_revenue, results)
    while sorted_by_revenue.length > 0
      results << sorted_by_revenue.pop
    end
  end

  def iterate_invoices(invoice_collection)
    invoice_collection.map do |invoice|
      @se.invoice_items.find_all_by_invoice_id(invoice.id)
    end
  end

  def get_items_from_array(invoice_items_array)
    new_array = []
    invoice_items_array.each do |invoice_item|
      num = invoice_item.quantity.to_i
      num.times do
        new_array << invoice_item.item_id
      end
    end
    new_array
  end

  def get_hash(item_ids)
    count = {}
    item_ids.each do |item_id|
      if count.key?(item_id)
        count[item_id] += 1
      else
      count[item_id] = 1
      end
    end
    count
  end

  def get_max(hash)
    max = hash.values.max
    items_with_count = hash.find_all do |item_id, count|
      count == max
    end
    items_with_count.map do |array|
      array[0]
    end
  end

  def get_items(items)
    items.map do |id|
      @se.items.find_by_id(id)
    end
  end

  def create_revenue_hash(invoice_items)
    revenue_hash = {}
    invoice_items.each do |invoice_item|
      id = invoice_item.item_id
      revenue = (invoice_item.quantity.to_i * invoice_item.unit_price)
      if revenue_hash.key?(id)
        revenue_hash[id] += revenue
      else
        revenue_hash[id] = revenue
      end
    end
    revenue_hash
  end

  def get_max_revenue(revenue_hash)
    max = revenue_hash.values.max
    revenue_array = revenue_hash.find do |item_id, revenue|
      revenue == max
    end
    @se.items.find_by_id(revenue_array[0])
  end

  def get_valid_invoices(invoices)
    valid = []
    invoices.each do |invoice|
      if invoice.is_paid_in_full?
        valid << invoice
      end
    end
    valid
  end
end