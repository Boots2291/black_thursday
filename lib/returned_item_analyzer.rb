module ReturnedItemAnalyzer

  def returned_most_items
    #get invoice with returned status
  end

  def merchants_with_returned_invoices
    invoices = @se.call_invoices.find_all do |invoice|
      invoice.status == :returned
    end
    invoices.map do |invoice|
      invoice.merchant
    end.uniq
  end

end

generate an html report