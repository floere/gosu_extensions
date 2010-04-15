module CP
  module Shape
    
    class Poly
      
      attr_reader :verts, :offset
      
      def initialize_with_verts body, verts, offset
        @verts, @offset = verts, offset
        initialize_without_verts body, verts, offset
      end
      alias_method_chain :initialize, :verts
      
      def debug window, thing
        colors = [Gosu::Color::RED]*verts.size
        points = verts.map{ |vert| vert = vert.rotate(body.a.radians_to_vec2); vert += body.p; [vert.x, vert.y] }.zip(colors).flatten
        points << 0 << :default
        window.draw_quad *points
      end
      
    end
    
  end
end