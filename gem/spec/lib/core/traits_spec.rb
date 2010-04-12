require File.join(File.dirname(__FILE__), '/../../spec_helper')

describe Traits do
  
  describe "list" do
    it "should return a list of all traits that can be included using it_is_a, it_is, or it_has" do
      ActiveSupport::Deprecation.stub! :warn => :shut_up
      
      Traits.list.should == [Attachable, Controllable, Damaging, Generator, Hitpoints, Imageable, Lives, Moveable, Pod, Shooter, ShortLived, Shot, Targetable, Targeting::Closest, Turnable, UserInterface]
    end
  end
  
end