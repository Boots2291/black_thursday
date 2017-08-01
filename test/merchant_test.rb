require './test/test_helper'
require './lib/merchant'

class MerchantTest < Minitest::Test

  def test_it_exists
    merchant = Merchant.new(1, "Bill", "2010-12-10", "2011-12-04", self)

    assert_instance_of Merchant, merchant
  end

  def test_it_has_an_id
    merchant = Merchant.new(1, "Bill", "2010-12-10", "2011-12-04", self)

    assert_equal 1, merchant.id
  end

  def test_it_has_a_name
    merchant = Merchant.new(1, "Bill", "2010-12-10", "2011-12-04", self)

    assert_equal "Bill", merchant.name
  end

  def test_it_knows_when_created
    merchant = Merchant.new(1, "Bill", "2010-12-10", "2011-12-04", self)

    assert_equal Time.parse("2010-12-10"), merchant.created_at
  end

  def test_it_knows_when_updated
    merchant = Merchant.new(1, "Bill", "2010-12-10", "2011-12-04", self)

    assert_equal Time.parse("2011-12-04"), merchant.updated_at
  end

end