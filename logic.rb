module Gravity
  class World
    attr_reader :metal_ball

    def initialize
      self.metal_ball = MetalBall.new ::Geometry::Point.new(0, 0), ::Geometry::Vector.new(30, 30)
    end

    def update!(seconds)
      metal_ball.update! seconds
    end

    protected

    attr_writer :metal_ball
  end

  class MetalBall < Struct.new(:position, :velocity)
    def update!(seconds)
      self.position = position.advance_by velocity * seconds
    end
  end
end
