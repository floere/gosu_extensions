require File.join(File.dirname(__FILE__), '/../gem/init')
$:.unshift File.dirname(__FILE__)

require 'lib/ambient/smoke'
require 'lib/ambient/small_explosion'

require 'lib/projectiles/bullet'
require 'lib/projectiles/missile'

require 'lib/units/player'
require 'lib/units/enemy'
require 'lib/units/missile_launcher'

Resources.root = File.join File.expand_path('.'), 'example', 'media'

require 'lib/space_battle'

battle = SpaceBattle.new
battle.show