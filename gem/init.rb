require 'rubygems'
require 'active_support'
# require 'texplay'
require 'gosu'
# require 'chipmunk' # A physics framework.

$:.unshift File.join(File.dirname(__FILE__), '/lib')
require 'controls'
require 'game_window'
require 'scheduling'
require 'waves'
require 'z_order'

$:.unshift File.join(File.dirname(__FILE__), '/lib/extensions')
require 'numeric'

$:.unshift File.join(File.dirname(__FILE__), '/lib/traits')
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

$:.unshift File.join(File.dirname(__FILE__), '/lib/units')
require 'thing'
require 'short_lived'