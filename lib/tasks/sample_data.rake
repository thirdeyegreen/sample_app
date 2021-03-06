require 'faker'

#add to namespace so it can be called using "rake db:_____"
namespace :db do
  desc "Fill database with sample data"
  task :populate => :environment do
    Rake::Task['db:reset'].invoke #invokes same proc as "rake db:reset" from the terminal
    make_users
    make_microposts
    make_relationships
  end
end

def make_users
  admin = User.create!(:name => "Example User",
               :email => "example@railstutorial.org",
               :password => "foobar",
               :password_confirmation => "foobar")  #initial user. Note: the only attributes that can be set through this call, are those that are defined as attr_accessible in the model.
  admin.toggle!(:admin)
  #create 99 other users
  99.times do |n|
    name = Faker::Name.name #faker-created name
    email = "example-#{n+1}@railstutorial.org"
    password = "password"
    User.create!(:name => name,
                 :email => email,
                 :password => password,
                 :password_confirmation => password)
  end  
end

def make_microposts
  User.all(:limit => 6).each do |user|
    36.times do
      user.microposts.create!(:content => Faker::Lorem.sentence(5))
    end
  end 
end

def make_relationships
  users = User.all
  user = users.first
  following = users[1..50]  #arrays are zero-offset so users[1] is user with id = 2
  followers = users[3..40]
  following.each { |followed| user.follow!(followed) }
  followers.each { |follower| follower.follow!(user) }
end





