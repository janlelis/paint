require_relative 'paint/version'
require_relative 'paint/util'


module Paint
  autoload :RGB_COLORS, 'paint/rgb_colors'
  autoload :RGB_COLORS_ANSI, 'paint/rgb_colors_ansi'

  NOTHING = "\033[0m".freeze

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
  }.freeze

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
  }.freeze

  ANSI_COLORS_FOREGROUND = {
    :black   => 30,
    :red     => 31,
    :green   => 32,
    :yellow  => 33,
    :blue    => 34,
    :magenta => 35,
    :cyan    => 36,
    :white   => 37,
    :default => 39,
  }.freeze

  ANSI_COLORS_BACKGROUND = {
    :black   => 40,
    :red     => 41,
    :green   => 42,
    :yellow  => 43,
    :blue    => 44,
    :magenta => 45,
    :cyan    => 46,
    :white   => 47,
    :default => 49,
  }.freeze

  class << self
    # Takes a string and color options and colorizes the string
    # See README.rdoc for details
    def [](string, *options)
      return string.to_s if @mode.zero? || options.empty?
      options = options.first if options.size == 1 && !options.first.respond_to?(:to_ary)
      @cache[options] + string.to_s + NOTHING
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
          if option =~ /^#?(?:[0-9a-f]{3}){1,2}$/i
            mix << hex(option, color_seen)
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
    # * 256    - 256 colors
    # * 16     - only ansi colors and bright effect
    # * 8      - only ansi colors
    # * 0      - no colorization!
    attr_reader :mode
    def mode=(val) @cache.clear; @mode = val end

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
      if @mode == 8 || @mode == 16
        "#{background ? 4 : 3}#{rgb_like_value(red, green, blue, @mode == 16)}"
      else
        "#{background ? 48 : 38}#{rgb_value(red, green, blue)}"
      end
    end

    # Creates 256-compatible color from a html-like color string
    def hex(string, background = false)
      string.tr! '#',''
      color_code = if string.size == 6
        string.each_char.each_slice(2).map{ |hex_color| hex_color.join.to_i(16) }
      else
        string.each_char.map{ |hex_color_half| (hex_color_half*2).to_i(16) }
      end
      rgb(*[*color_code, background])
    end

    # Creates a 256-color from a name found in Paint::RGB_COLORS (based on rgb.txt)
    def rgb_name(color_name, background = false)
      if color_code = RGB_COLORS[color_name]
        rgb(*[*color_code, background])
      end
    end

    # Creates a random ansi color
    def random(background = false)
      (background ? 40 : 30) + rand(8)
    end

    # Creates the specified effect by looking it up in Paint::ANSI_EFFECTS
    def effect(effect_name)
      ANSI_EFFECTS[effect_name]
    end

    # Determine supported colors
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

    # Returns nearest supported 256-color an rgb value, without fore-/background information
    # Inspired by the rainbow gem
    def rgb_value(red, green, blue)
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

    # Returns ansi color matching an rgb value, without fore-/background information
    # See http://mail.python.org/pipermail/python-list/2008-December/1150496.html
    def rgb_like_value(red, green, blue, use_bright = false)
      color_pool =  RGB_COLORS_ANSI.values
      color_pool += RGB_COLORS_ANSI_BRIGHT.values if use_bright

      ansi_color_rgb = color_pool.min_by{ |col| distance([red, green, blue],col) }
      key_method = RUBY_VERSION < "1.9" ? :index : :key
      if ansi_color = RGB_COLORS_ANSI.send(key_method, ansi_color_rgb)
        ANSI_COLORS[ansi_color]
      else
        ansi_color = RGB_COLORS_ANSI_BRIGHT.send(key_method, ansi_color_rgb)
        "#{ANSI_COLORS[ansi_color]};1"
      end
    end

    def distance(rgb1, rgb2)
      rgb1.zip(rgb2).inject(0){ |acc, (cur1, cur2)|
        acc + (cur1 - cur2)**2
      }
    end
  end

  # init instance vars
  @mode  = detect_mode
  @cache = Hash.new{ |h, k| h[k] = color(*k) }
end

# J-_-L
