# Ruby Paint [<img src="https://badge.fury.io/rb/paint.svg" />](http://badge.fury.io/rb/paint) [<img src="https://travis-ci.org/janlelis/paint.svg" />](https://travis-ci.org/janlelis/paint)

Paint creates terminal colors and effects for you. It combines the strengths of **term-ansicolor**, **rainbow**, and similar projects into a simple to use, however still flexible terminal colors gem with no core extensions by default.

## Features

* No string extensions (suitable for library development)
* Simple API
* Faster than other terminal color gems ([as of December 2016](https://gist.github.com/janlelis/91413b9295c81ee873dc))
* Supports *true color* or 256 colors (for capable terminals)
* Allows you to set any terminal effects
* `Paint.mode`: Fall-back modes for terminals with less colors, supported modes:
  * 0xFFFFFF (= 16777215) colors (*true color*)
  * 256 colors (palette)
  * 16 colors (only ANSI colors, combined with bright effect)
  * 8 colors (only ANSI colors)
  * 0 colors (no colors / deactivate)

## Paint 2.0 | True Color Support

Starting with **Paint 2.0**, *true color* mode is the new default mode, since most major terminals now support 24bit colors. If it happens to not work in your setup:

- Manually set `Paint.mode = 256` at the beginning of your code
- Please [open a new issue](https://github.com/janlelis/paint/issues/new) so we can figure out how to blacklist the terminal used

## Supported Rubies

* **2.5**, **2.4**, **2.3**, **2.2**

Unsupported, but might still work:

* **2.1**, **2.0**, **1.9**

## Setup

Add to `Gemfile`:

```ruby
gem 'paint'
```

and run `bundle install`.

In Ruby do:

```ruby
require 'paint'
```

## Usage

The only method you need is: `Paint.[]`

The first argument given to `Paint.[]` is the string to colorize (if the object is not a string, `to_s` will be called on it). The other arguments describe how to modify/colorize the string. Let's learn by example:

```ruby
Paint['Ruby', :red]           # Sets ANSI color red
Paint['Ruby', :red, :bright]  # Also applies bright/bold effect
Paint['Ruby', :bright, :red]  # Does the same as above
Paint['Ruby', :red, :bright, :underline] # Effects can often be combined
Paint['Ruby', :red, :blue]    # The second color you define is for background
Paint['Ruby', nil, :blue]     # Pass a nil before a color to ignore foreground and only set background color
Paint['Ruby', [100, 255, 5]]  # You can define RGB colors. Depending on your terminal, this will create
                              # a "true color" or map to 256/16/8 colors.
Paint['Ruby', "gold", "snow"] # Paint supports rgb.txt color names, note that the arguments are strings
                              # (:yellow != "yellow")!
Paint['Ruby', "#123456"]      # HTML like definitions are possible
Paint['Ruby', "fff"]          # Another HTML hex definition
Paint['Ruby', :inverse]       # Swaps fore- and background
Paint['Ruby', :italic, :encircle, :rapid_blink, :overline] # Probably not supported effects
Paint['Ruby']                 # Don't pass any argument and the string will not be changed
```

When you pass multiple colors, the first one is taken as foreground color and the second one defines the background color, every following color will be ignored. To only change the background color, you have to pass a `nil` first. Effects can be passed in any order.

[You can find more examples in the specs.](https://github.com/janlelis/paint/blob/master/spec/paint_spec.rb)

[List of rgb.txt colors.](https://en.wikipedia.org/wiki/X11_color_names#Color_name_chart)

## Windows Support

For ANSI support in Windows OS, you can use [ansicon](https://github.com/adoxa/ansicon) or [ConEmu](http://code.google.com/p/conemu-maximus5/).

## `Paint.mode`

You can choose between five ways to use `Paint.[]` by setting `Paint.mode` to one of the following:

* **0xFFFFFF**: Use 16777215 *true colors*
* **256**:      Use the 256 colors palette
* **16**:       Use the eight ANSI colors (combined with bright effect)
* **8**:        Use the eight ANSI colors
* **0**:        Don't colorize at all

Paint tries to automatically detect the proper value your terminal is capable of, please [open an issue](https://github.com/janlelis/paint/issues/new) if `Paint.detect_mode` yields a wrong value for you.

## More Details About Terminal Colors and Effects

Terminal colors/effects get created by [ANSI escape sequences](http://en.wikipedia.org/wiki/ANSI_escape_code). These are strings that look like this: `\e[X;X;X;X;X]m` where X are integers with some meaning. For example, `0` means *reset*, `31` means *red foreground* and `41` stands for red background. When you tell **Paint** to use one of the eight ANSI base colors as foreground color, it just inserts a number between `30` and `37` into the sequence. The following colors are available:

* `:black`
* `:red`
* `:green`
* `:yellow`
* `:blue`
* `:magenta`
* `:cyan`
* `:white`, `:gray`
* (`:default`)

When combined with the `:bright` (= `:bold`) effect, the color in the terminal emulator often differs a little bit, thus it is possible to represent 16 colors.

Through special sequences it's also possible to set 256-colors, or even 16777215 colors, instead of only the 8 ANSI ones. However, this is not supported by all terminals. Paint automatically translates given RGB colors to a suitable color of the supported color spectrum.

When using the `Paint.[]` method, Paint wraps the given string between the calculated escape sequence and an reset sequence (`"\e[0m"`). You can get the raw escape sequence by using the `Paint.color` method.

### Effects

See [en.wikipedia.org/wiki/ANSI_escape_code](http://en.wikipedia.org/wiki/ANSI_escape_code) for a more detailed discussion:

#### Often supported

    0) :reset, :nothing
    1) :bright, :bold
    4) :underline
    7) :inverse, :negative
    8) :conceal, :hide
    22) :clean
    24) :underline_off
    26) :inverse_off, :positive
    27) :conceal_off, :show, :reveal

