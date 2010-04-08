#
#
class Waves
  
  attr_reader :window, :scheduling
  
  #
  #
  def initialize window, scheduling
    @window     = window
    @scheduling = scheduling
  end
  
  #
  #
  def add time, generated_type, times, &generation
    add_wave time, Wave.new(generated_type, times, &generation)
  end
  
  #
  #
  def add_wave time, wave
    scheduling.add time, wave.for_scheduling(window)
  end
  
end