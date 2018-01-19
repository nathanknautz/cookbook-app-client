require 'unirest'

system "clear"

puts "Welcome to my Cookbook App"
puts "Make a selection"
puts "    [1] See all recipes"
puts "    [2] See one recipe"
puts "    [3] Create a new recipe"

input_option = gets.chomp

if input_option == "1"
  response = Unirest.get("http://localhost:3000/recipes")
  recipes = response.body 
  puts JSON.pretty_generate(recipes)
elsif input_option == "2"
  print "Enter recipe id: "
  input_id = gets.chomp
  response = Unirest.get("http://localhost:3000/recipes/#{input_id}")
  recipe = response.body
  puts JSON.pretty_generate(recipe)
elsif input_option == "3"
  client_params = {}
  print "Tile: "
  client_params[:title] = gets.chomp
  print "Chef: "
  client_params[:chef] = gets.chomp
  print "Ingredients: "
  client_params[:ingredients] = gets.chomp
  print "Directions: "
  client_params[:directions] = gets.chomp

  response = Unirest.post("http://localhost:3000/recipes",
                          parameters: client_params
                          )
 end

 