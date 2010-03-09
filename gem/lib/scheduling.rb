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
    # @threads = {}
    @threads = []
  end
  
  # Adds a code block at time time.
  #
  def add time = 1, &code
    # @threads[time] ||= []
    # @threads[time] << code
    @threads << [time, code]
    # @threads.sort!
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
        code[]
        nil
      else
        [time-1, code]
      end
    end.compact!
    # new_threads = {}
    # 
    # execute @threads[1]
    # 
    # # Go over all threads.
    # #
    # @threads.each_pair do |time, codes|
    #   # Set time 1 lower.
    #   #
    #   time = time - 1
    #   if time == 0
    #     # Execute all if time is 0.
    #     #
    #     execute codes
    #   else
    #     # Else use in new scheduling hash.
    #     #
    #     new_threads[time] = codes
    #   end
    # end
    # 
    # @threads = new_threads
  end
  
  # Call all given blocks.
  #
  def execute codes
    codes.each &:[]
  end
  
end