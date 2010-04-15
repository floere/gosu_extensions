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
  
  default_controls
  
  size 1024, 768
  
  caption "Blam BLam Boom - shoot each other to bits"
  background Gosu::Color.new(0xff336699)
  
  damping 0.3
  gravity 0.98
  
  collision :player, :projectile do |player, projectile|
    player.damage! projectile.damage
    projectile.destroy!
    player.draw_ui # TODO update_ui?
  end
  
  def setup_players
    thinboy = Player.new self
    thinboy.controls Gosu::Button::KbW => [:jump, 45],
                     Gosu::Button::KbA => Moveable.left(1.5),
                     Gosu::Button::KbD => Moveable.right(1.5),
                     Gosu::Button::KbQ => Shooter::Shoot
                     # reload on down?
    fatty = Player.new self
    fatty.controls Gosu::Button::KbY     => [:jump, 30],
                   Gosu::Button::KbG     => Moveable.left(1.0),
                   Gosu::Button::KbJ     => Moveable.right(1.0),
                   Gosu::Button::KbSpace => Shooter::Shoot
    
    otto = Player.new self
    otto.controls Gosu::Button::KbUp    => [:jump, 37.5],
                  Gosu::Button::KbLeft  => Moveable.left(1.25),
                  Gosu::Button::KbRight => Moveable.right(1.25),
                  Gosu::Button::KbI     => Shooter::Shoot
    
    @players = [thinboy, fatty, otto]
    @players.each { |player| player.warp_to *uniform_random_position; player.show }
  end
  
  def after_setup
    create_floor
  end
  
  def create_floor
    1.upto(5) { |y| 2.upto(10) { |x| add Floor, x*40, y*120 } }
    1.upto(5) { |y| 16.upto(24) { |x| add Floor, x*40, y*120 } }
  end
  
  def game_over?
    @players.all?
  end
  
end