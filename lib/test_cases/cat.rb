require "callbackable"

class Cat 
  include Callbackable

  attr_accessor :name, :colour
  attr_reader :method_calls
  
  callback :after, :eat, :play
  callback :before, :catch_mouse, :hiss  
  
  def initialize(name, colour)
    @name = name
    @colour = colour
    @method_calls = {}
  end
    
  def sleep
    @method_calls[__method__] = Time.now
  end

  def eat
    @method_calls[__method__] = Time.now
  end

  def play
    @method_calls[__method__] = Time.now
  end
  
  def purr
    @method_calls[__method__] = Time.now
  end

  def run
    @method_calls[__method__] = Time.now
  end
  
  def hiss
    @method_calls[__method__] = Time.now
  end

  def catch_mouse
    @method_calls[__method__] = Time.now
  end
  
end
