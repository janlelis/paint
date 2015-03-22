require_relative 'shortcuts_version'

require 'paint'

module Paint
  # Hash for defining color/effect shortcuts
  SHORTCUTS = {
    # :example => {                    # would create a Paint::Example constant...
    #   :light_red     => "\e[31;1m",  # with a method .light_red
    # }
  }
  SHORTCUTS.default = {}

  class << self
    # Paint::SomeModule --> Paint::SHORTCUTS[:some_module]
    def const_missing(mod_name)
      # get shortcuts
      shortcuts = SHORTCUTS[mod_name.to_s.gsub(/[A-Z]/,'_\0').downcase[1..-1].to_sym] || []

      # create module
      class_eval "module #{mod_name}; end"
      mod = const_get(mod_name)

      # define direct behaviour, class methods
      mod.define_singleton_method :method_missing do |color_name, *args|
        if color_code = shortcuts[color_name]
          string = Array(args).join
          return string if Paint.mode.zero?

          if args.empty?
            color_code
          else
            color_code + string + NOTHING
          end
        else
          nil
        end
      end

      mod.define_singleton_method :respond_to_missing? do |color_name, *args|
        shortcuts.include?(color_name) || super(color_name, *args)
      end

      # define include behaviour, instance methods
      mod.define_singleton_method :included do |_|
        shortcuts.each{ |color_name, color_code|
          define_method color_name do |*args|
            string = Array(args).join
            return string if Paint.mode.zero?

            if args.empty?
              color_code
            else
              color_code + string + NOTHING
            end
          end
        }
        private(*shortcuts.keys) unless shortcuts.empty?
      end

      # include variations, defined in child modules
      mod.class_eval "module String; end"
      string = mod.const_get(:String)
      string.define_singleton_method :included do |_|
        shortcuts.each{ |color_name, color_code|
          define_method color_name do
            if Paint.mode.zero?
              to_s
            else
              color_code + to_s + NOTHING
            end
          end
        }
      end

      # OK, let's take it one level further ;)
      mod.class_eval "module Prefix; end"
      prefix_prefix = mod.const_get(:Prefix)
      prefix_prefix.define_singleton_method :const_missing do |prefix_name|
        class_eval "module #{prefix_name}; end"
        prefix = const_get(prefix_name)

        prefix.define_singleton_method :included do |_|
          define_method prefix_name.to_s.gsub(/[A-Z]/,'_\0').downcase[1..-1].to_sym do |color_name|
            if color_code = shortcuts[color_name]
              return to_s if Paint.mode.zero?
              color_code + to_s + NOTHING
            end
          end
        end

        prefix
      end

      mod
    end
  end
end
