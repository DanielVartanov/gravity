module Gravity
  class Graphics < Struct.new(:screen, :world)
    def initialize(*args)
      super

      extend_point_class
    end

    def draw!
      draw_metal_ball
      draw_magnets
    end

    def draw_metal_ball
      screen.draw_circle_s(world.metal_ball.position.to_screen_coordinates, 5, [0, 191, 255])
    end

    def draw_magnets
      world.magnets.each do |magnet|
        screen.draw_circle_s(magnet.position.to_screen_coordinates, 3, [255, 90, 0])
      end
    end

    def extend_point_class
      screen_centre = screen.size.map { |axis| axis / 2 }

      point_extension = Module.new do
        define_method :to_screen_coordinates do
          [screen_centre[0] + x, screen_centre[1] - y]
        end
      end

      ::Geometry::Point.class_eval do
        include point_extension
      end
    end
  end
end
