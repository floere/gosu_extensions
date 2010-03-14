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

$:.unshift File.join(File.dirname(__FILE__), '/lib')
require 'resources'

$:.unshift File.join(File.dirname(__FILE__), '/lib/extensions')
require 'module'
require 'numeric'

$:.unshift File.join(File.dirname(__FILE__), '/lib/traits')
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

$:.unshift File.join(File.dirname(__FILE__), '/lib/units')
require 'thing'
require 'moveable'
require 'short_lived'

require 'controls'
require 'game_window'
require 'scheduling'
require 'waves'
require 'layer'

DEFAULT_SCREEN_WIDTH  = 1200
DEFAULT_SCREEN_HEIGHT =  700
SUBSTEPS              =   10