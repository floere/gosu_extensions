class MadFred < GameWindow
  
  default_controls
  
  size 1022, 595
  
  caption "Mad Fred"
  
  damping 0.1
  gravity 1
  
  no_collision :player
  no_collision :player, :ambient
  no_collision :player, :player_projectile
  no_collision :ambient, :enemy
  collision :player, :enemy do |player, enemy|
    enemy.destroy!
    player.kill!
    player.draw_ui
  end
  
  def current_speed
    ((self.width - @jeep.position.x) / self.width) + 0.3
  end
  
  def setup_players
    @jeep = add Jeep, 250, height - 20
  end
  
  def next_step
    create_rock  if rand > 0.99
    create_enemy if rand > 0.99
    super
  end
  
  def create_enemy
    add Enemy, width, rand(height-40)+20
  end
  
  def create_rock
    add Rock, width, height
  end
  
end