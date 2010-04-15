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
    player1 = Player.new self
    player1.controls Gosu::Button::KbW => :jump,
                     Gosu::Button::KbA => Moveable::Left,
                     Gosu::Button::KbD => Moveable::Right,
                     Gosu::Button::KbQ => Shooter::Shoot
                     # reload on down?
    player2 = Player.new self
    player2.controls Gosu::Button::KbY     => :jump,
                     Gosu::Button::KbG     => Moveable::Left,
                     Gosu::Button::KbJ     => Moveable::Right,
                     Gosu::Button::KbSpace => Shooter::Shoot
    
    player3 = Player.new self
    player3.controls Gosu::Button::KbUp    => :jump,
                     Gosu::Button::KbLeft  => Moveable::Left,
                     Gosu::Button::KbRight => Moveable::Right,
                     Gosu::Button::KbI     => Shooter::Shoot
    
    @players = [player1, player2, player3]
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