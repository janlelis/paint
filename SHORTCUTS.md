# Paint::SHORTCUTS

## Setup
Add to Gemfile:

    gem 'paint-shortcuts'

and run `bundle install`

In Ruby do:

    require 'paint/shortcuts'

## Description
Now for the fancy part: You can create color shortcuts for your gems and
scripts! Note: You don't have to use this feature (and only stick to
`Paint.[]` instead) ;)

It's easy: Just setup a hash of symbol keys and escape string values at:
`Paint::SHORTCUTS[:your_namespace]`. They are stored directly as escape
sequences for performance reasons (this also means, you need different
namespaces for different `Paint.mode`s). Example:

    Paint::SHORTCUTS[:example] = {
      :white => Paint.color(:black),
      :red => Paint.color(:red, :bright),
      :title => Paint.color(:underline),
    }

The methods become "rubymagically" available in a `Paint` child model:

    Paint::Example.red 'Ruby' # => "\e[31;1mRuby\e[0m"
    Paint::Example.white      # => "\e[37m"

As you can see, the helper methods look useful and can take either one (wrap
string) or none (only color) arguments ...but they aren't really *short* yet.

Fortunately, you can include them:

    include Paint::Example
    red # => "\e[31;1m"
    white 'Ruby' # => "\e[30m"

All shortcuts, defined in your shortcut namespace at this time, are now
(privately) available in your current namespace (without using a
method_missing implementation).

Furthermore, there are two variations of this approach:

    include Paint::Example::String
    "Ruby".title # => "\e[4mRuby\e[0m"
    5.red # => "\e[31;1m5\e[0m"

In this case, `self` will be converted to a string and wrapped with the
specific color code. Note, that the helper methods doesn't take any arguments
when using this inclusion method.

The third way allows you to get a single color helper method to avoid
cluttering namespaces:

    include Paint::Example::Prefix::ExampleName
    "Ruby".example_name(:red) # => "\e[31;1mRuby\e[0m"

