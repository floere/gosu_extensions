$:.unshift File.join(File.dirname(__FILE__), '/../../gem/lib')
require 'gosu_extensions'

$:.unshift File.dirname(__FILE__)

require 'lib/ambient/smoke'
require 'lib/ambient/small_explosion'

require 'lib/projectiles/bullet'
require 'lib/projectiles/missile'

require 'lib/units/spaceship'
require 'lib/units/tank'
require 'lib/units/enemy'
require 'lib/units/missile_launcher'

Resources.root = File.join File.dirname(__FILE__), 'media'

require 'lib/space_battle'

battle = SpaceBattle.new
battle.show # TODO show a splash screen first