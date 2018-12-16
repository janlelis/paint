require "zlib"

module Paint
  RGB_COLORS_INDEX_FILENAME = File.dirname(__FILE__) + "/../../data/rgb_colors.marshal.gz"
  # A list of color names, based on X11's rgb.txt

  File.open(RGB_COLORS_INDEX_FILENAME, "rb") do |file|
    serialized_data = Zlib::GzipReader.new(file).read
    serialized_data.force_encoding Encoding::BINARY
    RGB_COLORS = Marshal.load(serialized_data)
  end
end
