require "sdl"
require "sdl/mix"

# SDL::Mix.init(SDL::Mix::Init::FLAC); at_exit { SDL::Mix.quit }
SDL::Mix.open

module Molly2d
  module Molly
    data samples : Hash(String, SDL::Mix::Sample?) { Hash(String, SDL::Mix::Sample?).new }

    def load_sound(path : String)
      if Molly.samples[path]?
        Molly.samples[path]
      else
        Molly.samples[path] = SDL::Mix::Sample.new(path)
      end
    end

    def play_sound(sample)
      sample.try do |sample|
        SDL::Mix::Channel.play(sample)
      end
    end
  end
end
