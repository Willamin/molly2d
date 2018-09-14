require "sdl"
require "sdl/ttf"

require "./molly/*"
require "./molly/drawing/*"
require "./overrides"

module Molly2d
  FPS_MAX  = 60
  MAX_TIME = Time::Span.new(nanoseconds: (1.0/FPS_MAX * 1_000_000_000).to_i)

  module Molly
    extend self

    def run
      Molly.window.bordered = true
      Molly.load

      last_loop = Time.monotonic
      loop do
        now = Time.monotonic
        delta = now - last_loop

        if delta < MAX_TIME
          sleep(MAX_TIME - delta)
        end
        last_loop = now

        Molly.update_game(delta.total_seconds)

        Molly.draw_game

        break if Molly.should_quit
      end
    end

    def update_game(delta)
      Molly.handle_event(SDL::Event.poll)
      Molly.update(delta)
    end

    def draw_game
      Molly.clear
      Molly.draw
      Molly.render
    end
  end
end

alias Molly = Molly2d::Molly
Molly.run
