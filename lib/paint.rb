require 'paint/version'
require 'paint/shortcuts'
require 'paint/util'

module Paint
  autoload :RGB_COLORS, 'paint/rgb_colors'

  # Important purpose
  NOTHING = "\033[0m"

  # Basic colors (often, the color differs when using the bright effect)
  # Final color will be 30 + value for foreground and 40 + value for background
  ANSI_COLORS = {
    :black   => 0,
    :red     => 1,
    :green   => 2,
    :yellow  => 3,
    :blue    => 4,
    :magenta => 5,
    :cyan    => 6,
    :white   => 7,
    :default => 9,
  }

  # Terminal effects - most of them are not supported ;)
  # See http://en.wikipedia.org/wiki/ANSI_escape_code
  ANSI_EFFECTS = {
    :reset         => 0,  :nothing         => 0,  # usually supported
    :bright        => 1,  :bold            => 1,  # usually supported
    :faint         => 2,
    :italic        => 3,
    :underline     => 4,                          # usually supported
    :blink         => 5,  :slow_blink      => 5,
    :rapid_blink   => 6,
    :inverse       => 7,  :swap            => 7,  # usually supported
    :conceal       => 8,  :hide            => 9,
    :default_font  => 10,
    :font0 => 10, :font1 => 11, :font2 => 12, :font3 => 13, :font4 => 14,
    :font5 => 15, :font6 => 16, :font7 => 17, :font8 => 18, :font9 => 19,
    :fraktur       => 20,
    :bright_off    => 21, :bold_off        => 21, :double_underline => 21,
    :clean         => 22,
    :italic_off    => 23, :fraktur_off     => 23,
    :underline_off => 24,
    :blink_off     => 25,
    :inverse_off   => 26, :positive        => 26,
    :conceal_off   => 27, :show            => 27, :reveal           => 27,
    :crossed_off   => 29, :crossed_out_off => 29,
    :frame         => 51,
    :encircle      => 52,
    :overline      => 53,
    :frame_off     => 54, :encircle_off    => 54,
    :overline_off  => 55,
  }

  class << self
    # Takes a string and color options and colorizes the string
    # See README.rdoc for details
    def [](string, *args)
      color(*args) + string.to_s + NOTHING
    end

    # Sometimes, you only need the color
    # Used by []
    def color(*options)
      mix = []
      color_seen = false

      if options.empty?
        mix << random(false) # random foreground color
      else
        options.each{ |option|
          case option
          when Symbol
            if ANSI_EFFECTS.keys.include?(option)
              mix << effect(option)
            elsif ANSI_COLORS.keys.include?(option)
              mix  << simple(option, color_seen)
              color_seen = true
            else
              raise ArgumentError, "Unknown color or effect: #{ option }"
            end

          when Array
            if option.size == 3 && option.all?{ |n| n.is_a? Numeric }
              mix << rgb(*(option + [color_seen])) # 1.8 workaround
              color_seen = true
            else
              raise ArgumentError, "Array argument must contain 3 numerals"
            end

          when ::String
            if option =~ /^#?(?:[0-9a-f]{3}){1,2}$/
              mix << hex(option, color_seen)
              color_seen = true
            else
              mix << name(option, color_seen)
              color_seen = true
            end

          when Numeric
            integer = option.to_i
            color_seen = true if (30..49).include?(integer)
            mix << integer

          when nil
            color_seen = true
          
          else
            raise ArgumentError, "Invalid argument: #{ option.inspect }"

          end
        }
      end

      wrap(*mix)
    end

    # Adds ansi sequence
    def wrap(*ansi_codes)
      "\033[" + ansi_codes*";" + "m"
    end

    # Creates simple ansi color by looking it up on Paint::ANSI_COLORS
    def simple(color_name, background = false)
      (background ? 40 : 30) + ANSI_COLORS[color_name]
    end

    # Creates a 256-compatible color from rgb values
    def rgb(red, green, blue, background = false)
      "#{background ? 48 : 38};5;#{rgb_value(red, green, blue)}"
    end

    # Creates 256-compatible color from a html-like color string
    def hex(string, background = false)
      string.tr! '#',''
      rgb(
       *(if string.size == 6
          # string.chars.each_cons(2).map{ |hex_color| hex_color.join.to_i(16) }
          [string[0,2].to_i(16), string[2,2].to_i(16), string[4,2].to_i(16)]
        else
          string.chars.map{ |hex_color_half| (hex_color_half*2).to_i(16) }
        end + [background]) # 1.8 workaround
      )
    end

    # Creates a 256-color from a name found in Paint::RGB_COLORS (based on rgb.txt)
    def name(color_name, background = false)
      if color_code = RGB_COLORS[color_name]
        "#{background ? 48 : 38};5;#{color_code}"
      end
    end

    # Creates a random ansi color
    def random(background = false)
      (background ? 40 : 30) + rand(8)
    end

    # Creates the specified effect by looking it up in Paint::ANSI_COLORS
    def effect(effect_name)
      ANSI_EFFECTS[effect_name]
    end

    private
 
    # Gets nearest supported color, heavily inspired by the rainbow gem
    def rgb_value(red, green, blue)
      [16, *[red, green, blue].zip([36, 6, 1]).map{ |color, mod|
        (6 * (color.to_f / 256)).to_i * mod
      }].inject(:+) 
    end
  end
end

# J-_-L
