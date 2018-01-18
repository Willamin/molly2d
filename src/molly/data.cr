module Molly2d
  DATA = Molly::Data.new

  module Molly
    class Data
      property should_quit : Bool
      property background : SDL::Color | SDL::Surface
      property window : SDL::Window?
      property renderer : SDL::Renderer?
      property textures : Hash(String, SDL::Texture?)

      def initialize
        @background = SDL::Color.new(210, 210, 200)
        @textures = Hash(String, SDL::Texture?).new
        @should_quit = false
      end
    end

    extend self

    def should_quit
      Molly2d::DATA.should_quit
    end

    def should_quit=(a)
      Molly2d::DATA.should_quit = a
    end

    def background
      Molly2d::DATA.background
    end

    def background=(a)
      Molly2d::DATA.background = a
    end

    def window
      Molly2d::DATA.window.not_nil!
    end

    def window=(a)
      Molly2d::DATA.window = a
    end

    def renderer
      Molly2d::DATA.renderer.not_nil!
    end

    def renderer=(a)
      Molly2d::DATA.renderer = a
    end

    def textures
      Molly2d::DATA.textures
    end

    def textures=(a)
      Molly2d::DATA.textures = a
    end
  end
end
