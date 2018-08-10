module Molly2d
  module Molly
    extend self

    def handle_event(event)
      case event
      when SDL::Event::Window
        case event.event
        when 14
          Molly.quit
        end
      when SDL::Event::Quit
        Molly.quit
      end
    end

    def quit
      Molly.should_quit = true
    end

    def keyboard_pressed?(key)
      LibSDL.get_keyboard_state(nil)[key.to_i] == 1
    end
  end
end

alias Key = LibSDL::Scancode
