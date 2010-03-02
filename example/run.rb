require File.join(File.dirname(__FILE__), '/../gem/init')
$:.unshift File.dirname(__FILE__)

require 'lib/projectiles/bullet'
require 'lib/projectiles/missile'

require 'lib/units/enemy'
require 'lib/units/missile_launcher'

MEDIA_PATH = File.join File.expand_path('.'), 'example', 'media'

require 'lib/space_battle'

battle = SpaceBattle.new
battle.show