require File.join(File.dirname(__FILE__), '/../../spec_helper')

describe ShortLived do
  
  before(:all) do
    @window = stub :window
  end
  
  class SuperClass; def initialize(*); end; end
  
  module ThreadedMock
    def threaded lifetime
      # TODO
    end
  end
  
  def self.threaded_mock expected
    
  end
  
  context 'lifetime given as block' do
    before(:each) do
      @short_lived_class = Class.new(SuperClass) do
        include ShortLived
        
        lifetime { 10 + 10 }
        
        def threaded(*); end
      end
    end
    it "should define a method lifetime which returns the result of the block" do
      @short_lived_class.new(@window).lifetime.should == 20
    end
  end
  context 'lifetime given normally' do
    before(:each) do
      @short_lived_class = Class.new(SuperClass) do
        include ShortLived
        
        lifetime 30
        
        def threaded(*); end
      end
    end
    it "should define a method lifetime which returns the set value" do
      @short_lived_class.new(@window).lifetime.should == 30
    end
  end
  context 'no lifetime given – what now?' do
    before(:each) do
      @short_lived_class = Class.new(SuperClass) do
        include ShortLived
      end
    end
    it "should raise a LifetimeMissingError" do
      lambda { @short_lived_class.new(@window) }.should raise_error(ShortLived::LifetimeMissingError)
    end
  end
  
end