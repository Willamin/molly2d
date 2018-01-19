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

        @window = SDL::Window.new("", 800, 600)
        @renderer = SDL::Renderer.new(@window)
      end
    end

    extend self

    macro data(*names, &block)
      {% for name in names %}
        {% if name.is_a?(TypeDeclaration) %}
          class Data
            {% if block %}
              property {{name.var.id}} : {{name.type}} = {{yield}}
            {% else %}
              property {{name.var.id}} : {{name.type}}
            {% end %}
          end

          def {{name.var.id}}
            Molly2d::DATA.{{name.var.id}}
          end

          def {{name.var.id}}=(a)
            Molly2d::DATA.{{name.var.id}} = a
          end

        {% elsif name.is_a?(Assign) %}
          class Data
            property {{name.target.id}} = {{name.value}}
          end

          def {{name.target.id}}
            Molly2d::DATA.{{name.target.id}}
          end

          def {{name.target.id}}=(a)
            Molly2d::DATA.{{name.target.id}} = a
          end

        {% end %}
      {% end %}
    end

    data should_quit : Bool { false }
    data background : Color | SDL::Surface { Color.new(210, 210, 200) }
    data textures : Hash(String, SDL::Texture?) { Hash(String, SDL::Texture?).new }
    data window : SDL::Window
    data renderer : SDL::Renderer
  end
end
