class Window < GameWindow
  
  it_is Controllable
  controls Gosu::Button::KbEscape => :close
  
  width  1022
  height  595
  
  caption "Mad Fred"
  
  # full_screen
  
  # background 'space.png', :hard_borders => false
  damping 0.1
  
  gravity 1
  
  collisions do
    add_collision_func :player, :player, &nil
    add_collision_func :player, :ambient, &nil
    add_collision_func :enemy, :ambient, &nil
    add_collision_func :player, :player_projectile, &nil
    add_collision_func :player_projectile, :player_projectile, &nil
    add_collision_func :player, :enemy do |player_shape, enemy_shape|
      window.moveables.each do |moveable|
        if moveable.shape == enemy_shape
          moveable.destroy!
        end
        if moveable.shape == player_shape
          moveable.kill!
          moveable.draw_ui
        end
      end
    end
  end
  
  def current_speed
    ((self.width - @jeep.position.x) / self.width) + 0.3
  end
  
  def setup_players
    @jeep = Jeep.new self
    @jeep.warp_to 250, window.height - 20
    register @jeep
  end
  
  def next_step
    create_rock  if rand > 0.99
    create_enemy if rand > 0.99
    super
  end
  
  def create_enemy
    enemy = Enemy.new self
    enemy.warp_to window.width, rand(window.height-40) + 20
    window.register enemy
  end
  
  def create_rock
    rock = Rock.new self
    rock.warp_to window.width, window.height
    window.register rock
  end
  
end