module Calculator
  
  def number_of_items_per_merchant
    @se.call_merchants.map do |merchant_obj|
      merchant_id = merchant_obj.id
      items = @se.items.find_all_by_merchant_id(merchant_id)
      items.count
    end
  end

  def get_variance_merchants(merchant_items)
    average = average_items_per_merchant
    merchant_items.map do |num|
      (num - average)**2
    end
  end

  def get_all_costs
    @se.call_items.map do |item_obj|
      item_obj.unit_price
    end
  end

  def average_all_costs(all_costs)
    (all_costs.sum / all_costs.length).round(2)
  end

  def get_variance_item_costs(all_costs)
    average = average_all_costs(all_costs)
    all_costs.map do |num|
      (num - average)**2
    end
  end

  def average_price_per_item
    total_cost = []
    @se.call_items.each do |item|
      total_cost << item.unit_price
    end
    (total_cost.sum / @se.call_items.count.to_f).round(2)
  end

  def number_of_invoices_per_merchant
    @se.call_invoices.map do |invoice_obj|
      merchant_id = invoice_obj.merchant_id
      invoices = @se.invoices.find_all_by_merchant_id(merchant_id)
      invoices.count
    end
  end

  def get_squares_invoices(merchant_invoices)
    average = average_invoices_per_merchant
    @se.call_merchants.map do |merchant|
      (merchant.invoices.count - average)**2
    end
  end

  def average_invoices_per_day
    (@se.call_invoices.count / 7.0).round(2)
  end

  def get_squares_invoices_per_day(invoices_hash)
    average = average_invoices_per_day
    invoices_hash.map do |invoice|
      (invoice[1] - average)**2
    end
  end

end