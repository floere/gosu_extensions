require 'thread'
Mutex
require 'active_support'
# require 'texplay'
begin
  require 'gosu'
rescue LoadError => e
  puts "Couldn't find gem gosu. Install using:\n\nsudo gem install gosu.\n\n"
  raise e
end
begin
  require 'chipmunk' # A physics framework.
rescue LoadError => e
  puts "Couldn't find gem chipmunk. Install using:\n\nsudo gem install chipmunk.\n\n"
  raise e
end

$:.unshift File.join(File.dirname(__FILE__), '/extensions')
require 'module'
require 'numeric'
require 'math'
require 'circle'
require 'poly'

$:.unshift File.join(File.dirname(__FILE__), '/core')
require 'resources'

require 'vector_utilities'
require 'rotation'
require 'initializer_hooks'

require 'trait'
require 'traits'
require 'it_is_a'

require 'threading'
require 'background'
require 'sprites'
require 'things'
require 'objects'
require 'wave'
require 'waves'
require 'scheduling'
require 'collision'
require 'environment'
require 'game_window'
require 'control'
require 'controls'
require 'layer'

$:.unshift File.join(File.dirname(__FILE__), '/traits')
require 'user_interface'
require 'pod'
require 'attachable'
require 'damaging'
require 'generator'
require 'lives'
require 'hitpoints'
require 'targeting'
require 'targeting/closest'
require 'shooter'
require 'shot'
require 'targetable'
require 'turnable'
require 'controllable'
require 'moveable'
require 'imageable'
require 'short_lived'

$:.unshift File.join(File.dirname(__FILE__), '/units')
require 'sprite'
require 'thing'

DEFAULT_SCREEN_WIDTH  = 1200 unless defined?(DEFAULT_SCREEN_WIDTH)
DEFAULT_SCREEN_HEIGHT =  700 unless defined?(DEFAULT_SCREEN_HEIGHT)
SUBSTEPS              =   10 unless defined?(SUBSTEPS)