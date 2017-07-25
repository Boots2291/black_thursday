require './test/test_helper'
require './lib/item'

class ItemTest < Minitest::Test

  def test_it_exists
    item = Item.new(1, "Bill", "An item", 1200, "Yesterday", "Today")

    assert_instance_of Item, item
  end

  def test_it_has_an_id
    item = Item.new(1, "Bill", "An item", 1200, "Yesterday", "Today")

    assert_equal 1, item.id
  end

  def test_it_has_a_name
    item = Item.new(1, "Bill", "An item", 1200, "Yesterday", "Today")

    assert_equal "Bill", item.name
  end

  def test_it_has_a_description
    item = Item.new(1, "Bill", "An item", 1200, "Yesterday", "Today")

    assert_equal "An item", item.description
  end

  def test_it_has_a_unit_price
    item = Item.new(1, "Bill", "An item", 1200, "Yesterday", "Today")

    assert_equal 1200, item.unit_price
  end

  def test_it_knows_when_created
    item = Item.new(1, "Bill", "An item", 1200, "Yesterday", "Today")

    assert_equal "Yesterday", item.created_at
  end

  def test_it_knows_when_updated
    item = Item.new(1, "Bill", "An item", 1200, "Yesterday", "Today")

    assert_equal "Today", item.updated_at
  end

end