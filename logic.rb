module Gravity
  include Geometry

  class World
    attr_reader :metal_ball
    attr_reader :magnets

    def initialize
      self.metal_ball = MetalBall.new Geometry::Point.new(0, -400), Geometry::Vector.new(0, 90)
      self.magnets = [
                      Magnet.new(Geometry::Point.new(-50, 0), self),
                      Magnet.new(Geometry::Point.new(0, 50), self),
                      Magnet.new(Geometry::Point.new(10, 150), self),
                      Magnet.new(Geometry::Point.new(10, 250), self),
                      Magnet.new(Geometry::Point.new(400, 150), self),
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
    def attraction_force(metal_ball)
      distance = Geometry.distance(position, metal_ball.position)
      1000000 / distance ** 2
    end

    def update!(seconds)
      metal_ball = world.metal_ball

      attraction_force_vector = Geometry::Vector.by_end_points(metal_ball.position, self.position).unit_vector * attraction_force(metal_ball) * seconds

      metal_ball.velocity = metal_ball.velocity + attraction_force_vector
    end
  end
end

Geometry::Point.class_eval do
  def rotate_around(center, angle)
    diff = Point.new(x - center.x, y - center.y)

    Point.new(center.x + diff.x * Math.cos(angle) - diff.y * Math.sin(angle),
              center.y + diff.x * Math.sin(angle) + diff.y * Math.cos(angle))
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

  def rotate(angle)
    self.to_point.rotate_around(Point(0, 0), angle).to_vector
  end

  def to_point
    Point x, y
  end
end
