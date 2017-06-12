require 'pry'
class Pantry
  attr_reader :stock,
              :shopping_list,
              :cook_book

  def initialize
    @stock = {}
    @shopping_list = {}
    @cook_book = {}
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

  def ingr(recipe)
    recipe.ingredients
  end

  def convert(recipe)
    decide_convert(ingr(recipe))
  end

  def decide_convert(ingredients)
    ingredients.keys.inject({ }) do |container, key|
      if ingredients[key] < 1 || ingredients[key] > 100
        container[key] = centi_convert(ingredients[key]) if ingredients[key] > 100
        container[key] = milli_convert(ingredients[key]) if ingredients[key] < 1
      else
        container[key] = { quantity: (ingredients[key].ceil), units: "Universal Units"}
      end
      container
    end
  end

  def centi_convert(amount)
    { quantity: (amount / 100), units: "Centi-Units"}
  end

  def milli_convert(amount)
    { quantity: ((amount * 1000).to_i), units: "Milli-Units"}
  end

  def add_to_shopping_list(recipe)
    @shopping_list = recipe.ingredients
  end

  def print_shopping_list
    @shopping_list.map do |list|
       p "* #{list[0].to_sym}  #{list[1]}"
    end
  end

  def convert_units(recipe)
    converted = convert(recipe)
    unit_convert_add(converted, ingr(recipe))
  end

  def unit_convert_add(converted, recipe)
    converted = converted.keys.inject({}) do |hash, key|
      hash[key] = key_convert(key, converted, recipe)
      hash
    end
    converted
  end

  def key_convert(key, converted, recipe)
    if converted[key].values.include?"Universal Units"
      [converted[key]]
    else
      [converted[key], {quantity: recipe[key], units: "Universal Units"}]
    end
  end

  def add_to_cookbook(recipe)
    @cook_book[recipe.name] = recipe.ingredients
  end
end
