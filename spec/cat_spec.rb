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

  it "class could show if callback exists" do
    expect(cat.class.callback_exists? "eat").to be true 
    expect(cat.class.callback_exists? "purr").to be false  
    expect(cat.class.callback_exists? "catch_mouse").to be true 
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
  
    subject(:cat) do 
      Cat.add_callback :after, :sleep, :eat
      @cat = Cat.new("Kitty", "black")
    end
    
    it "class could show if callback exists" do
      expect(cat.class.callback_exists? "sleep").to be true  
    end
    
    it "eat after sleep" do
      cat.sleep
      cat.method_calls[:sleep].should be < @cat.method_calls[:eat]
      cat.method_calls[:eat].should be < @cat.method_calls[:play]
    end
    
    context "with 2 callbacks on one method" do
      subject (:cat) do 
        Cat.add_callback :after, :eat, :purr
        @cat = Cat.new("Kitty", "black")
      end

      it "class could show if callback exists" do
        expect(cat.class.callback_exists? "eat").to be true 
        expect(cat.class.callback_exists? "purr").to be false  
      end

      it "purrs and plays after eat" do
        cat.eat
        cat.method_calls[:eat] < cat.method_calls[:purr]
        cat.method_calls[:eat] < cat.method_calls[:play]
        cat.method_calls[:purr] < cat.method_calls[:play] 
      end
    end
  
  end
end
