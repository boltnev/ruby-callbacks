module Callbackable
  
  # module Callbackable allows to add callbacks
  # before and after methods  
  # 
  # == Example
  # require "callbackable"
  # 
  # class Cat 
  #   include Callbackable
  # 
  #   attr_accessor :name, :colour
  # 
  #   callback :after, :eat, :play
  #   callback :before, :eat, :sleep
  #
  #   def initialize(name, colour)
  #     @name = name
  #     @colour = colour
  #   end
  #     
  #   def sleep
  #     puts "# {@name} the cat is sleeping"
  #   end
  # 
  #   def eat
  #     puts "# {@name} the cat  is eating"
  #   end
  # 
  #   def play
  #     puts "# {@name} the cat  is playing"
  #   end
  #  
  #   run_callbacks
  # end
  #
  # kitty = Cat.new("Kitty", "black")
  #
  # kitty.eat 
  # # => Kitty the cat is sleeping
  # # => Kitty the cat is eating
  # # => Kitty the cat is playing
  
  class UnknownEventException < Exception; end
  
  # md5 for word "method"
  SALT = "ea9f6aca279138c58f705c8d4cb4b8ce"

  def self.included(base)

    base.class_eval do 
      @@_method_chain = Hash.new
    
      # show current_method_chain
      def self.method_chain
        @@_method_chain
      end

      # allows to add a callback to already initialized class
      # class Cat 
      #   
      #   def purr
      #     #purr
      #   end
      #   
      #   def sleep
      #     #sleep
      #   end
      # end
      #
      # Cat.add_callback(:after, :purr, :sleep)
      # Cat.new.purr # purr, then sleep
      def self.add_callback(event, method, callback)
        if callbacks_exist? method 
          callback(event, method, callback)
        else
          callback(event, method, callback)
          alias_method new_method_name(method), method
          undef_method method 
          
          define_method method do
            call_method_chain(method)
          end
        end
      end

      # Delete existing callback
      # if callback == nil deletes all callbacks on given *method*
      def self.del_callback(method, callback = nil)
        if callback
          @@_method_chain[method].delete_if{|c| c == callback }
          del_all_callbacks(method) if @@_method_chain[method].size == 1
        else
          del_all_callbacks(method)
        end
      end
      
      # Are callback *callback* on this method already exists?
      def self.callback_exists?(method, callback)
        !@@_method_chain[method.to_sym].detect{|c| c == callback.to_sym }.nil?
      end
      
      # Are callbacks on this method already exists?
      def self.callbacks_exist?(method)
        !@@_method_chain[method.to_sym].nil?
      end
      
      private

      # Register new callback 
      def self.callback(event, method, callback)
        reg_callback(event.to_sym, method.to_sym, callback.to_sym)
      end
      
      def self.del_all_callbacks(method)
        undef_method method
        alias_method method, new_method_name(method)
        @@_method_chain[method] = nil
      end
      
      # run all callbacks. 
      # call it after all methods defined
      def self.run_callbacks
        @@_method_chain.each_key do |method|
          alias_method new_method_name(method), method 
          undef_method method 
          
          define_method method do
            call_method_chain(method)
          end
        end
      end

      def self.new_method_name(method)
        "#{method}_#{SALT}"
      end

      def self.reg_callback(event, method, callback)
        raise UnknownEventException if (event != :before &&  event != :after)
        @@_method_chain[method] = [new_method_name(method)] unless @@_method_chain[method]
        
        if event === :before
          reg_before_callback(method, callback)
        elsif event === :after
          reg_after_callback(method, callback)
        end        
      end 

      def self.reg_before_callback(method, callback)
        @@_method_chain[method].insert \
           (@@_method_chain[method].index new_method_name(method)), callback
      end

      def self.reg_after_callback(method, callback)
        @@_method_chain[method].push callback
      end
      
      def call_method_chain(method)
        @@_method_chain[method].each do |action|
          self.send(action)
        end
      end
    end

  end

end
