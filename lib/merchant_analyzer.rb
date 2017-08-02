module MerchantAnalyzer
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
    merchant_ids = get_merchant_ids
    merchant_invoice_hash = {}
    create_merchant_invoice_hash(merchant_ids, merchant_invoice_hash)
    combined_hash = {}
    generate_combined_hash(merchant_invoice_hash, combined_hash)
    sorted_by_revenue = combined_hash.sort_by(&:last)
    results = []
    generate_results(x, sorted_by_revenue, results)
    parse_results(results)
  end

  def merchants_ranked_by_revenue
    merchant_ids = get_merchant_ids
    merchant_invoice_hash = {}
    create_merchant_invoice_hash(merchant_ids, merchant_invoice_hash)
    combined_hash = {}
    generate_combined_hash(merchant_invoice_hash, combined_hash)
    sorted_by_revenue = combined_hash.sort_by(&:last)
    results = []
    generate_all_merchant_list(sorted_by_revenue, results)
    parse_results(results)
  end

  def merchants_with_pending_invoices
    invoices = @se.call_invoices.find_all do |invoice|
      !invoice.is_paid_in_full?
    end
    invoices.map do |invoice|
      invoice.merchant
    end.uniq
  end

  def merchants_with_only_one_item
    @se.call_merchants.find_all do |merchant|
      merchant.items.count == 1
    end
  end

  def merchants_with_only_one_item_registered_in_month(month)
    merchants_with_only_one_item.find_all do |merchant|
      merchant.created_at.strftime('%B') == month
    end
  end

  def most_sold_item_for_merchant(merchant_id)
    invoices = @se.invoices.find_all_by_merchant_id(merchant_id)
    valid_invoices = get_valid_invoices(invoices)
    invoice_items = iterate_invoices(valid_invoices).flatten
    item_ids = get_items_from_array(invoice_items)
    hash = get_hash(item_ids)
    items = get_max(hash)
    get_items(items)
  end

  def revenue_by_merchant(merchant_id)
    invoices = @se.invoices.find_all_by_merchant_id(merchant_id)
    invoice_items = iterate_invoices(invoices)
    sum_invoice_items(invoice_items)
  end

  def best_item_for_merchant(merchant_id)
    invoices = @se.invoices.find_all_by_merchant_id(merchant_id)
    valid_invoices = get_valid_invoices(invoices)
    invoice_items = iterate_invoices(valid_invoices).flatten
    revenue_hash = create_revenue_hash(invoice_items)
    get_max_revenue(revenue_hash)
  end

end