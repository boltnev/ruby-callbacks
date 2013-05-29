module Global 
  def self.included(base)
    puts "loaded" 
  end
end

class Object
  include Global
end

class Test 
end


