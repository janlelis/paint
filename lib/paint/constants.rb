module Paint
  # Clears all colors
  NOTHING = "\033[0m".freeze

  # Number of possible colors in TRUE COLOR mode
  TRUE_COLOR = 0xFFFFFF

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
    :white   => 7, :gray => 7,
    :default => 9,
  }.freeze

  ANSI_COLORS_FOREGROUND = {
    :black   => 30,
    :red     => 31,
    :green   => 32,
    :yellow  => 33,
    :blue    => 34,
    :magenta => 35,
    :cyan    => 36,
    :white   => 37, :gray => 37,
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
    :white   => 47, :gray => 47,
    :default => 49,
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

  # A list of color names for standard ansi colors, needed for 16/8 color fallback mode
  # See http://en.wikipedia.org/wiki/ANSI_escape_code#Colors
  RGB_COLORS_ANSI = {
    :black   => [  0,   0,   0],
    :red     => [205,   0,   0],
    :green   => [  0, 205,   0],
    :yellow  => [205, 205,   0],
    :blue    => [  0,   0, 238],
    :magenta => [205,   0, 205],
    :cyan    => [  0, 205, 205],
    :white   => [229, 229, 229], :gray => [229, 229, 229],
  }.each { |k, v| v.freeze }.freeze

  # A list of color names for standard bright ansi colors, needed for 16 color fallback mode
  # See http://en.wikipedia.org/wiki/ANSI_escape_code#Colors
  RGB_COLORS_ANSI_BRIGHT = {
    :black   => [127, 127, 127],
    :red     => [255,   0,   0],
    :green   => [  0, 255,   0],
    :yellow  => [255, 255,   0],
    :blue    => [ 92,  92, 255],
    :magenta => [255,   0, 255],
    :cyan    => [  0, 255, 255],
    :white   => [255, 255, 255], :gray => [255, 255, 255],
  }.each { |k, v| v.freeze }.freeze
end
