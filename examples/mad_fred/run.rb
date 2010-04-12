use_gem = false
use_gem ? require('rubygems') : $:.unshift(File.join(File.dirname(__FILE__), '/../../gem/lib'))
require 'gosu_extensions'

$:.unshift File.dirname(__FILE__)

require 'lib/ambient/smoke'

require 'lib/projectiles/bullet'
require 'lib/projectiles/missile'

require 'lib/units/machinegun'
require 'lib/units/rock'
require 'lib/units/enemy'
require 'lib/units/missile_launcher'
require 'lib/units/jeep'

Resources.root = File.join File.dirname(__FILE__), 'media'

require 'lib/mad_fred'

window = MadFred.new
window.show