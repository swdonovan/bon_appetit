require './lib/pantry'
require 'minitest/autorun'
require 'minitest/pride'
require_relative '../lib/pantry'
require_relative '../lib/recipe'
require "minitest/unit"
require "mocha/mini_test"


class PantryTest < Minitest::Test

  def test_it_exsists
    pantry = Pantry.new

    assert_instance_of Pantry, pantry
  end

  def test_it_can_check_stock
    pantry = Pantry.new
    expected = { }
    assert_equal expected, pantry.stock
  end

  def test_it_can_stock_check
    pantry = Pantry.new
    expected = {}
    assert_equal expected, pantry.stock_check("cheese")
  end

  def test_it_can_stock_check_with_amount
    pantry = Pantry.new
    pantry.restock("cheese", 10)
    assert_equal 10, pantry.stock_check("cheese")
  end

  def test_it_can_restock
    pantry = Pantry.new
    actual = pantry.restock("cheese", 10)

    assert_equal 10, actual
  end

  def test_it_can_restock_and_ceck
    pantry = Pantry.new
    pantry.restock("cheese", 10)
    pantry.restock("cheese", 50)
    actual = pantry.stock_check("cheese")


    assert_equal 60, actual
  end

  def test_it_can_restock_and_check_multiple_items
    pantry = Pantry.new
    pantry.restock("cheese", 10)
    pantry.restock("pizza", 40)
    actual = pantry.stock_check("pizza")


    assert_equal 40, actual
  end

  def test_it_can_convert_recipe_ingredients
    r = Recipe.new("Cheese Pizza")
    r.add_ingredient("Flour", 500)
    pantry = Pantry.new
    actual = pantry.convert(r)


    assert_equal Hash, actual.class
    assert_equal 5 ,actual["Flour"][:quantity]
  end

  def test_it_can_convert_recipe_ingredients_under_1
    r = Recipe.new("Cheese Pizza")
    r.add_ingredient("Flour", 0.025)
    pantry = Pantry.new
    actual = pantry.convert(r)


    assert_equal Hash, actual.class
    assert_equal 25 ,actual["Flour"][:quantity]
  end

  def test_it_can_convert_recipe_mulitple_ingredients
    r = Recipe.new("Cheese Pizza")
    r.add_ingredient("Flour", 0.025)
    r.add_ingredient("Cheese", 1555)
    pantry = Pantry.new
    actual = pantry.convert(r)


    assert_equal Hash, actual.class
    assert_equal 15, actual["Cheese"][:quantity]
    assert_equal 2, actual.length
  end

  def test_it_has_shopping_list
    pantry = Pantry.new
    expected = {}

    assert_instance_of Hash, pantry.shopping_list
    assert_equal expected, pantry.shopping_list
  end

  def test_it_can_add_to_shopping_cart_and_return_items
    r = Recipe.new("Cheese Pizza")
    r.add_ingredient("Flour", 0.025)
    r.add_ingredient("Cheese", 1555)
    pantry = Pantry.new
    pantry.add_to_shopping_list(r)

    assert_equal 2, pantry.shopping_list.length
    assert_equal Hash, pantry.shopping_list.class
  end

  def test_it_takes_3_things
    r = Recipe.new("Spaghetti")
    r.add_ingredient("Noodles", 10)
    r.add_ingredient("Sauce", 10)
    r.add_ingredient("Cheese", 5)
    pantry = Pantry.new
    pantry.add_to_shopping_list(r)

    assert_equal 3, pantry.shopping_list.length
  end

  def test_pantry_can_print_list
    r = Recipe.new("Spaghetti")
    r.add_ingredient("Noodles", 10)
    r.add_ingredient("Sauce", 10)
    r.add_ingredient("Cheese", 5)
    pantry = Pantry.new
    pantry.add_to_shopping_list(r)
    pantry.print_shopping_list

    assert_equal 3, pantry.shopping_list.length
  end

  def test_if_centi_convert_returns_correctly
    pantry = Pantry.new
    actual = pantry.centi_convert(1000)
    expected = { quantity: 10, units: "Centi-Units"}

    assert_equal expected, actual
    assert_equal Hash, actual.class
  end

  def test_if_milli_convert_returns_correctly
    pantry = Pantry.new
    actual = pantry.milli_convert(0.0155)
    expected = { quantity: 15, units: "Milli-Units"}

    assert_equal expected, actual
    assert_equal Hash, actual.class
  end

  def test_it_converts_multiple_units
    r = Recipe.new("Spicy Cheese Pizza")
    r.add_ingredient("Cayenne Pepper", 0.025)
    r.add_ingredient("Cheese", 75)
    r.add_ingredient("Flour", 550)

    pantry = Pantry.new
    actual = pantry.convert_units(r)

    expected = {"Cayenne Pepper" => [{quantity: 25, units: "Milli-Units"},
      {quantity: 0.025, units: "Universal Units"}],
      "Cheese"         => [{quantity: 75, units: "Universal Units"}],
      "Flour"          => [{quantity: 5, units: "Centi-Units"},
      {quantity: 550, units: "Universal Units"}]}

      assert_equal expected, actual
      assert_equal 3, actual.length
      assert_equal Hash, actual.class
  end

  def test_it_converts_multiple_different_units
  	r = Recipe.new("Spicy Cheese Pizza")
  	r.add_ingredient("Cayenne Pepper", 0.0590)
  	r.add_ingredient("Cheese", 1000)
  	r.add_ingredient("Flour", 55000)

  	pantry = Pantry.new
  	actual = pantry.convert_units(r)

  	expected = {"Cayenne Pepper" => [{quantity: 59, units: "Milli-Units"},
                         {quantity: 0.059, units: "Universal Units"}],
    "Cheese"         => [{quantity: 10, units: "Centi-Units"},
  											 {quantity: 1000, units: "Universal Units"}],
    "Flour"          => [{quantity: 550, units: "Centi-Units"},
                         {quantity: 55000, units: "Universal Units"}]}

  	assert_equal expected, actual
    assert_equal Hash, actual.class
  end

  def test_it_adds_to_cookbook
    pantry = Pantry.new
    r1 = Recipe.new("Cheese Pizza")
    r1.add_ingredient("Cheese", 20)
    r1.add_ingredient("Flour", 20)

    r2 = Recipe.new("Pickles")
    r2.add_ingredient("Brine", 10)
    r2.add_ingredient("Cucumbers", 30)

    r3 = Recipe.new("Peanuts")
    r3.add_ingredient("Raw nuts", 10)
    r3.add_ingredient("Salt", 10)

    pantry.add_to_cookbook(r1)
    pantry.add_to_cookbook(r2)
    pantry.add_to_cookbook(r3)

    assert_equal Hash, pantry.cook_book.class
    assert_equal 3, pantry.cook_book.length
  end

  def test_it_shows_what_it_can_make
    pantry = Pantry.new
    r1 = Recipe.new("Cheese Pizza")
    r1.add_ingredient("Cheese", 20)
    r1.add_ingredient("Flour", 20)

    r2 = Recipe.new("Pickles")
    r2.add_ingredient("Brine", 10)
    r2.add_ingredient("Cucumbers", 30)

    r3 = Recipe.new("Peanuts")
    r3.add_ingredient("Raw nuts", 10)
    r3.add_ingredient("Salt", 10)

    pantry.restock("Cheese", 10)
    pantry.restock("Flour", 20)
    pantry.restock("Brine", 40)
    pantry.restock("Cucumbers", 40)
    pantry.restock("Raw nuts", 20)
    pantry.restock("Salt", 20)

    pantry.add_to_cookbook(r1)
    pantry.add_to_cookbook(r2)
    pantry.add_to_cookbook(r3)
    expected = ["Pickles", "Peanuts"]

    assert_equal Array, pantry.what_can_i_make.class
    assert_equal 2, pantry.what_can_i_make.length
    assert_equal expected, pantry.what_can_i_make
  end

  def test_it_shows_what_it_can_make_and_how_many
    pantry = Pantry.new
    r1 = Recipe.new("Cheese Pizza")
    r1.add_ingredient("Cheese", 20)
    r1.add_ingredient("Flour", 20)

    r2 = Recipe.new("Pickles")
    r2.add_ingredient("Brine", 10)
    r2.add_ingredient("Cucumbers", 30)

    r3 = Recipe.new("Peanuts")
    r3.add_ingredient("Raw nuts", 10)
    r3.add_ingredient("Salt", 10)

    pantry.restock("Cheese", 10)
    pantry.restock("Flour", 20)
    pantry.restock("Brine", 40)
    pantry.restock("Cucumbers", 40)
    pantry.restock("Raw nuts", 20)
    pantry.restock("Salt", 20)

    pantry.add_to_cookbook(r1)
    pantry.add_to_cookbook(r2)
    pantry.add_to_cookbook(r3)
    expected_amount = {"Pickles" => 1, "Peanuts" => 2}

    assert_equal Hash, pantry.how_many_can_i_make.class
    assert_equal 2, pantry.how_many_can_i_make.length
    assert_equal expected_amount, pantry.how_many_can_i_make
  end

  def test_bake_amount_returns_correctly
    pantry = Pantry.new
    r1 = Recipe.new("Cheese Pizza")
    r1.add_ingredient("Cheese", 20)
    r1.add_ingredient("Flour", 20)

    pantry.add_to_cookbook(r1)
    pantry.restock("Cheese", 40)
    pantry.restock("Flour", 40)
    actual = pantry.bake_amount(r1.name)
    expected = [2, 2]

    assert_equal expected, actual
  end

  def test_bake_amount_returns_different_numbs_correctly
    pantry = Pantry.new
    r1 = Recipe.new("Cheese Pizza")
    # r.expects(:ingredients).returns({})
    r1.add_ingredient("Cheese", 20)
    r1.add_ingredient("Flour", 20)

    pantry.add_to_cookbook(r1)
    pantry.restock("Cheese", 60)
    pantry.restock("Flour", 20)
    actual = pantry.bake_amount(r1.name)
    expected = [3, 1]

    assert_equal expected, actual
  end

  def test_it_shows_what_it_can_make_and_how_many_with_pizza__Smiley_face
    pantry = Pantry.new
    r1 = Recipe.new("Cheese Pizza")
    r1.add_ingredient("Cheese", 20)
    r1.add_ingredient("Flour", 20)

    r2 = Recipe.new("Pickles")
    r2.add_ingredient("Brine", 10)
    r2.add_ingredient("Cucumbers", 30)

    r3 = Recipe.new("Peanuts")
    r3.add_ingredient("Raw nuts", 10)
    r3.add_ingredient("Salt", 10)

    pantry.restock("Cheese", 30)
    pantry.restock("Flour", 20)
    pantry.restock("Brine", 50)
    pantry.restock("Cucumbers", 150)
    pantry.restock("Raw nuts", 50)
    pantry.restock("Salt", 30)

    pantry.add_to_cookbook(r1)
    pantry.add_to_cookbook(r2)
    pantry.add_to_cookbook(r3)
    expected_amount = {"Cheese Pizza" => 1, "Pickles" => 5, "Peanuts" => 3}

    assert_equal Hash, pantry.how_many_can_i_make.class
    assert_equal 3, pantry.how_many_can_i_make.length
    assert_equal expected_amount, pantry.how_many_can_i_make
  end

  def test_it_shows_what_it_can_make_and_how_many_with_only_pickles
    pantry = Pantry.new
    r1 = Recipe.new("Cheese Pizza")
    r1.add_ingredient("Cheese", 20)
    r1.add_ingredient("Flour", 20)

    r2 = Recipe.new("Pickles")
    r2.add_ingredient("Brine", 10)
    r2.add_ingredient("Cucumbers", 30)

    r3 = Recipe.new("Peanuts")
    r3.add_ingredient("Raw nuts", 10)
    r3.add_ingredient("Salt", 10)

    pantry.restock("Cheese", 13)
    pantry.restock("Flour", 10)
    pantry.restock("Brine", 55)
    pantry.restock("Cucumbers", 152)
    pantry.restock("Raw nuts", 5)
    pantry.restock("Salt", 5)

    pantry.add_to_cookbook(r1)
    pantry.add_to_cookbook(r2)
    pantry.add_to_cookbook(r3)
    expected_amount = {"Pickles" => 5}

    assert_equal Hash, pantry.how_many_can_i_make.class
    assert_equal 1, pantry.how_many_can_i_make.length
    assert_equal expected_amount, pantry.how_many_can_i_make
  end
end
