require "sdl/image"
require "sdl/ttf"
require "sdl/hint"

module Molly2d
  module Molly
    def clear
      if (b = Molly.background).is_a?(Color)
        Molly.renderer.draw_color = b.to_sdl
      end
      Molly.renderer.clear
      if (b = Molly.background).is_a?(SDL::Surface)
        Molly.renderer.copy(b, dstrect: SDL::Rect[0, 0, Molly.window.width, Molly.window.height])
      end
    end

    def render
      Molly.renderer.present
    end

    def set_color(color : Molly2d::Color)
      Molly.renderer.draw_color = color.to_sdl
    end
  end

  class Color
    def initialize(@r : Int32, @g : Int32, @b : Int32)
      {% for c in %w(r g b) %}
      unless (0..255).includes?(@{{c.id}})
        raise "Invalid color level: {{c.id}} = #{@{{c.id}}}"
      end
      {% end %}
    end

    getter r, g, b

    def to_sdl : SDL::Color
      SDL::Color.new(@r, @g, @b)
    end
  end
end

alias Color = Molly2d::Color
