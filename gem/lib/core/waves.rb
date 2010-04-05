#
#
class Waves
  
  #
  #
  def initialize window
    @window = window
    @waves = {}
  end
  
  #
  #
  def add amount, type, time
    @waves[time] ||= []
    @waves[time] << [amount, type]
  end
  
  #
  #
  def check time
    if wave? time
      types = @waves[time]
      types.each { |amount, type| amount.times { @window.randomly_add type } }
    end
  end
  
  #
  #
  def wave? time
    !@waves[time].nil?
  end
  
end