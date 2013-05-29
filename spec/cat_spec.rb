require 'spec_helper'
require 'test_cases/cat'

describe Cat do

  it "has name Kitty and black colour" do
    @cat = Cat.new("Kitty", "black")
    @cat.name.should eq "Kitty"
    @cat.colour.should eq "black"
  end
  
  it "should play after eat" do
    @cat = Cat.new("Kitty", "black")
    @cat.eat
  end
end
