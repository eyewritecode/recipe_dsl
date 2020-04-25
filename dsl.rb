# frozen_string_literal: true

class Recipe
  attr_accessor :name, :ingredients

  def initialize(name, ingredients=[], &block)
    @name = name
    @ingredients = ingredients
    instance_eval(&block) if block_given?
  end

  def ingredient(ingredient_name)
    @ingredients |= [ingredient_name]
  end

  def self.describe(&block)
    yield
  end

  def self.for(recipe_name)
    ObjectSpace.each_object(self) do |recipe|
      return recipe if recipe.name == recipe_name
    end
  end
end

def recipe(name, &block)
  Recipe.new(name, &block)
end

Recipe.describe do
  recipe 'Hot Cake' do
    ingredient 'Egg'
    ingredient 'Flour'
    ingredient 'Water'
    ingredient 'Sugar'
  end

  recipe 'Miso Soup' do
    ingredient 'Tofu'
    ingredient 'Green Chard'
    ingredient 'Green Onion'
    ingredient 'White miso paste'
  end
end

hotcake = Recipe.for('Hot Cake')
puts hotcake.name
# => Hot Cake
puts hotcake.ingredients.inspect
# => ["Egg", "Flour", "Water", "Sugar"]

soup = Recipe.for('Miso Soup')
puts soup.name
# # # => Miso Soup
puts soup.ingredients.inspect
# # => ["Tofu", "Green Chard", "Green Onion", "White miso paste"]
