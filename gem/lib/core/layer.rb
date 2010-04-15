# Layering of sprites.
#
# 4 Layers:
# * UI
# * Players (Controlled and AI Elements)
# * Ambient (Moveable Background)
# * Background (Fixed, true Background)
#
module Layer
  Background, Ambient, Players, UI, Debug = 0, 1, 2, 3, 4
end