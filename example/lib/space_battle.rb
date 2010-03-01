class SpaceBattle < GameWindow
  
  width  1200
  height  700
  full_screen
  caption "Incredible Space Battles!"
  
  font Gosu::default_font_name, 20
  
  background 'media/space.png', :repeating => true
  damping 1.0
  
end