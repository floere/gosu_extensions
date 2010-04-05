require File.join(File.dirname(__FILE__), '/../../spec_helper')

describe Damaging do
  
  before(:each) do
    @window = stub :window
  end
  
  context 'damage given as block' do
    before(:each) do
      @damaging = test_class_with(Damaging) do
        damage { 10 + 10 }
      end.new @window
    end
    it "should define a method lifetime which returns the result of the block" do
      @damaging.damage.should == 20
    end
  end
  context 'damage given normally' do
    before(:each) do
      @damaging = test_class_with(Damaging) do
        damage 30
      end.new @window
    end
    it "should define a method damage which returns the set value" do
      @damaging.damage.should == 30
    end
  end
  context 'no damage given – what now?' do
    before(:each) do
      @damaging_class = test_class_with Damaging
    end
    it "should raise a DamageMissingError" do
      lambda { @damaging_class.new(@window) }.should raise_error(Damaging::DamageMissingError)
    end
    it "should raise with the right message" do
      lambda { @damaging_class.new(@window) }.should raise_error(Damaging::DamageMissingError, <<-MESSAGE
        In a Damaging thing, you need to define method
          damage damage = nil, &block
        with params
          damage 13 # some value
        or
          damage { 13 + rand(7) } # some block
        to define how much damage the thing does.
      MESSAGE
      )
    end
  end
  
end