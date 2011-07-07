module Paint
  # Hash for defining color/effect shortcuts
  # See README for details
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
      eigen_mod = class << mod; self; end # 1.8

      # define direct behaviour, class methods
      # mod.define_singleton_method :method_missing do |color_name, *args|
      eigen_mod.send:define_method, :method_missing do |color_name, *args|
        if color_code = shortcuts[color_name]
          if args.empty? then color_code else color_code + Array(args).join + NOTHING end
        else
          nil
        end
      end

      eigen_mod.send:define_method, :respond_to? do |color_name, *args|
        shortcuts.include?(color_name) || super(color_name, *args)
      end

      # define include behaviour, instance methods
      eigen_mod.send:define_method, :included do |_|
        shortcuts.each{ |color_name, color_code|
          define_method color_name do |*args|
            if args.empty? then color_code else color_code + Array(args).join + NOTHING end
          end
        }
        private(*shortcuts.keys) unless shortcuts.empty?
      end

      # include variations, defined in child modules
      mod.class_eval "module String; end"
      string = mod.const_get(:String)
      eigen_string = class << string; self; end # 1.8
      eigen_string.send:define_method, :included do |_|
        shortcuts.each{ |color_name, color_code|
          define_method color_name do
            color_code + to_s + NOTHING
          end
        }
      end

      # OK, let's take it one level further ;)
      mod.class_eval "module Prefix; end"
      prefix_prefix = mod.const_get(:Prefix)
      eigen_prefix_prefix = class << prefix_prefix; self; end # 1.8
      eigen_prefix_prefix.send:define_method, :const_missing do |prefix_name|
        class_eval "module #{prefix_name}; end"
        prefix = const_get(prefix_name)
        eigen_prefix = class << prefix; self; end # 1.8

        eigen_prefix.send:define_method, :included do |_|
          define_method prefix_name.to_s.gsub(/[A-Z]/,'_\0').downcase[1..-1].to_sym do |color_name|
            shortcuts[color_name] && shortcuts[color_name] + to_s + NOTHING
          end
        end

        prefix
      end

      # :)
      mod
    end
  end
end

# J-_-L
