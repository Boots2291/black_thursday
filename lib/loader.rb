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
end