#### Not widely supported

    2) :faint
    3) :italic
    5) :blink, :slow_blink
    6) :rapid_blink
    9) :crossed, :crossed_out
    10) :default_font, :font0
    11-19) :font1, :font2, :font3, :font4, :font5, :font6, :font7, :font8, :font9
    20) :fraktur
    21) :bright_off, :bold_off, :double_underline
    23) :italic_off, :fraktur_off
    25) :blink_off
    29) :crossed_off, :crossed_out_off
    51) :frame
    52) :encircle
    53) :overline
    54) :frame_off, :encircle_off
    55) :overline_off

## Substitution & Nesting

From time to time, you might find yourself in a situation where you want to colorize a substring differently from the rest of the string. Paint supports this via a simple templating approach using the `%` method with an array argument. Use the `%{var}` notation within a string, and pass the template variables as a hash:

```ruby
Paint%['Yellow string with a %{blue_text} in it', :yellow,
  blue_text: ["blue text", :blue]
]
# => "\e[33mYellow string with a \e[34mblue text\e[33m in it\e[0m"
```

## Utilities

The `Paint.random` method generates a random ANSI color you can pass into `Paint.[]`:

```ruby
Paint['Ruby', Paint.random]        # Get one of eight random ANSI foreground colors
Paint['Ruby', Paint.random(true)]  # Get one of eight random ANSI background colors
```

Another helper method is `Paint.unpaint`, which removes any ANSI colors:

```ruby
Paint.unpaint( Paint['Ruby', :red, :bright] ).should == 'Ruby'
```

You can get a `p` like alternative for calling `puts Paint.[]`:

```ruby
require 'paint/pa'
pa "Ruby", :red, :underline  # same as puts Paint["Ruby", :red, :underline]
```

## Advanced Usage: Shortcuts

There is an extension gem available which allows you to define custom color definitions, which you can reuse later. See [SHORTCUTS.md](https://github.com/janlelis/paint/blob/master/SHORTCUTS.md) for documentation. This is completely optional.

## J-_-L

Copyright (c) 2011-2016 Jan Lelis <http://janlelis.com>, released under the
MIT license.

Thank you to [rainbow](https://github.com/sickill/rainbow) and [term-ansicolor](https://github.com/flori/term-ansicolor) for ideas and inspiration. Also, a lot of thanks to all the [contributors](https://github.com/janlelis/paint/contributors)!
