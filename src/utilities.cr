require "sdl/ttf"
require "sdl/hint"

SDL::TTF.init
at_exit { SDL::TTF.quit }
SDL.set_hint(SDL::Hint::RENDER_VSYNC, 1)

module Molly2d
  VERSION   = YAML.parse(File.read("shard.yml"))["version"]
  FONT_HELV = SDL::TTF::Font.new("/System/Library/Fonts/Monaco.dfont", 16)

  class Molly
    def draw_text(x, y, text, font = FONT_HELV)
      text.split("\n").each_with_index do |linetext, index|
        unless linetext.size == 0
          surface = font.render_shaded(linetext, @renderer.draw_color, @background)
          @renderer.copy(surface, dstrect: SDL::Rect[x, y + font.line_skip * index, surface.width, surface.height])
        end
      end
    end

    def draw_rect(x, y, w, h, fill = true)
      if fill
        @renderer.fill_rect(x, y, w, h)
      else
        @renderer.draw_rect(x, y, w, h)
      end
    end

    def set_color(color)
      @renderer.draw_color = color
    end

    def handle_event(event)
      case event
      when SDL::Event::Window
        if event.event == 14
          quit
        end
      when SDL::Event::Quit
        quit
      end
    end

    def clear
      @renderer.draw_color = @background
      @renderer.clear
    end

    def render
      @renderer.present
    end

    def quit
      @should_quit = true
    end
  end
end
