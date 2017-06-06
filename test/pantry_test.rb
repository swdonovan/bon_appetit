require './lib/pantry'
require 'minitest/autorun'
require 'minitest/pride'
require_relative '../lib/pantry'
require_relative '../lib/recipe'


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
			a = pantry.restock("cheese", 10)
			b = pantry.restock("cheese", 50)
			actual = pantry.stock_check("cheese")


			assert_equal 60, actual
	end

	def test_it_can_restock_and_check_multiple_items
			pantry = Pantry.new
			a = pantry.restock("cheese", 10)
			b = pantry.restock("pizza", 40)
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

		assert_equal 3, pantry.print_shopping_list.length
	end

	# def test_it_converts_multiple_units
	# 	r = Recipe.new("Spicy Cheese Pizza")
	# 	r.add_ingredient("Cayenne Pepper", 1.025)
	# 	r.add_ingredient("Cheese", 75)
	# 	r.add_ingredient("Flour", 550)
	#
	# 	pantry = Pantry.new
	# 	actual = pantry.convert_units(r)
	#
	# 	expected = [{"Cayenne Pepper" => [{quantity: 25, units: "Milli-Units"},
  #                        {quantity: 1, units: "Universal Units"}],
  #   "Cheese"         => [{quantity: 75, units: "Universal Units"}],
  #   "Flour"          => [{quantity: 5, units: "Centi-Units"},
  #                        {quantity: 50, units: "Universal Units"}]}]
	#
	# 	assert_equal expected, actual
	# 	asswert_equal 6, actual.length
	# end

	# def test_it_converts_multiple_different_units
	# 	r = Recipe.new("Spicy Cheese Pizza")
	# 	r.add_ingredient("Cayenne Pepper", 0.0590)
	# 	r.add_ingredient("Cheese", 1000)
	# 	r.add_ingredient("Flour", 55000)
	#
	# 	pantry = Pantry.new
	# 	actual = pantry.convert_units(r)
	#
	# 	expected = {"Cayenne Pepper" => [{quantity: 590, units: "Milli-Units"},
  #                        {quantity: .059, units: "Universal Units"}],
  #   "Cheese"         => [{quantity: 10, units: "Universal Units"},
	# 											 {quantity: 1000, units: "Universal Units"}],
  #   "Flour"          => [{quantity: 550, units: "Centi-Units"},
  #                        {quantity: 55000, units: "Universal Units"}]}
	#
	# 	assert_equal expected, actual
	# end
end
