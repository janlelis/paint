module Paint
  # Standalone helpers which add functionality you sometimes need when working with terminal colors
  class << self
    # Removes any color and effect strings
    def unpaint(string)
      string.gsub(/\e\[(?:[0-9];?)+m/, '')
    end

    # Creates a random ANSI color
    def random(background = false)
      (background ? 40 : 30) + rand(8)
    end
  end
end
