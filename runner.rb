require 'unirest'
def run
  
  while true
    

    puts "Welcome to my Cookbook App"
    puts "Make a selection"
    puts "    [1] See all recipes"
    puts "        [1.1] Search all recipes"
    puts "        [1.2] Sort recipes by chef"
    puts "        [1.3] Sort recipes by prep time"
    puts "    [2] See one recipe"
    puts "    [3] Create a new recipe"
    puts "    [4] Update a recipe"
    puts "    [5] Destroy a recipe"
    puts "    [6] Add a user"
    puts "    [login] Login (create a JSON web token)"
    puts "    [logout] Logout (erase the JSON web token)"
    puts "    Enter q to quit"

    input_option = gets.chomp
    system "clear"
    if input_option == "1"
      response = Unirest.get("http://localhost:3000/recipes")
      recipes = response.body 
      puts JSON.pretty_generate(recipes)
    elsif input_option =="1.1"
      print "Enter a search term: "
      search_term = gets.chomp
      response = Unirest.get("http://localhost:3000/recipes?search=#{search_term}")
      recipes = response.body 
      puts JSON.pretty_generate(recipes)
    elsif input_option == '1.2'
      response = Unirest.get("http://localhost:3000/recipes?sort=chef")
      recipes = response.body 
      puts JSON.pretty_generate(recipes)
    elsif input_option == '1.3'
      response = Unirest.get("http://localhost:3000/recipes?sort=prep_time")
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
      print "Prep time (#{recipe["prep_time"]}): "
      client_params[:prep_time] = gets.chomp
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
    elsif input_option == '6'
      client_params = {}
      print "Name: "
      client_params[:name] = gets.chomp
      print "Email: "
      client_params[:email] = gets.chomp
      print "password: "
      client_params[:password] = gets.chomp
      print "password_confirmation: "
      client_params[:password_confirmation] = gets.chomp
      response = Unirest.post("http://localhost:3000/users",
                              parameters: client_params
                              )
      message = response.body
      puts JSON.pretty_generate(message)
    elsif input_option == 'login'
      puts "Login"
      puts
      puts "Email: "
      input_email = gets.chomp
      print "Password: "
      input_password = gets.chomp

      response = Unirest.post("http://localhost:3000/user_token",
                              parameters: {
                                            auth: {
                                                email: input_email,
                                                password: input_password
                                            }
                                          }
                              )
      puts JSON.pretty_generate(response.body)
      jwt = response.body["jwt"]
      Unirest.default_header("Authorization", "Bearer #{jwt}")
    elsif input_option == 'logout'
      jwt = ""
      Unirest.clear_default_headers
    elsif input_option == 'q'
      puts "Thank you for using my cookbook."
      exit
     end
    end
    gets.chomp
  end
run
