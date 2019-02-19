require "mongoid"
Mongoid.load!("./config/mongoid.yml", :development)

require_relative "models/rating_question"
Mongoid.raise_not_found_error = false
