module Gravity
  class Graphics < Struct.new(:screen, :world)
    def initialize(*args)
      super

      extend_point_class
    end

    def draw!
      draw_magnets
      draw_metal_ball
    end

    def draw_metal_ball
      metal_ball = world.metal_ball

      screen.draw_circle_s(metal_ball.position.to_screen_coordinates, 5, [0, 191, 255])
      draw_vector_arrow metal_ball.position, metal_ball.velocity
    end

    def draw_magnets
      world.magnets.each do |magnet|
        draw_attraction_force magnet, world.metal_ball
        screen.draw_circle_s(magnet.position.to_screen_coordinates, 3, [255, 90, 0])
      end
    end

    def draw_vector_arrow(origin_point, vector)
      end_point = origin_point.advance_by vector

      screen.draw_line origin_point.to_screen_coordinates, end_point.to_screen_coordinates, [0, 90, 255]
      screen.draw_circle_s end_point.to_screen_coordinates, 2, [0, 90, 255]
    end

    def draw_attraction_force(magnet, metal_ball)
      coefficient = magnet.attraction_force(metal_ball) / 200
      color = [255, 0, 0].map(&coefficient.method(:*))

      screen.draw_line magnet.position.to_screen_coordinates, metal_ball.position.to_screen_coordinates, color
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
