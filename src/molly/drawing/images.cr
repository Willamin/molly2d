require "sdl/image"
require "sdl/ttf"
require "sdl/hint"

module Molly2d
  module Molly
    data textures : Hash(String, SDL::Texture?) { Hash(String, SDL::Texture?).new }

    def load_sprite(path : String)
      if Molly.textures[path]?
        Molly.textures[path]
      else
        Molly.textures[path] = SDL::IMG.load(path, Molly.renderer)
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
  end
end
