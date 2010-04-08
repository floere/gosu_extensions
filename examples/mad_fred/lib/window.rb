class Window < GameWindow
  
  it_is Controllable
  controls Gosu::Button::KbEscape => :close
  
  width  1022
  height  595
  
  caption "Mad Fred"
  
  # background 'space.png', :hard_borders => false
  damping 0.1
  
  gravity 1
  
  collisions do
    add_collision_func :player, :player, &nil
    add_collision_func :player, :player_projectile, &nil
  end
  
  def setup_players
    @jeep = Jeep.new self
    @jeep.warp_to 100, window.height - 20
    register @jeep
  end
  
  def next_step
    create_rock if rand > 0.98
    super
  end
  
  def create_rock
    rock = Rock.new self
    rock.warp_to window.width, window.height
    window.register rock
  end
  
end