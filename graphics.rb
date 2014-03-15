module Gravity
  class Graphics < Struct.new(:screen, :world)
    def draw!
      draw_metal_ball
    end

    def draw_metal_ball
      screen.draw_circle_s(world.metal_ball.position, 3, [0x33, 0, 0xff])
    end
  end
end
