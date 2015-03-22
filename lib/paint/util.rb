require 'rbconfig'

module Paint
  # These helpers add functionality you sometimes need when working with terminal colors
  class << self
    # Removes any color and effect strings
    def unpaint(string)
      string.gsub(/\e\[(?:[0-9];?)+m/, '')
    end

    # Tries to print all 256 colors
    def rainbow
      (0...256).each{ |color|
        print Paint[' ', 48, 5, color] # print empty bg color field
      }
      puts
    end

    # Updates color names
    def update_rgb_colors(path = '/etc/X11/rgb.txt')
      if File.file?(path)
        Paint::RGB_COLORS.clear

        File.open(path, 'r') do |file|
          file.each_line{ |line|
            line.chomp =~ /(\d+)\s+(\d+)\s+(\d+)\s+(.*)$/
            Paint::RGB_COLORS[$4] = [$1.to_i, $2.to_i, $3.to_i] if $4
          }
        end
      else
        raise ArgumentError, "Not a valid file: #{path}"
      end
    end

  end
end

# J-_-L
