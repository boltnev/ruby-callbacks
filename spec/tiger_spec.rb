require 'test_cases/tiger'

describe Tiger, "inherited from Cat" do
  subject(:tiger) { @tiger = Tiger.new("Shere Khan", "stripped" ) }

  it "should also as Cat play after eat" do
    tiger.eat
    tiger.method_calls[:eat].should_not be nil
    tiger.method_calls[:play].should_not be nil
    tiger.method_calls[:eat].should be < tiger.method_calls[:play]
  end
  
end
