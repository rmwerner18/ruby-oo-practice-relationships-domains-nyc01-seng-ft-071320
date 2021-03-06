# create files for your ruby classes in this directory
class Listing
    @@all = []
    attr_accessor :title, :city
    def initialize(title, city)
        @title = title
        @city = city
        Listing.all << self
    end

    def self.all
        @@all
    end

    def trips
        Trip.all.select {|trip| trip.listing == self}
    end

    def guests
        self.trips.map {|trip| trip.guest}
    end

    def trip_count
        self.trips.count
    end

    def self.find_all_by_city(city)
        Listing.all.select {|listing| listing.city == city}
    end

    def self.most_popular
        trip_counts = Listing.all.map {|location| location.trip_count}
        max = trip_counts.max {|count1, count2| count1 <=> count2}
        Listing.all.find {|listing| listing.trip_count == max}
    end
end

class Guest
    @@all = []
    attr_accessor :name
    def initialize(name)
        @name = name
        Guest.all << self
    end

    def self.all
        @@all
    end
 
    def trips
        Trip.all.select {|trip| trip.guest == self}
    end

    def listings
        self.trips.map {|trip| trip.listing}
    end

    def trip_count
        self.trips.count
    end

    def self.pro_traveller
        Guest.all.select {|guest| guest.trip_count > 1}
    end

    def self.find_all_by_name(name)
        Guest.all.select {|guest| guest.name == name}
    end
end

class Trip
    @@all = []
    attr_accessor :guest, :listing
    def initialize(guest, listing)
        @guest = guest
        @listing = listing
        Trip.all << self
    end

    def self.all
        @@all
    end
end


#==========================================================================
#==========================================================================
#==========================================================================
#==========================================================================
#==========================================================================
#==========================================================================

class Location
    attr_accessor :name
    attr_reader :clients
    @@all = []
    def initialize(name)
        @name = name
        Location.all << self
    end

    def self.all
        @@all
    end

    def trainers
        lo_trs = LocationTrainer.all.select {|lo_tr| lo_tr.location == self}
        lo_trs.map {|lo_tr| lo_tr.trainer}
    end

    def trainers_clients
        clients = []
        separated_clients = trainers.map {|trainer| trainer.clients}
        separated_clients.each {|array| clients.concat(array)}
        clients
    end

    def clients
        trainers_clients.select do |client|
            client.locations.find {|location|
                location == self
            }
        end
    end

    def client_count 
        clients.count
    end

    def self.least_clients
        counts = Location.all.map {|location| location.client_count}
        min = counts.min {|count1, count2| count1 <=> count2}
        Location.all.select {|location| location.client_count == min}
    end
end


class LocationTrainer
    attr_accessor :location, :trainer
    @@all = []
    def initialize(location, trainer)
        @location = location
        @trainer = trainer
        LocationTrainer.all << self
    end

    def self.all
        @@all
    end
end

class Trainer
    attr_accessor :name
    @@all = []
    def initialize(name) 
        @name = name
        Trainer.all << self
    end

    def self.all
        @@all
    end

    def clients 
        Client.all.select {|client| client.trainer == self}
    end

    def locations
        lo_trs = LocationTrainer.all.select {|lo_tr| lo_tr.trainer == self}
        lo_trs.map {|lo_tr| lo_tr.location}
    end

    def client_count
        clients.count
    end

    def self.most_clients
        counts = Trainer.all.map {|trainer| trainer.client_count}
        max = counts.max {|count1, count2| count1 <=> count2}
        Trainer.select {|trainer| trainer.client_count == max}
    end
end


class Client
    attr_accessor :name, :trainer
    attr_reader :locations
    @@all = []
    def initialize(name, trainer)
        @name = name
        @trainer = trainer
        @locations = []
        Client.all << self
    end

    def self.all
        @@all
    end

    def assign_trainer(trainer)
        #updates locations array to be just the locations client currently
        #belongs to, minus the ones that new trainer does not work at. Client will
        #lose access to locations that new trainer does not work at. If new trainer
        #starts working at location that client had been to before, client will
        #have to re-register (#add_location) at that location.
        @trainer = trainer
        update_locations_to_trainer
    end

    def add_location(location)
        possible_locations = LocationTrainer.all.select {
            |lo_tr| lo_tr.trainer == self.trainer
        }
        add_location = possible_locations.find {
            |element| element.location == location
        } 
        if add_location
            self.locations << location
        else
            "Your trainer is not available at that location"
        end
    end

    def update_locations_to_trainer
        updated_locations = locations.select {
            |location| location.trainers.find {
                |trainer| trainer == self.trainer
                }
            }
        @locations = updated_locations
    end
end

#==========================================================================
#==========================================================================
#==========================================================================
#==========================================================================
#==========================================================================
#==========================================================================

