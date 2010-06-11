use_gem = false
use_gem ? require('rubygems') : $:.unshift(File.join(File.dirname(__FILE__), '/../../gem/lib'))
require 'gosu_extensions'

$:.unshift File.dirname(__FILE__)

require 'lib/units/player'
require 'lib/units/black_hole'

Resources.root = File.join File.dirname(__FILE__), 'media'

require 'lib/cern_horror'

window = CernHorror.new
window.show