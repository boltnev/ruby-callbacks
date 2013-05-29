require "callbackable"

class Cat 
  include Callbackable

  attr_accessor :name, :colour

  callback :after, :eat, :play
  
  def initialize(name, colour)
    @name = name
    @colour = colour
  end
    
  def sleep
    puts "#{@name} the cat is sleeping"
  end

  def eat
    puts "#{@name} the cat  is eating"
  end

  def play
    puts "#{@name} the cat  is playing"
  end
 
  run_callbacks
end
