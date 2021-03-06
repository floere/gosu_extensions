# Blam blam boom!
# It's a game where three "friends" blow each other to bits.
#
# Features:
# * Teleporter
# * In-Warping Weapons
# * Flashbangs
# * Slo-Mo Mode # invoked when two players are really close :)
#
class BlamBlamBoom < GameWindow
  
  # debug
  
  # full_screen
  
  default_controls
  
  size 1024, 768
  
  caption "Blam BLam Boom - shoot each other to bits"
  background # Gosu::Color.new(0xff336699)
  
  damping 0.1
  gravity 0.98
  
  no_collision :weapon
  no_collision :player, :weapon
  no_collision :elevator, :projectile
  collision :player, :elevator do |player, _|
    player.speed += CP::Vec2.new(0, -0.2)
  end
  collision :player, :projectile do |player, projectile|
    player.hit! projectile.damage
    projectile.destroy!
  end
  
  def setup_players
    thinboy = NakedMan.new self
    thinboy.controls Gosu::Button::KbW => [:jump, 45],
                     Gosu::Button::KbA => Moveable.left(1.5),
                     Gosu::Button::KbD => Moveable.right(1.5),
                     Gosu::Button::KbQ => :shoot
    thinboy.ui 20, 10, Gosu::Color::BLACK do "Thinboy: #{lives}/#{hitpoints}" end
    
    fatty = NakedMan.new self
    fatty.controls Gosu::Button::KbY     => [:jump, 30],
                   Gosu::Button::KbG     => Moveable.left(1.0),
                   Gosu::Button::KbJ     => Moveable.right(1.0),
                   Gosu::Button::KbSpace => :shoot
    fatty.ui 180, 10, Gosu::Color::BLACK do "Fatty: #{lives}/#{hitpoints}" end
      
    otto = NakedMan.new self
    otto.controls Gosu::Button::KbUp    => [:jump, 37.5],
                  Gosu::Button::KbLeft  => Moveable.left(1.25),
                  Gosu::Button::KbRight => Moveable.right(1.25),
                  Gosu::Button::KbRightShift => :shoot
    otto.ui 340, 10, Gosu::Color::BLACK do "Otto: #{lives}/#{hitpoints}" end
    
    mg = add Machinegun, 0, 0
    otto.attach mg, 0, 0
    
    @players = [thinboy, fatty, otto]
    @players.each { |player| player.show; player.reset }
  end
  
  def after_setup
    create_elevator
    create_floor
  end
  
  def create_elevator
    add OpenElevator, width/2, 400
  end
  
  def create_floor
    1.upto(5) { |y| 2.upto(10) { |x| add Floor, x*41, y*120 } }
    1.upto(5) { |y| 15.upto(23) { |x| add Floor, x*41, y*120 } }
  end
  
  def game_over?
    @players.all?
  end
  
end