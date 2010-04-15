use_gem = false
use_gem ? require('rubygems') : $:.unshift(File.join(File.dirname(__FILE__), '/../../gem/lib'))
require 'gosu_extensions'

$:.unshift File.dirname(__FILE__)

require 'lib/ambient/smoke'
require 'lib/ambient/small_explosion'

require 'lib/projectiles/bullet'
require 'lib/projectiles/missile'

require 'lib/units/debris'
require 'lib/units/tank'
require 'lib/units/spaceship'
require 'lib/units/enemy'
require 'lib/units/missile_launcher'

Resources.root = File.join File.dirname(__FILE__), 'media'

require 'lib/tank_vs_spaceship'

battle = TankVsSpaceship.new
battle.show # TODO show a splash screen first