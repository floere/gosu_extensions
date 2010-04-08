# "Threading"
# A hash with time => [block, block, block ...]
#
# {
#   100 => [{bla}, {blu}, {bli}],
#   1   => [{eek}]
# }
#
# When calling threading.step, eek will be executed, the others will be one step closer to zero, 99.
#
class Scheduling
  
  def initialize
    @threads = []
  end
  
  # Adds a code block at time time.
  #
  def add time = 1, proc = nil, &code
    @threads << [time, code || proc]
  end
  
  # Does two things:
  # 1. Move one step in time.
  # 2. Execute all blocks with time 0.
  #
  # TODO Rewrite to be faster.
  #
  # FIXME - threads added while threads are handled!
  #
  def step
    @threads.collect! do |time, code|
      if time == 1
        code.call
        nil
      else
        [time-1, code]
      end
    end.compact!
  end
  
  # Call all given blocks.
  #
  def execute codes
    codes.each &:[]
  end
  
end