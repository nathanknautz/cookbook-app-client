require 'unirest'

system "clear"

puts "Welcome to my Cookbook App"
puts "Make a selection"
puts "    [1] See all recipes"
puts "    [2] See one recipe"
puts "    [3] Create a new recipe"
puts "    [4] Update a recipe"
puts "    [5] Destroy a recipe"

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
elsif input_option == "4"
  print "Enter recipe id: "
  input_id = gets.chomp
  response = Unirest.get("http://localhost:3000/recipes/#{input_id}")
  recipe = response.body

  client_params = {}
  print "Tile (#{recipe["title"]}): "
  client_params[:title] = gets.chomp
  print "Chef (#{recipe["chef"]}): "
  client_params[:chef] = gets.chomp
  print "Ingredients (#{recipe["ingredients"]}): "
  client_params[:ingredients] = gets.chomp
  print "Directions (#{recipe["directions"]}): "
  client_params[:directions] = gets.chomp
  client_params.delete_if {|key, value| value.empty?}
  response = Unirest.patch("http://localhost:3000/recipes/#{input_id}",
                          parameters: client_params
                          )
elsif input_option == "5"
  print "Enter recipe id: "
  input_id = gets.chomp
  response = Unirest.delete("http://localhost:3000/recipes/#{input_id}")
  data = response.body
  puts data["message"]
 end

