require 'paint'

module Kernel
  private

  # A helper method similar to puts for printing a String on STDOUT
  # Passes all arguments to Paint.[]
  def pa(*args)
    puts Paint[*args]
  end
end
