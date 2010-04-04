require 'rubygems'
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

require 'resources'
require 'vector_utilities'

$:.unshift File.join(File.dirname(__FILE__), '/extensions')
require 'module'
require 'numeric'

$:.unshift File.join(File.dirname(__FILE__), '/traits')
require 'it_is_a'
require 'pod'
require 'attachable'
require 'damaging'
require 'generator'
require 'initializer_hooks'
require 'lives'
require 'targeting'
require 'targeting/closest'
require 'shooter'
require 'shot'
require 'targetable'
require 'turnable'
require 'controllable'
require 'moveable'
require 'short_lived'

$:.unshift File.join(File.dirname(__FILE__), '/units')
require 'thing'

require 'controls'
require 'menu'
require 'game_window'
require 'scheduling'
require 'waves'
require 'layer'

DEFAULT_SCREEN_WIDTH  = 1200 unless defined?(DEFAULT_SCREEN_WIDTH)
DEFAULT_SCREEN_HEIGHT =  700 unless defined?(DEFAULT_SCREEN_HEIGHT)
SUBSTEPS              =   10 unless defined?(SUBSTEPS)