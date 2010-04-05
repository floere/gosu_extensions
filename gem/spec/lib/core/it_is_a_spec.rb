require File.join(File.dirname(__FILE__), '/../../spec_helper')

describe ItIsA do
  
  before(:all) do
    Trait1 = Trait
    Trait2 = Trait
  end
  
  before(:each) do
    @class = Class.new do
      include ItIsA
      def self.to_s
        "TestClass"
      end
    end
  end
  
  it "should define a it_is_a method that calls include" do
    @class.should_receive(:include).once.with Trait
    
    @class.it_is_a Trait
  end
  it "should take multiple traits" do
    @class.should_receive(:include).once.with Trait1
    @class.should_receive(:include).once.with Trait2
    
    @class.it_is_a Trait1, Trait2
  end
  it "should call a given block on the instance" do
    @class.it_is_a Trait1, Trait2 do
      self.to_s.should == "TestClass"
    end
  end
  
  it "should define a it_is method that calls include" do
    @class.should_receive(:include).once.with Trait
    
    @class.it_is Trait
  end
  it "should take multiple traits" do
    @class.should_receive(:include).once.with Trait1
    @class.should_receive(:include).once.with Trait2
    
    @class.it_is Trait1, Trait2
  end
  it "should call a given block on the instance" do
    @class.it_is Trait1, Trait2 do
      self.to_s.should == "TestClass"
    end
  end
  
  it "should define a it_has method that calls include" do
    @class.should_receive(:include).once.with Trait
    
    @class.it_has Trait
  end
  it "should take multiple traits" do
    @class.should_receive(:include).once.with Trait
    @class.should_receive(:include).once.with Trait2
    
    @class.it_has Trait1, Trait2
  end
  it "should call a given block on the instance" do
    @class.it_has Trait1, Trait2 do
      self.to_s.should == "TestClass"
    end
  end
  
end