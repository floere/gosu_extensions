require File.join(File.dirname(__FILE__), '/../../spec_helper')

describe Module do
  
  before(:each) do
    @module = Module.new do
      def self.to_s
        "Bla" # module name in output
      end
    end
  end
  
  describe "manual" do
    it "should define the method" do
      lambda { @module.manual("some text") }.should_not raise_error
    end
    it "should not have a manual! method if the manual method is not called" do
      lambda { @module.manual! }.should raise_error(NoMethodError)
    end
  end
  describe "manual!" do
    it "should define such a method" do
      @module.stub! :puts => :we_are_not_interested_in_this
      @module.manual "some text"
      
      lambda { @module.manual! }.should_not raise_error
    end
    it "should define such a method which puts a given text, formatted" do
      @module.should_receive(:puts).once.with <<-EXPECTED
    MANUAL FOR Bla
      some text
    Change Bla.manual! -> Bla, to not show the manual anymore.
EXPECTED
      
      @module.manual "some text"
      @module.manual!
    end
  end
  
end