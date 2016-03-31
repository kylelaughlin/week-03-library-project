require_relative "config/environment.rb"
require "active_record"
require "pry"
require "yaml"
require_relative "./lib/library.rb"

puts "This should only be in the library branch"

binding.pry
