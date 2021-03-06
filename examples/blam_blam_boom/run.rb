use_gem = false
use_gem ? require('rubygems') : $:.unshift(File.join(File.dirname(__FILE__), '/../../gem/lib'))
require 'gosu_extensions'

$:.unshift File.dirname(__FILE__)

# require 'lib/ambient/teleport'
require 'lib/ambient/warp'
# require 'lib/ambient/smoke'
require 'lib/ambient/floor'
require 'lib/ambient/open_elevator'

require 'lib/projectiles/bullet'
require 'lib/projectiles/shell'
# require 'lib/projectiles/missile'

require 'lib/weapons/machinegun'
# require 'lib/weapons/missile_launcher'

require 'lib/units/player'
require 'lib/units/naked_man'

Resources.root = File.join File.dirname(__FILE__), 'media'

require 'lib/blam_blam_boom'

window = BlamBlamBoom.new
window.show