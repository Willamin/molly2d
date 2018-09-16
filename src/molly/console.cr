class Molly2d::Console
  # Used for handling STDIN/STDOUT

  alias SProc = Proc(String, Nil)

  @commands = Hash(String, SProc).new
  @prompt = "> "

  def listen
    loop do
      print @prompt
      input = STDIN.gets || ""
      found = false

      @commands.each do |command, proc|
        if input.starts_with?(command)
          proc.call(input)
          found = true
          break
        end
      end

      puts "unrecognized input: #{input}" unless found
    end
  end

  def listen_for(command, proc)
    @commands[command] = proc
  end
end

module Molly2d::Molly
  def setup_console
    c = Molly2d::Console.new
    with c yield
    spawn do
      c.listen
    end
  end
end
