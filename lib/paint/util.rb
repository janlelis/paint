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

    # Determine supported colors
    # This is just a naive approach, based on some things I could test
    # Please open issues if it does not work correctly for you
    def detect_mode
      if RbConfig::CONFIG['host_os'] =~ /mswin|mingw/ # windows
        if ENV['ANSICON']
          16
        elsif ENV['ConEmuANSI'] == 'ON'
          256
        else
          0
        end
      else
        # case ENV['COLORTERM']
        # when 'gnome-terminal'
        #   256
        # else
          case ENV['TERM']
          when /-256color$/, 'xterm'
            256
          when /-color$/, 'rxvt'
            16
          else # optimistic default
            256
          end
        # end
      end
    end
  end
end

# J-_-L
