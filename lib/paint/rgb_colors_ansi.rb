module Paint
  # A list of color names for standard ansi colors, needed for 16/8 color fallback mode
  # See http://en.wikipedia.org/wiki/ANSI_escape_code#Colors
  RGB_COLORS_ANSI = {
    :black   => [0,0,0],
    :red     => [205,0,0],
    :green   => [0,205,0],
    :yellow  => [205,205,0],
    :blue    => [0,0,238],
    :magenta => [205,0,205],
    :cyan    => [0,205,205],
    :white   => [229,229,229],
  }.each { |k, v| v.freeze }.freeze

  # A list of color names for standard bright ansi colors, needed for 16 color fallback mode
  # See http://en.wikipedia.org/wiki/ANSI_escape_code#Colors
  RGB_COLORS_ANSI_BRIGHT = {
    :black   => [127,127,127],
    :red     => [255,0,0],
    :green   => [0,255,0],
    :yellow  => [255,255,0],
    :blue    => [92,92,255],
    :magenta => [255,0,255],
    :cyan    => [0,255,255],
    :white   => [255,255,255],
  }.each { |k, v| v.freeze }.freeze
end
