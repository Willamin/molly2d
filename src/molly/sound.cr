require "sdl"
require "sdl/mix"

at_exit { SDL::Mix.quit }
SDL::Mix.open

module Molly2d
  module Molly
    data samples : Hash(String, SDL::Mix::Sample?) { Hash(String, SDL::Mix::Sample?).new }
    data musics : Hash(String, SDL::Mix::Music?) { Hash(String, SDL::Mix::Music?).new }

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

    module Music
      extend self

      def play(path : String)
        case e = File.extname(path)
        when ".wav"
          SDL::Mix.open(LibMix::MusicType::MUS_WAV)
          SDL::Mix::Music.new(path).tap(&.play)
        else
          raise "Unsupported filetype: #{e}"
        end
      end
    end
  end
end
