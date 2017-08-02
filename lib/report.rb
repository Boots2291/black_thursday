require 'tilt'
require './lib/sales_analyst'
require './lib/sales_engine'

se = SalesEngine.from_csv({:items => './data/items.csv',
                           :merchants => './data/merchants.csv',
                           :invoices => './data/invoices.csv',
                           :invoice_items => './data/invoice_items.csv',
                           :transactions => './data/transactions.csv',
                           :customers => './data/customers.csv'})

sa = SalesAnalyst.new(se)
name = se.fetch_merchant_name(12334141)


template = Tilt::ERBTemplate.new("lib/report.html.erb")

File.open "new_file.html", "w" do |file|
    file.write template.render(name)
end
