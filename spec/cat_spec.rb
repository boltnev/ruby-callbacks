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
  
  it "should play after eat" do
    cat.eat
    cat.method_calls[:eat].should be < @cat.method_calls[:play]
  end

  it "should hiss before catch_mouse" do
    cat.catch_mouse
    cat.method_calls[:hiss].should be < @cat.method_calls[:catch_mouse]
  end
end
