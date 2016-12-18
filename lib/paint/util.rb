module Paint
  # Standalone helpers which add functionality you sometimes need when working with terminal colors
  class << self
    # Removes any color and effect strings
    def unpaint(string)
      string.gsub(/\e\[(?:[0-9];?)+m/, '')
    end
  end
end

# J-_-L
