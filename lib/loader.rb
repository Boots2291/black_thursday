module Loader

  def load_invoices(invoice_file_path, se)
    contents = CSV.open invoice_file_path,
                 headers: true,
                 header_converters: :symbol
    contents.each do |row|
      id = (row[:id]).to_i
      customer_id = (row[:customer_id]).to_i
      status = (row[:status]).to_sym
      created_at = row[:created_at]
      updated_at = row[:updated_at]
      merchant_id = (row[:merchant_id]).to_i
      invoice = Invoice.new(id, customer_id, status,
                            created_at, updated_at,
                            merchant_id, self)
      @invoices << invoice
    end
  end

  def load_items(items_file_path, se)
    contents = CSV.open items_file_path,
                 headers: true,
                 header_converters: :symbol
    contents.each do |row|
      id = (row[:id]).to_i
      name = row[:name]
      description = row[:description]
      unit_price = row[:unit_price]
      created_at = row[:created_at]
      updated_at = row[:updated_at]
      merchant_id = (row[:merchant_id]).to_i
      item = Item.new(id, name, description, unit_price,
                     created_at, updated_at, merchant_id, self)
      @items << item
    end
  end

  def load_merchants(merchants_file_path, se)
    contents = CSV.open merchants_file_path,
                 headers: true,
                 header_converters: :symbol
    contents.each do |row|
      id = (row[:id]).to_i
      name = row[:name]
      created_at = row[:created_at]
      updated_at = row[:updated_at]
      merchant = Merchant.new(id, name, created_at, updated_at, self)
      @merchants << merchant
    end
  end

  def load_transactions(transactions_file_path, se)
    contents = CSV.open transactions_file_path,
                        headers: true,
                        header_converters: :symbol
    contents.each do |row|
      id = (row[:id]).to_i
      invoice_id = row[:invoice_id].to_i
      credit_card_number = row[:credit_card_number].to_i
      credit_card_expiration_date = row[:credit_card_expiration_date]
      result = row[:result]
      created_at = row[:created_at]
      updated_at = row[:updated_at]
      transaction = Transaction.new(id, invoice_id,
                                    credit_card_number,
                                    credit_card_expiration_date,
                                    result, created_at, updated_at, self)
      @transactions << transaction
    end
  end

  def load_invoice_items(invoice_items_file_path, se)
    contents = CSV.open invoice_items_file_path,
                        headers: true,
                        header_converters: :symbol
    contents.each do |row|
      id = (row[:id]).to_i
      item_id = row[:item_id].to_i
      invoice_id = row[:invoice_id].to_i
      quantity = row[:quantity]
      unit_price = row[:unit_price]
      created_at = row[:created_at]
      updated_at = row[:updated_at]
      invoice_item = InvoiceItem.new(id, item_id, invoice_id,
                                     quantity, unit_price,
                                     created_at, updated_at, self)
      @invoice_items << invoice_item
    end
  end

  def load_customers(customers_path, se)
    contents = CSV.open customers_path,
                        headers: true,
                        header_converters: :symbol
    contents.each do |row|
      id = (row[:id]).to_i
      first_name = row[:first_name]
      last_name = row[:last_name]
      created_at = row[:created_at]
      updated_at = row[:updated_at]
      customer = Customer.new(id, first_name, last_name,
                            created_at, updated_at, self)
      @customers << customer
    end
  end

end
