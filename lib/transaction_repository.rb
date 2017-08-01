require_relative 'transaction'
require_relative 'loader'
require 'pry'

class TransactionRepository

  include Loader

  attr_reader :transactions,
              :se

  def initialize(transactions_file_path, se)
    @se = se
    @transactions_file_path = transactions_file_path
    @transactions = []
    load_transactions(transactions_file_path, se)
  end

  def all
    @transactions
  end

  def find_by_id(transaction_id)
    @transactions.find do |transaction_obj|
      transaction_obj.id == transaction_id
    end
  end

  def find_all_by_invoice_id(invoice_id)
    @transactions.find_all do |transaction_obj|
      transaction_obj.invoice_id == invoice_id
    end
  end

  def find_all_by_credit_card_number(credit_card_number)
    @transactions.find_all do |transaction_obj|
      transaction_obj.credit_card_number == credit_card_number
    end
  end

  def find_all_by_result(result)
    @transactions.find_all do |transaction_obj|
      transaction_obj.result == result
    end
  end

  def fetch_invoice_from_transaction_id(invoice_id)
    se.fetch_invoice_from_transaction_id(invoice_id)
  end

  def inspect
    "#<#{self.class} #{@transactions.size} rows>"
  end
end
