require File.join(File.dirname(__FILE__), '/../../spec_helper')

describe ShortLived do
  
  context 'lifetime given as block' do
    before(:each) do
      @short_lived_class = Class.new do
        it_is ShortLived
        
        lifetime { 10 + 10 }
      end
    end
    it "should define a method lifetime which returns the result of the block" do
      @short_lived_class.new.lifetime.should == 20
    end
  end
  context 'lifetime given normally' do
    before(:each) do
      @short_lived_class = Class.new do
        it_is ShortLived
        
        lifetime 30
      end
    end
    it "should define a method lifetime which returns the set value" do
      @short_lived_class.new.lifetime.should == 30
    end
  end
  context 'no lifetime given – what now?' do
    before(:each) do
      @short_lived_class = Class.new do
        it_is ShortLived
      end
    end
    it "should raise a LifetimeMissingError" do
      lambda { @short_lived_class.new }.should raise_error(ShortLived::LifetimeMissingError)
    end
  end
  
end