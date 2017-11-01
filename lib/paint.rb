require_relative 'paint/version'
require_relative 'paint/constants'
require_relative 'paint/util'

module Paint
  autoload :RGB_COLORS, 'paint/rgb_colors'

  class << self
    # Takes a string and color options and colorizes the string, fast version without nesting
    def [](string, *options)
      return string.to_s if @mode.zero? || options.empty?
      options = options[0] if options.size == 1 && !options[0].respond_to?(:to_ary)
      @cache[options] + string.to_s + NOTHING
    end

    # Takes an array with string and color options and colorizes the string,
    # extended version with nesting and substitution support
    def %(paint_arguments, clear_color = NOTHING)
      string, *options = paint_arguments
      return string.to_s if options.empty?
      substitutions = options.pop if options[-1].is_a?(Hash)
      options = options[0] if options.size == 1 && !options[0].respond_to?(:to_ary)
      current_color = @cache[options]

      # Substitutions & Nesting
      if substitutions
        substitutions.each{ |key, value|
          string.gsub!(
            "%{#{key}}",
            (value.is_a?(Array) ? self.%(value, current_color) : value.to_s)
          )
        }
      end

      # Wrap string (if Paint.mode > 0)
      if @mode.zero?
        string.to_s
      else
        current_color + string.to_s + clear_color
      end
    end

    # Transforms options into the desired color. Used by @cache
    def color(*options)
      return '' if @mode.zero? || options.empty?
      mix = []
      color_seen = false
      colors = ANSI_COLORS_FOREGROUND

      options.each{ |option|
        case option
        when Symbol
          if color = colors[option]
            mix << color
            color_seen = :set
          elsif ANSI_EFFECTS.key?(option)
            mix << effect(option)
          else
            raise ArgumentError, "Unknown color or effect: #{ option }"
          end

        when Array
          if option.size == 3 && option.all?{ |n| n.is_a? Numeric }
            mix << rgb(*[*option, color_seen])
            color_seen = :set
          else
            raise ArgumentError, "Array argument must contain 3 numerals"
          end

        when ::String
          if option =~ /\A#?(?<hex_color>[[:xdigit:]]{3}{1,2})\z/ # 3 or 6 hex chars
            mix << rgb_hex($~[:hex_color], color_seen)
            color_seen = :set
          else
            mix << rgb_name(option, color_seen)
            color_seen = :set
          end

        when Numeric
          integer = option.to_i
          color_seen = :set if (30..49).include?(integer)
          mix << integer

        when nil
          color_seen = :set

        else
          raise ArgumentError, "Invalid argument: #{ option.inspect }"

        end

        if color_seen == :set
          colors = ANSI_COLORS_BACKGROUND
          color_seen = true
        end
      }

      wrap(*mix)
    end

    # This variable influences the color code generation
    # Currently supported values:
    # * 0xFFFFFF  - 24-bit (~16 million) colors, aka truecolor
    # * 256       - 256 colors
    # * 16        - only ansi colors and bright effect
    # * 8         - only ansi colors
    # * 0         - no colorization!
    attr_reader :mode
    def mode=(val)
      @cache.clear

      case val
      when 0, 8, 16, 256, TRUE_COLOR
        @mode = val
      when TrueClass
        @mode = TRUE_COLOR
      when nil
        @mode = 0
      else
        raise ArgumentError, "Cannot set paint mode to value <#{val}>, possible values are: 0xFFFFFF (true), 256, 16, 8, 0 (nil)"
      end
    end

    # Adds ANSI sequence
    def wrap(*ansi_codes)
      "\033[" + ansi_codes*";" + "m"
    end

    # Creates simple ansi color by looking it up on Paint::ANSI_COLORS
    def simple(color_name, background = false)
      (background ? 40 : 30) + ANSI_COLORS[color_name]
    end

    # If not true_color, creates a 256-compatible color from rgb values,
    # otherwise, an exact 24-bit color
    def rgb(red, green, blue, background = false)
      case @mode
      when 8
        "#{background ? 4 : 3}#{rgb_to_ansi(red, green, blue, false)}"
      when 16
        "#{background ? 4 : 3}#{rgb_to_ansi(red, green, blue, true)}"
      when 256
        "#{background ? 48 : 38}#{rgb_to_256(red, green, blue)}"
      when TRUE_COLOR
        "#{background ? 48 : 38}#{rgb_true(red, green, blue)}"
      end
    end

    # Creates RGB color from a HTML-like color definition string
    def rgb_hex(string, background = false)
      case string.size
      when 6
        color_code = string.each_char.each_slice(2).map{ |hex_color| hex_color.join.to_i(16) }
      when 3
        color_code = string.each_char.map{ |hex_color_half| (hex_color_half*2).to_i(16) }
      end
      rgb(*[*color_code, background])
    end

    # Creates a RGB from a name found in Paint::RGB_COLORS (based on rgb.txt)
    def rgb_name(color_name, background = false)
      if color_code = RGB_COLORS[color_name]
        rgb(*[*color_code, background])
      end
    end

    # Creates the specified effect by looking it up in Paint::ANSI_EFFECTS
    def effect(effect_name)
      ANSI_EFFECTS[effect_name]
    end

    # Determine supported colors
    # Note: there's no reliable test for 24-bit color support
    def detect_mode
      if RbConfig::CONFIG['host_os'] =~ /mswin|mingw/ # windows
        if ENV['ANSICON']
          16
        elsif ENV['ConEmuANSI'] == 'ON'
          TRUE_COLOR
        else
          0
        end
      else
        case ENV['TERM']
        when /-256color$/, 'xterm'
          256
        when /-color$/, 'rxvt'
          16
        else # optimistic default
          256
        end
      end
    end

    private

    # Returns 24-bit color value (see https://gist.github.com/XVilka/8346728)
    # in ANSI escape sequnce format, without fore-/background information
    def rgb_true(red, green, blue)
      ";2;#{red};#{green};#{blue}"
    end

    # Returns closest supported 256-color an RGB value, without fore-/background information
    # Inspired by the rainbow gem
    def rgb_to_256(red, green, blue, approx = true)
      return ";2;#{red};#{green};#{blue}" unless approx

      gray_possible = true
      sep = 42.5

      while gray_possible
        if red < sep || green < sep || blue < sep
          gray = red < sep && green < sep && blue < sep
          gray_possible = false
        end
        sep += 42.5
      end

      if gray
        ";5;#{ 232 + ((red.to_f + green.to_f + blue.to_f)/33).round }"
      else # rgb
        ";5;#{ [16, *[red, green, blue].zip([36, 6, 1]).map{ |color, mod|
          (6 * (color.to_f / 256)).to_i * mod
        }].inject(:+) }"
      end
    end

    # Returns best ANSI color matching an RGB value, without fore-/background information
    # See http://mail.python.org/pipermail/python-list/2008-December/1150496.html
    def rgb_to_ansi(red, green, blue, use_bright = false)
      color_pool =  RGB_COLORS_ANSI.values
      color_pool += RGB_COLORS_ANSI_BRIGHT.values if use_bright

      ansi_color_rgb = color_pool.min_by{ |col| rgb_color_distance([red, green, blue],col) }
      if ansi_color = RGB_COLORS_ANSI.key(ansi_color_rgb)
        ANSI_COLORS[ansi_color]
      else
        ansi_color = RGB_COLORS_ANSI_BRIGHT.key(ansi_color_rgb)
        "#{ANSI_COLORS[ansi_color]};1"
      end
    end

    def rgb_color_distance(rgb1, rgb2)
      rgb1.zip(rgb2).inject(0){ |acc, (cur1, cur2)|
        acc + (cur1 - cur2)**2
      }
    end
  end

  # init instance vars
  @mode  = detect_mode
  @cache = Hash.new{ |h, k| h[k] = color(*k) }
end
