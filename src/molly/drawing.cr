require "sdl/image"
require "sdl/ttf"
require "sdl/hint"

module Molly2d
  module Molly
    FONT = SDL::TTF::Font.new("/System/Library/Fonts/Monaco.dfont", 16)

    def load_sprite(path : String)
      if Molly.textures[path]?
        Molly.textures[path]
      else
        Molly.textures[path] = SDL::IMG.load(path, Molly.renderer)
      end
    end

    def draw_text(x, y, text, font = FONT)
      text.split("\n").each_with_index do |linetext, index|
        unless linetext.size == 0
          surface = font.render_blended(linetext, Molly.renderer.draw_color, Molly.background)
          Molly.renderer.copy(surface, dstrect: SDL::Rect[x, y + font.line_skip * index, surface.width, surface.height])
        end
      end
    end

    def draw_rect(x, y, w, h, fill = true)
      if fill
        Molly.renderer.fill_rect(x, y, w, h)
      else
        Molly.renderer.draw_rect(x, y, w, h)
      end
    end

    def draw_sprite(x, y, surface : SDL::Texture?, stretch_x = 1, stretch_y = 1, flip_x = false, flip_y = false, angle = 0)
      if surface.nil?
        return
      end

      flip = LibSDL::RendererFlip::NONE
      if flip_x && flip_y
        flip = LibSDL::RendererFlip::NONE
        angle = 180
      else
        if flip_x
          flip = LibSDL::RendererFlip::HORIZONTAL
        end
        if flip_y
          flip = LibSDL::RendererFlip::VERTICAL
        end
      end
      Molly.renderer.copy(surface, dstrect: SDL::Rect[x, y, surface.width * stretch_x, surface.height * stretch_y], angle: angle, flip: flip)
    end

    def clear
      if (b = Molly.background).is_a?(SDL::Color)
        Molly.renderer.draw_color = b
      end
      Molly.renderer.clear
      if (b = Molly.background).is_a?(SDL::Surface)
        Molly.renderer.copy(b, dstrect: SDL::Rect[0, 0, Molly.window.width, Molly.window.height])
      end
    end

    def render
      Molly.renderer.present
    end

    def set_color(color : SDL::Color)
      Molly.renderer.draw_color = color
    end

    def set_color(color : Molly2d::Color)
      Molly.set_color(SDL::Color.new(color.r, color.g, color.b))
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
  end
end

alias Color = Molly2d::Color
