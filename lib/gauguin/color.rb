module Gauguin
  class Color
    attr_accessor :red, :green, :blue, :percentage, :transparent

    def initialize(red, green, blue, percentage = 1, transparent = false)
      self.red = red
      self.green = green
      self.blue = blue
      self.percentage = percentage
      self.transparent = transparent
    end

    def ==(other)
      self.to_key == other.to_key
    end

    def eql?(other)
      self.to_key.eql?(other.to_key)
    end

    def hash
      self.to_key.hash
    end

    def similar?(other_color)
      self.transparent == other_color.transparent &&
        self.distance(other_color) < Gauguin.configuration.color_similarity_threshold
    end

    def distance(other_color)
      (self.to_lab - other_color.to_lab).r
    end

    def to_lab
      rgb_vector = self.to_vector
      xyz_vector = rgb_vector.to_xyz
      xyz_vector.to_lab
    end

    def to_vector
      ColorSpace::RgbVector[*to_a]
    end

    def to_a
      [self.red, self.green, self.blue]
    end

    def to_key
      to_a + [self.transparent]
    end

    def to_s
      "rgb(#{self.red}, #{self.green}, #{self.blue})"
    end

    def inspect
      msg = "#{to_s}[#{percentage}]"
      if transparent?
        msg += "[transparent]"
      end
      msg
    end

    def transparent?
      self.transparent
    end
  end
end

