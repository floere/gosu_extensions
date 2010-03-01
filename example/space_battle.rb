require File.join(File.dirname(__FILE__), '/../gem/init')

$:.unshift File.dirname(__FILE__)

require 'projectiles/bullet'
require 'projectiles/missile'

require 'units/enemy'
require 'units/missile_launcher'

class SpaceBattle < GameWindow
  
  width  1200
  height  700
  full_screen true
  caption "Incredible Space Battles!"
  
  font Gosu::default_font_name, 20
  
  background 'media/space.png', :repeating => true
  damping 1.0
  
end