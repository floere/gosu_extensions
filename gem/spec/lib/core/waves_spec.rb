require File.join(File.dirname(__FILE__), '/../../spec_helper')

describe Waves do
  
  before(:each) do
    @window     = stub :window
    @scheduling = stub :scheduling
    @waves      = Waves.new @window, @scheduling
  end
  
  describe "add" do
    it "should create a new wave and delegate" do
      time = stub :time
      type = stub :type
      times = stub :times
      block = lambda {}
      wave = stub :wave
      Wave.should_receive(:new).once.with(type, times, &block).and_return wave
      
      @waves.should_receive(:add_wave).once.with time, wave
      
      @waves.add time, type, times, &block
    end
  end
  
  # TODO add_wave
  
end