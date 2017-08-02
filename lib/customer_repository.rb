require_relative 'customer'
require_relative 'loader'

class CustomerRepository

  include Loader

  attr_reader :customers,
              :se

  def initialize(customers_path, se)
    @se = se
    @customers_path = customers_path
    @customers = []
    load_customers(customers_path, se)
  end

  def all
    @customers
  end

  def find_by_id(customer_id)
    @customers.find do |customer_obj|
      customer_obj.id == customer_id
    end
  end

  def find_all_by_first_name(fragment)
    @customers.find_all do |customer|
      customer.first_name.downcase.include?(fragment.downcase)
    end
  end

  def find_all_by_last_name(fragment)
    @customers.find_all do |customer|
      customer.last_name.downcase.include?(fragment.downcase)
    end
  end

  def fetch_merchants_from_customer_id(customer_id)
    se.fetch_merchants_from_customer_id(customer_id)
  end

  def inspect
    "#<#{self.class} #{@customers.size} rows>"
  end
end
