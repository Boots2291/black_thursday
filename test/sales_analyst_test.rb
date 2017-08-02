require './test/test_helper'
require './lib/sales_engine.rb'
require './lib/sales_analyst.rb'
require 'bigdecimal'

class SalesAnalystTest < Minitest::Test

  def test_it_exists
    se = SalesEngine.from_csv({:items => './data/items_short.csv',
                               :merchants => './data/merchants_short.csv',
                               :invoices => './data/invoices_short.csv',
                               :invoice_items => './data/invoice_items_short.csv',
                               :transactions => './data/transactions_short.csv',
                               :customers => './data/customers_short.csv'})
    sa = SalesAnalyst.new(se)

    assert_instance_of SalesAnalyst, sa
  end

  def test_it_can_find_average_items_per_merchant
    se = SalesEngine.from_csv({:items => './data/items_short.csv',
                               :merchants => './data/merchants_short.csv',
                               :invoices => './data/invoices_short.csv',
                               :invoice_items => './data/invoice_items_short.csv',
                               :transactions => './data/transactions_short.csv',
                               :customers => './data/customers_short.csv'})
    sa = SalesAnalyst.new(se)

    target = sa.average_items_per_merchant

    assert_equal 0.77, target
  end

  def test_it_can_find_the_standard_deviation
    se = SalesEngine.from_csv({:items => './data/items_short.csv',
                               :merchants => './data/merchants_short.csv',
                               :invoices => './data/invoices_short.csv',
                               :invoice_items => './data/invoice_items_short.csv',
                               :transactions => './data/transactions_short.csv',
                               :customers => './data/customers_short.csv'})
    sa = SalesAnalyst.new(se)

    target = sa.average_items_per_merchant_standard_deviation

    assert_equal 0.74, target
  end

  def test_returns_array_of_items_per_merchant
    se = SalesEngine.from_csv({:items => './data/items_short.csv',
                               :merchants => './data/merchants_short.csv',
                               :invoices => './data/invoices_short.csv',
                               :invoice_items => './data/invoice_items_short.csv',
                               :transactions => './data/transactions_short.csv',
                               :customers => './data/customers_short.csv'})
    sa = SalesAnalyst.new(se)

    target = sa.number_of_items_per_merchant

    assert_equal 13, target.count
    assert_equal 1, target[0]
  end

  def test_it_returns_variance
    se = SalesEngine.from_csv({:items => './data/items.csv',
                               :merchants => './data/merchants.csv',
                               :invoices => './data/invoices.csv',
                               :invoice_items => './data/invoice_items.csv',
                               :transactions => './data/transactions.csv',
                               :customers => './data/customers.csv'})
    sa = SalesAnalyst.new(se)

    target = sa.get_variance_merchants([3, 4, 5])
    expected = [0.014400000000000026, 1.2544000000000002, 4.494400000000001]
    assert_equal expected, target
  end

  def test_for_merchants_with_high_item_counts
    se = SalesEngine.from_csv({:items => './data/items.csv',
                               :merchants => './data/merchants.csv',
                               :invoices => './data/invoices.csv',
                               :invoice_items => './data/invoice_items.csv',
                               :transactions => './data/transactions.csv',
                               :customers => './data/customers.csv'})
    sa = SalesAnalyst.new(se)

    target = sa.merchants_with_high_item_count

    assert_equal Array, target.class
    assert_equal 52, target.count
  end

  def test_average_item_price_for_merchant
    se = SalesEngine.from_csv({:items => './data/items.csv',
                               :merchants => './data/merchants.csv',
                               :invoices => './data/invoices.csv',
                               :invoice_items => './data/invoice_items.csv',
                               :transactions => './data/transactions.csv',
                               :customers => './data/customers.csv'})
    sa = SalesAnalyst.new(se)

    target = sa.average_item_price_for_merchant(12334159)

    assert_equal BigDecimal.new("315".insert(-2, ".")), target
  end

  def test_average_price_among_all_merchants
    se = SalesEngine.from_csv({:items => './data/items.csv',
                               :merchants => './data/merchants.csv',
                               :invoices => './data/invoices.csv',
                               :invoice_items => './data/invoice_items.csv',
                               :transactions => './data/transactions.csv',
                               :customers => './data/customers.csv'})
    sa = SalesAnalyst.new(se)

    target = sa.average_average_price_per_merchant

    assert_equal BigDecimal.new("35029".insert(-3, ".")), target
  end

  def test_for_golden_items
    se = SalesEngine.from_csv({:items => './data/items_short.csv',
                               :merchants => './data/merchants_short.csv',
                               :invoices => './data/invoices_short.csv',
                               :invoice_items => './data/invoice_items_short.csv',
                               :transactions => './data/transactions_short.csv',
                               :customers => './data/customers_short.csv'})
    sa = SalesAnalyst.new(se)

    target = sa.golden_items

    assert_equal Array, target.class
    assert_equal 1, target.count
  end

  def test_for_average_invoices_per_merchant
    se = SalesEngine.from_csv({:items => './data/items_short.csv',
                               :merchants => './data/merchants_short.csv',
                               :invoices => './data/invoices_short.csv',
                               :invoice_items => './data/invoice_items_short.csv',
                               :transactions => './data/transactions_short.csv',
                               :customers => './data/customers_short.csv'})
    sa = SalesAnalyst.new(se)

    target = sa.average_invoices_per_merchant

    assert_equal 1.15, target
  end

  def test_for_average_invoices_per_merchant_standard_deviation
    se = SalesEngine.from_csv({:items => './data/items.csv',
                               :merchants => './data/merchants.csv',
                               :invoices => './data/invoices.csv',
                               :invoice_items => './data/invoice_items.csv',
                               :transactions => './data/transactions.csv',
                               :customers => './data/customers.csv'})
    sa = SalesAnalyst.new(se)

    target = sa.average_invoices_per_merchant_standard_deviation

    assert_equal 3.29, target
  end

  def test_for_merchants_with_high_invoice_counts
    se = SalesEngine.from_csv({:items => './data/items.csv',
                               :merchants => './data/merchants.csv',
                               :invoices => './data/invoices.csv',
                               :invoice_items => './data/invoice_items.csv',
                               :transactions => './data/transactions.csv',
                               :customers => './data/customers.csv'})
    sa = SalesAnalyst.new(se)

    target = sa.top_merchants_by_invoice_count

    assert_equal Array, target.class
    assert_equal 12, target.count
  end

  def test_for_merchants_with_low_invoice_counts
    se = SalesEngine.from_csv({:items => './data/items.csv',
                               :merchants => './data/merchants.csv',
                               :invoices => './data/invoices.csv',
                               :invoice_items => './data/invoice_items.csv',
                               :transactions => './data/transactions.csv',
                               :customers => './data/customers.csv'})
    sa = SalesAnalyst.new(se)

    target = sa.bottom_merchants_by_invoice_count

    assert_equal Array, target.class
    assert_equal 4, target.count
  end

  def test_it_can_return_top_days_by_invoice_count
    se = SalesEngine.from_csv({:items => './data/items_short.csv',
                               :merchants => './data/merchants_short.csv',
                               :invoices => './data/invoices_short.csv',
                               :invoice_items => './data/invoice_items_short.csv',
                               :transactions => './data/transactions_short.csv',
                               :customers => './data/customers_short.csv'})
    sa = SalesAnalyst.new(se)

    target = sa.top_days_by_invoice_count

    assert_equal ["Friday", "Monday"], target
  end

  def test_it_can_return_invoice_status
    se = SalesEngine.from_csv({:items => './data/items.csv',
                               :merchants => './data/merchants.csv',
                               :invoices => './data/invoices.csv',
                               :invoice_items => './data/invoice_items.csv',
                               :transactions => './data/transactions.csv',
                               :customers => './data/customers.csv'})
    sa = SalesAnalyst.new(se)

    target_1 = sa.invoice_status(:pending)
    target_2 = sa.invoice_status(:shipped)
    target_3 = sa.invoice_status(:returned)

    assert_equal 29.55, target_1
    assert_equal 56.95, target_2
    assert_equal 13.5, target_3
  end

  def test_it_can_return_total_revenue_by_date
    se = SalesEngine.from_csv({:items => './data/items_short.csv',
                               :merchants => './data/merchants_short.csv',
                               :invoices => './data/invoices_short.csv',
                               :invoice_items => './data/invoice_items_short.csv',
                               :transactions => './data/transactions_short.csv',
                               :customers => './data/customers_short.csv'})
    sa = SalesAnalyst.new(se)

    target = sa.total_revenue_by_date(Time.parse("2009-02-07"))

    assert_equal BigDecimal.new("2106777".insert(-3, ".")), target
  end

  def test_it_can_return_top_earners
    se = SalesEngine.from_csv({:items => './data/items_short.csv',
                               :merchants => './data/merchants_short.csv',
                               :invoices => './data/invoices_short.csv',
                               :invoice_items => './data/invoice_items_short.csv',
                               :transactions => './data/transactions_short.csv',
                               :customers => './data/customers_short.csv'})
    sa = SalesAnalyst.new(se)

    target = sa.top_revenue_earners(5)
    target_1 = sa.top_revenue_earners(1)
    merchant = se.merchants.find_by_id(12334105)

    assert_equal 5, target.count
    assert_equal [merchant], target_1
  end

  def test_it_can_return_merchants_ranked_by_revenue
    se = SalesEngine.from_csv({:items => './data/items_short.csv',
                               :merchants => './data/merchants_short.csv',
                               :invoices => './data/invoices_short.csv',
                               :invoice_items => './data/invoice_items_short.csv',
                               :transactions => './data/transactions_short.csv',
                               :customers => './data/customers_short.csv'})
    sa = SalesAnalyst.new(se)

    target = sa.merchants_ranked_by_revenue

    assert_equal 13, target.count
    assert_instance_of Merchant, target[0]
  end

  def test_it_can_return_merchants_with_pending_invoices
    se = SalesEngine.from_csv({:items => './data/items.csv',
                               :merchants => './data/merchants.csv',
                               :invoices => './data/invoices.csv',
                               :invoice_items => './data/invoice_items.csv',
                               :transactions => './data/transactions.csv',
                               :customers => './data/customers.csv'})
    sa = SalesAnalyst.new(se)

    target = sa.merchants_with_pending_invoices

    assert_equal 467, target.count
    assert_instance_of Merchant, target[0]
  end

  def test_it_can_return_merchants_with_only_one_item
    se = SalesEngine.from_csv({:items => './data/items_short.csv',
                               :merchants => './data/merchants_short.csv',
                               :invoices => './data/invoices_short.csv',
                               :invoice_items => './data/invoice_items_short.csv',
                               :transactions => './data/transactions_short.csv',
                               :customers => './data/customers_short.csv'})
    sa = SalesAnalyst.new(se)

    target = sa.merchants_with_only_one_item

    assert_equal 2, target.count
    assert_instance_of Merchant, target[0]
  end

  def test_it_can_return_merchants_with_one_item_in_month
    se = SalesEngine.from_csv({:items => './data/items.csv',
                               :merchants => './data/merchants.csv',
                               :invoices => './data/invoices.csv',
                               :invoice_items => './data/invoice_items.csv',
                               :transactions => './data/transactions.csv',
                               :customers => './data/customers.csv'})
    sa = SalesAnalyst.new(se)

    target = sa.merchants_with_only_one_item_registered_in_month("June")

    assert_equal 18, target.count
    assert_instance_of Merchant, target[0]
  end

  def test_it_can_return_total_revenue_for_single_merchant
    se = SalesEngine.from_csv({:items => './data/items_short.csv',
                               :merchants => './data/merchants_short.csv',
                               :invoices => './data/invoices_short.csv',
                               :invoice_items => './data/invoice_items_short.csv',
                               :transactions => './data/transactions_short.csv',
                               :customers => './data/customers_short.csv'})
    sa = SalesAnalyst.new(se)

    target = sa.revenue_by_merchant(12334753)

    assert_equal BigDecimal.new("187274".insert(-3, ".")), target
  end

  def test_it_knows_what_item_merchant_sold_the_most_of
    se = SalesEngine.from_csv({:items => './data/items.csv',
                               :merchants => './data/merchants.csv',
                               :invoices => './data/invoices.csv',
                               :invoice_items => './data/invoice_items.csv',
                               :transactions => './data/transactions.csv',
                               :customers => './data/customers.csv'})
    sa = SalesAnalyst.new(se)

    target = sa.most_sold_item_for_merchant(12334753)
    item = se.items.find_by_id(263452797)

    assert_equal [item], target
  end

  def test_it_knows_what_item_had_the_most_revenue_for_each_merchant
    se = SalesEngine.from_csv({:items => './data/items.csv',
                               :merchants => './data/merchants.csv',
                               :invoices => './data/invoices.csv',
                               :invoice_items => './data/invoice_items.csv',
                               :transactions => './data/transactions.csv',
                               :customers => './data/customers.csv'})
    sa = SalesAnalyst.new(se)

    target = sa.best_item_for_merchant(12334753)
    item = se.items.find_by_id(263409515)

    assert_equal item, target
  end

  def test_it_knows_what_customer_returned_the_most_items
    skip
    se = SalesEngine.from_csv({:items => './data/items_short.csv',
                               :merchants => './data/merchants_short.csv',
                               :invoices => './data/invoices_short.csv',
                               :invoice_items => './data/invoice_items_short.csv',
                               :transactions => './data/transactions_short.csv',
                               :customers => './data/customers_short.csv'})
    sa = SalesAnalyst.new(se)

    target = sa.who_returned_most_items
    merchant = se.merchants.find_by_id(263409515)

    assert_equal item, target
  end

end
