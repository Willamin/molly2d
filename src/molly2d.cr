require "sdl"
require "sdl/ttf"

require "./*"

module Molly2d
  FPS_MAX = 60

  class Molly
    property should_quit
    @should_quit : Bool

    property :background, :window, :renderer
    @background : SDL::Color = SDL::Color.new(210, 210, 200)
    @window : SDL::Window
    @renderer : SDL::Renderer

    def initialize
      at_exit { SDL.quit }
      @window = SDL::Window.new("", 800, 600)
      @window.bordered = true
      @renderer = SDL::Renderer.new(@window)
      @should_quit = false
    end

    def update_game(delta)
      handle_event(SDL::Event.poll)
      update(delta)
    end

    def draw_game
      draw_game { }
    end

    def draw_game
      clear
      draw
      yield
      render
    end
  end

  def self.run
    SDL.init(SDL::Init::VIDEO)

    m = Molly.new
    m.load

    white = SDL::Color[255, 255, 255, 255]
    red = SDL::Color[255, 0, 0, 255]

    last_loop = Time.monotonic

    loop do |i|
      now = Time.monotonic
      delta = now - last_loop
      last_loop = now

      m.update_game(delta.total_seconds)

      text_to_draw = <<-TEXT
        now: #{now}
        delta.total_seconds: #{delta.total_seconds}
        TEXT

      m.draw_game do
        m.renderer.draw_color = red
        m.draw_text(20, m.window.height - (text_to_draw.lines.size * 20 + 20), text_to_draw)
      end

      break if m.should_quit
    end
  end
end

alias Molly = Molly2d::Molly
