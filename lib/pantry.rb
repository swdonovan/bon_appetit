require 'pry'
class Pantry
	attr_reader :stock,
							:shopping_list

	def initialize
		@stock = {}
		@shopping_list = {}
	end

	def restock(item, amount)
		@stock[item] += amount unless @stock[item] ==  nil
		@stock[item] = amount if @stock == {}
		@stock[item] = amount if @stock[item] == nil
		stock[item]
	end

	def stock_check(item)
		@stock[item] != nil ? amount = @stock[item]: amount = @stock
		amount
	end

	def convert(recipe)
		ingr = recipe.ingredients
		ingr.keys.map.inject({ }) do |container, key|
			if ingr[key] < 1 || ingr[key] > 100
				container[key] = centi_convert(ingr[key]) if ingr[key] > 100
				container[key] = milli_convert(ingr[key]) if ingr[key] < 1
			else
				container[key] = { quantity: (ingr[key].ceil), units: "Universal Units"}
			end
			container
		end
	end

	def centi_convert(amount)
		output = { quantity: (amount / 100), units: "Centi-Units"}
	end

	def milli_convert(amount)
		output = { quantity: ((amount * 1000).to_i), units: "Centi-Units"}
	end

	def add_to_shopping_list(recipe)
		@shopping_list = recipe.ingredients
	end

	def print_shopping_list
		@shopping_list.each do |list|
			puts "* #{list[0].to_sym}  #{list[1]}"
		end
		@shopping_list
	end

	def convert_units(recipe)
		ingred = recipe.ingredients
		converted = convert(recipe)
		final = unit_convert_add(converted, ingred)
	end

	def unit_convert_add(converted, recipe)
		converted = converted.keys.map do |key|
			key = { key => [converted[key], {quantity: recipe[key].to_i, units: "Universal Units"}]}
		end
		converted
	end

end
