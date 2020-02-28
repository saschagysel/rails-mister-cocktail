require 'open-uri'
require 'json'
url = "https://www.thecocktaildb.com/api/json/v1/1/list.php?i=list"
response = open(url).read
repo = JSON.parse(response)
ingredients = repo["drinks"]
ingredients.each do |ingredient|
  new_ingredient = Ingredient.new(name: ingredient["strIngredient1"])
  new_ingredient.save!
end
url = "https://www.thecocktaildb.com/api/json/v1/1/search.php?f=m"
response = open(url).read
cocktail_repo = JSON.parse(response)
cocktails = cocktail_repo["drinks"]
# p cocktails.first['strGlass']
cocktails.each do |cocktail|
  new_cocktail = Cocktail.create(name: cocktail['strDrink'])
  i = 1
  loop do
    ingredient_name = cocktail["strIngredient#{i}"]
    ingredient_description = cocktail["strMeasure#{i}"]
    break if ingredient_name == nil
    ingredient = Ingredient.find_by(name: ingredient_name)
    if ingredient
      Dose.create(cocktail: new_cocktail, ingredient: ingredient, description: ingredient_description)
    else
      new_ingredient = Ingredient.create(name: ingredient_name)
      Dose.create(cocktail: new_cocktail, ingredient: new_ingredient, description: ingredient_description)
    end
    i += 1
  end
end
