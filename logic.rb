module Gravity
  include Geometry

  class World
    attr_reader :metal_ball
    attr_reader :magnets

    def initialize
      self.metal_ball = MetalBall.new Geometry::Point.new(0, -400), Geometry::Vector.new(0, 90)
      self.magnets = [
                      Magnet.new(Geometry::Point.new(-50, 0), self)
                     ]
    end

    def update!(seconds)
      metal_ball.update! seconds
      magnets.each do |magnet|
        magnet.update! seconds
      end
    end

    protected

    attr_writer :metal_ball
    attr_writer :magnets
  end

  class MetalBall < Struct.new(:position, :velocity)
    def update!(seconds)
      self.position = position.advance_by velocity * seconds
    end
  end

  class Magnet < Struct.new(:position, :world)
    def update!(seconds)
      metal_ball = world.metal_ball

      distance = Geometry.distance(position, metal_ball.position)
      attraction_force = 1000000 / distance ** 2

      attraction_force_vector = Geometry::Vector.by_end_points(metal_ball.position, self.position).unit_vector * attraction_force * seconds

      metal_ball.velocity = metal_ball.velocity + attraction_force_vector
    end
  end
end

Geometry::Vector.class_eval do
  def self.by_end_points(origin_point, end_point)
    new end_point.x - origin_point.x, end_point.y - origin_point.y
  end

  def /(scalar)
    self * (1 / scalar.to_f)
  end

  def unit_vector
    self / modulus
  end
end
