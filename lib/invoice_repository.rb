require_relative 'invoice'
<<<<<<< HEAD
=======
require_relative 'loader'
>>>>>>> refactor

class InvoiceRepository

  include Loader

  attr_reader :invoices,
              :se

  def initialize(invoice_file_path, se)
    @se = se
    @invoice_file_path = invoice_file_path
    @invoices = []
    load_invoices(invoice_file_path, se)
  end

  def all
    @invoices
  end

  def find_by_id(id)
    @invoices.find do |invoice|
      invoice.id == id
    end
  end

  def find_all_by_customer_id(customer_id)
    @invoices.find_all do |invoice|
      invoice.customer_id == customer_id
    end
  end

  def find_all_by_merchant_id(merchant_id)
    @invoices.find_all do |invoice|
      invoice.merchant_id == merchant_id
    end
  end

  def find_all_by_status(status)
    @invoices.find_all do |invoice|
      invoice.status == status
    end
  end

  def fetch_merchant_from_invoice_id(merchant_id)
    se.fetch_merchant_from_invoice_id(merchant_id)
  end

  def fetch_items_from_invoice_id(invoice_id)
    se.fetch_items_from_invoice_id(invoice_id)
  end

  def fetch_transactions_from_invoice_id(invoice_id)
    se.fetch_transactions_from_invoice_id(invoice_id)
  end

  def fetch_customer_from_invoice_id(customer_id)
    se.fetch_customer_from_invoice_id(customer_id)
  end

  def fetch_invoice_items_from_invoice_id(invoice_id)
    se.fetch_invoice_items_from_invoice_id(invoice_id)
  end

  def inspect
    "#<#{self.class} #{@invoices.size} rows>"
  end

end
