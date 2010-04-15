module CP
  module Shape
    
    class Circle
      
      attr_reader :radius, :center
      
      def initialize_with_radius body, radius, center
        @radius, @center = radius, center
        initialize_without_radius body, radius, center
      end
      alias_method_chain :initialize, :radius
      
      
      def debug window, _
        window.draw_circle body.p.x, body.p.y, radius, Gosu::Color::RED
      end
      
    end
    
  end
end