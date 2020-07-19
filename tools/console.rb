require_relative '../config/environment.rb'

def reload
  load 'config/environment.rb'
end

hotel1 = Listing.new("Hotel 1", "Chicago")
hotel2 = Listing.new("Hotel 2", "Chicago")
hotel3 = Listing.new("Hotel 3", "Detroit")
hotel4 = Listing.new("Hotel 4", "LA")
hotel5 = Listing.new("Hotel 5", "LA")

angela = Guest.new("Angela") 
rob = Guest.new("Rob") 
stew = Guest.new("Stew") 
jess = Guest.new("Jess")

trip1 = Trip.new(rob, hotel4)
trip2 = Trip.new(rob, hotel2)
trip3 = Trip.new(stew, hotel3)
trip4 = Trip.new(jess, hotel3)
trip4 = Trip.new(jess, hotel3)
trip4 = Trip.new(angela, hotel1)

#==========================================================================
#==========================================================================
#==========================================================================
#==========================================================================
#==========================================================================
#==========================================================================

gym1 = Location.new("GloboGym")
gym2 = Location.new("Average Joes")
gym3 = Location.new("Planet Fitness")
gym4 = Location.new("LA Fitness")
gym5 = Location.new("Lifetime Fitness")

white = Trainer.new("White Goodman")
peter = Trainer.new("Peter La Fluer")
patches = Trainer.new("Patches")
joe = Trainer.new("Joe")
mike = Trainer.new("mike")

loco1 = LocationTrainer.new(gym1, white)
loco2 = LocationTrainer.new(gym1, mike)
loco3 = LocationTrainer.new(gym2, peter)
loco4 = LocationTrainer.new(gym2, white)
loco5 = LocationTrainer.new(gym3, peter)
loco6 = LocationTrainer.new(gym4, mike)
loco7 = LocationTrainer.new(gym5, mike)
loco8 = LocationTrainer.new(gym5, white)
loco9 = LocationTrainer.new(gym3, mike)

andrew = Client.new("Andrew", white)
alexandra = Client.new("Alexandra", white)
amelia = Client.new("Amelia", mike)
alex = Client.new("Alex", peter)
aaron = Client.new("Aaron", peter)

#==========================================================================
#==========================================================================
#==========================================================================
#==========================================================================
#==========================================================================
#==========================================================================
jim = User.new("Jim")
john = User.new("John")
mike = User.new("Mike")

animals = Project.new(jim, "save the animals")
album = Project.new(mike, "fund my album")
treatment = Project.new(john, "fund my treatment")
album2 = Project.new(mike, "fund my next album")


pledge1 = Pledge.new(john, album, 300)
pledge2 = Pledge.new(mike, animals, 200)
pledge3 = Pledge.new(john, animals, 250)
pledge4 = Pledge.new(jim, treatment, 500)

Pry.start