class User 
    @@all = []
    def initialize(name)
        @name = name
        User.all << self
    end

    def self.all 
        @@all
    end

    def pledges
        Pledge.all.select {|pledge| pledge.user == self}
    end

    def projects_backing
        pledges.map {|pledge| pledge.project}
    end

    def projects_hosting
        Project.all.select {|project| project.user == self}
    end

    def self.highest_pledge
        pledges = Pledge.all.map {|pledge| pledge.amount}
        max = pledges.max {|pledge1, pledge2| pledge1 <=> pledge2}
        max_pledge = Pledge.all.find {|pledge| pledge.amount == max}
        max_pledge.user
    end

    def self.multi_pledger
        User.all.select {|user| user.pledges.length > 1}
    end

    def self.project_creator
        User.all.select {|user| user.projects_hosting != nil}
    end
end

class Pledge
    @@all = []
    attr_reader :user, :project, :amount
    def initialize(user, project, amount)
        @user = user
        @project = project
        @amount = amount
        Pledge.all << self
    end

    def self.all
        @@all
    end

end

class Project
    @@all = []
    attr_accessor :user, :name, :goal
    def initialize(user, name, goal)
        @user = user 
        @name = name
        @goal = goal
        Project.all << self
    end
    
    def self.all
        @@all
    end
    
    def pledges
        Pledge.all.select {|pledge| pledge.project == self}
    end
    
    def backers
        pledges.map {|pledge| pledge.user}
    end
    
    def self.no_pledges
        Project.all.select {|project| project.pledges.length == 0}
    end

    def above_goal?
        amounts = pledges.map {|pledge| pledge.amount}
        if amounts.sum > goal
            true
        else
            false
        end
    end

    def self.above_goal
        Project.all.select {|project| project.above_goal? == true}
    end
    
    def self.most_backers
        backer_counts = Project.all.map {|project| project.backers.count}
        max = backer_counts.max {|count1, count2| count1 <=> count2}
        Project.all.find {|project| project.backers.count == max}
    end
end

#==========================================================================
#==========================================================================
#==========================================================================
#==========================================================================
#==========================================================================
#==========================================================================

class Actor
    attr_reader :name
    @@all = []
    def initialize(name)
        @name = name
        Actor.all << self
    end

    def self.all
        @@all
    end

    def characters
        Character.all.select {|char| char.actor == self}
    end

    def characters_names
        characters.map {|character| character.name}
    end

    def self.most_characters
        Actor.all.max_by {|actor| actor.characters.count}
    end

    def appearances
        characters.map {|character| character.appearances}.flatten
    end

    def movie_appearances
        appearances.select {|appearance| appearance.movie_or_show == "movie"}
    end

    def movies
        movie_appearances.map {|appearance| appearance.title}.uniq
    end

    def show_appearances
        appearances.select {|appearance| appearance.movie_or_show == "show"}
    end

    def shows
        show_appearances.map {|appearance| appearance.title}.uniq
    end
    
    def movie_names
        movies.map {|movie| movie.title}
    end

    def show_names
        shows.map {|show| show.title}
    end

    def self.find_by_name(name_string)
        Actor.all.find {|actor| actor.name == name_string}
    end
end

class Character
    attr_accessor :actor, :name
    @@all = []
    def initialize(actor, name)
        @actor = actor
        @name = name
        Character.all << self
    end

    def self.all
        @@all
    end

    def appearances 
        Appearance.all.select {|appearance| appearance.character == self}
    end

    def shows 
        appearances.select {|appearance| appearance.movie_or_show == "show"}
    end

    def movies
        appearances.select {|appearance| appearance.movie_or_show == "movie"}
    end


    def self.most_appearances
        Character.all.max_by {|char| char.appearances.count}
    end

end

class Appearance
    attr_accessor :character, :title, :movie_or_show
    @@all = []
    def initialize(character, title, movie_or_show)
        @character = character
        @title = title
        @movie_or_show = movie_or_show
        Appearance.all << self
    end

    def self.all
        @@all
    end
end

class Show
    attr_accessor :title
    @@all = []
    def initialize(title)
        @title = title
        Show.all << self
    end
    
    def self.all
        @@all
    end

    def self.all_appearances
        Appearance.all.select {|appearance| appearance.movie_or_show == "show"}
    end
    
    def appearances 
        Show.all_appearances.select {|appearance| appearance.title == self}
    end

    def on_the_big_screen
        Movie.all.select {|movie| movie.title == self.title}
    end
end

class Movie
    attr_accessor :title
    @@all = []
    def initialize(title)
        @title = title
        Movie.all << self
    end

    def self.all
        @@all
    end

    def self.all_appearances
        Appearance.all.select {|appearance| appearance.movie_or_show == "movie"}
    end

    def appearances
        Movie.all_appearances.select {|appearance| appearance.title == self}
    end

    def actors
        appearances.map {|appearance| appearance.character.actor}.uniq
    end
 
    def self.most_actors
        Movie.all.max_by {|movie| movie.actors.count}
    end
end    

def character_profile(name)
    puts "Name: #{name.name}"
    puts "Movies: #{name.movie_names}"
    puts "Shows: #{name.show_names}"
    puts "Characters: #{name.characters_names}"
end


def run
    puts "Welcome to imdb! Please enter an actor's name."
    name = Actor.find_by_name(gets.chomp)
    puts "Here is that actor's profile"
    puts character_profile(name)
end