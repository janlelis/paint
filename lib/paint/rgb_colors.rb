module Paint
  # A list of color names, based on X11's rgb.txt
  RGB_COLORS =
    Marshal.load(
      Gem::Util.gunzip(
        File.binread(
          File.dirname(__FILE__) + '/../../data/rgb_colors.marshal.gz'
        )
      )
    )
end
