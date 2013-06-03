
small ruby library for callback implementation

=== Example

  require "ruby-callbacks"

  class Cat 
    include Callbacks

    attr_accessor :name, :colour

    callback :after, :eat, :play
    callback :before, :eat, :sleep

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

  end

  kitty = Cat.new("Kitty", "black")

  kitty.eat 
  #   => Kitty the cat is sleeping
  #   => Kitty the cat is eating
  #   => Kitty the cat is playing

