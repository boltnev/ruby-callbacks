require 'spec_helper'
require 'test_cases/cat'

describe Cat do
 
  subject(:cat) { @cat = Cat.new("Kitty", "black") }

  its(:name) {should eq "Kitty" }
  its(:colour) {should eq "black" }
  its(:method_calls) {should eq Hash.new }
  
  it "has method_calls journal" do
    cat.purr
    cat.method_calls[:purr].should_not be nil 
    
    cat.run
    cat.method_calls[:run].should_not be nil
    
    cat.method_calls[:purr].should be < @cat.method_calls[:run]
  end
  
  it "class could show if callbacks exist on given method" do
    expect(cat.class.callbacks_exist? "eat").to be true 
    expect(cat.class.callbacks_exist? "purr").to be false  
    expect(cat.class.callbacks_exist? "catch_mouse").to be true 
  end
  
  it "class could show if such callback exists on given method " do
    expect(cat.class.callback_exists? "eat", "play").to be true 
    expect(cat.class.callback_exists? "eat", "purr").to be false  
  end
  
  it "should play after eat" do
    cat.eat
    cat.method_calls[:eat].should be < @cat.method_calls[:play]
  end

  it "should hiss before catch_mouse" do
    cat.catch_mouse
    cat.method_calls[:hiss].should be < @cat.method_calls[:catch_mouse]
  end

  context "with new callback" do
  
    before(:all) {Cat.add_callback :after, :sleep, :eat}
    after(:all) {Cat.del_callback :eat, :sleep}

    subject(:cat) do 
      @cat = Cat.new("Kitty", "black")
    end
    
    it "class could show if callback exists" do
      expect(cat.class.callbacks_exist? "sleep").to be true  
    end
    
    it "eat after sleep" do
      cat.sleep
      cat.method_calls[:sleep].should be < @cat.method_calls[:eat]
      cat.method_calls[:eat].should be < @cat.method_calls[:play]
    end
    
  end


  context "with 2 callbacks on one method" do
    
    before(:all) {Cat.add_callback :after, :eat, :purr}
    after(:all) {Cat.del_callback :eat, :purr}

    subject (:cat) do 
      @cat = Cat.new("Kitty", "black")
    end

    it "class could show if callback exists" do
      expect(cat.class.callbacks_exist? "eat").to be true 
      expect(cat.class.callbacks_exist? "purr").to be false  
    end

    it "purrs and plays after eat" do
      cat.eat
      cat.method_calls[:eat] < cat.method_calls[:purr]
      cat.method_calls[:eat] < cat.method_calls[:play]
      cat.method_calls[:purr] < cat.method_calls[:play] 
    end
  end
  
  context "with deleted callbacks" do
    
    before(:all) do 
      Cat.add_callback(:after, :eat, :purr)   
      Cat.add_callback(:before, :catch_mouse, :run)
    end

    it "callbacks can be removed" do
      cat.class.del_callback(:eat)
      expect(cat.class.callbacks_exist? :eat).to be false 
      
      # return default Cat callback 
      # for other test correctness 
      cat.class.add_callback(:after, :eat, :play)
      
      expect(cat.class.callbacks_exist? :catch_mouse).to be true 
      
      Cat.del_callback(:catch_mouse, :run)

      expect(cat.class.callbacks_exist? :catch_mouse).to be true 

    end    
  
  end
end
