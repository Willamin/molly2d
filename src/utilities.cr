require "sdl/ttf"
require "sdl/hint"
require "sdl/image"

SDL.init(SDL::Init::VIDEO)
SDL::TTF.init
SDL::IMG.init(SDL::IMG::Init::PNG)
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

    def draw_sprite(x, y, surface : SDL::Texture, stretch_x = 1, stretch_y = 1, flip_x = false, flip_y = false)
      angle = 0
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
      @renderer.copy(surface, dstrect: SDL::Rect[x, y, surface.width * stretch_x, surface.height * stretch_y], angle: angle, flip: flip)
    end

    def set_color(color : SDL::Color)
      @renderer.draw_color = color
    end

    def set_color(color : Molly2d::Color)
      set_color(SDL::Color.new(color.r, color.g, color.b))
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
      if (b = @background).is_a?(SDL::Color)
        @renderer.draw_color = b
      end
      @renderer.clear
      if (b = @background).is_a?(SDL::Surface)
        @renderer.copy(b, dstrect: SDL::Rect[0, 0, @window.width, @window.height])
      end
    end

    def render
      @renderer.present
    end

    def quit
      @should_quit = true
    end

    def keyboard_pressed?(key)
      state = LibSDL.get_keyboard_state(nil)
      state[key.to_i] == 1
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

alias Key = LibSDL::Scancode
alias Color = Molly2d::Color
