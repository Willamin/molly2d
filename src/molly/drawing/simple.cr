require "sdl/image"
require "sdl/ttf"
require "sdl/hint"

module Molly2d
  module Molly
    FONT = SDL::TTF::Font.new("/System/Library/Fonts/Monaco.dfont", 16)

    def draw_rect(x, y, w, h, fill = true)
      if fill
        Molly.renderer.fill_rect(x, y, w, h)
      else
        Molly.renderer.draw_rect(x, y, w, h)
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
  end
end
