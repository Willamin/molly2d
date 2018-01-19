module Molly2d
  DATA = Molly::Data.new

  module Molly
    class Data
      def initialize
        SDL.init(SDL::Init::VIDEO)
        SDL::IMG.init(SDL::IMG::Init::PNG)
        SDL::TTF.init
        at_exit { SDL.quit }

        SDL.set_hint(SDL::Hint::RENDER_VSYNC, 1)

        @background = SDL::Color.new(210, 210, 200)
        @textures = Hash(String, SDL::Texture?).new
        @should_quit = false
        @window = SDL::Window.new("", 800, 600)
        @renderer = SDL::Renderer.new(@window)
      end
    end

    extend self

    macro data(*names)
      {% for name in names %}
      class Data
        property {{name.var.id}} : {{name.type}}
      end

      def {{name.var.id}}
        Molly2d::DATA.{{name.var.id}}
      end

      def {{name.var.id}}=(a)
        Molly2d::DATA.{{name.var.id}} = a
      end
      {% end %}
    end

    data should_quit : Bool
    data background : SDL::Color | SDL::Surface
    data textures : Hash(String, SDL::Texture?)
    data window : SDL::Window
    data renderer : SDL::Renderer
  end
end
