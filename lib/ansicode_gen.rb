# = ANSICode
#
# Module which makes it very easy to use ANSI codes.
# These are esspecially nice for beautifying shell output.
#
#   include ANSICode
#
#   p red, "Hello", blue, "World"
#   => "\e[31mHello\e[34mWorld"
#
#   p red { "Hello" } + blue { "World" }
#   => "\e[31mHello\e[0m\e[34mWorld\e[0m"
#
# == Supported ANSI Comands
#
# The following is a list of supported codes.
#
#     save
#     restore
#     clear_screen
#     cls             # synonym for :clear_screen
#     clear_line
#     clr             # synonym for :clear_line
#     move
#     up
#     down
#     left
#     right
#     display
#
#     clear
#     reset           # synonym for :clear
#     bold
#     dark
#     italic          # not widely implemented
#     underline
#     underscore      # synonym for :underline
#     blink
#     rapid_blink     # not widely implemented
#     negative        # no reverse because of String#reverse
#     concealed
#     strikethrough   # not widely implemented
#
#     black
#     red
#     green
#     yellow
#     blue
#     magenta
#     cyan
#     white
#
#     on_black
#     on_red
#     on_green
#     on_yellow
#     on_blue
#     on_magenta
#     on_cyan
#     on_white
#
# == Authors
#
# * Florian Frank
# * Thomas Sawyer
#
# == Speical Thanks
#
# Special thanks to Florian Frank. ANSICode is a partial adaptation
# of ANSIColor, Copyright (c) 2002 Florian Frank, LGPL.
#
# == Todo
#
# * Need to add rest of ANSI codes. Include modes?
# * Re-evaluate how color/yielding methods are defined.
# * Maybe up, down, right, left should have yielding methods too?
#
# == Copying
#
# Copyright (c) 2004 Florian Frank, Thomas Sawyer
#
# Ruby License
#
# This module is free software. You may use, modify, and/or redistribute this
# software under the same terms as Ruby.
#
# This program is distributed in the hope that it will be useful, but WITHOUT
# ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
# FOR A PARTICULAR PURPOSE.


# = ANSICode
#
# Module which makes it very easy to use ANSI codes.
# These are esspecially nice for beautifying shell output.
#
#   include ANSICode
#
#   p red, "Hello", blue, "World"
#   => "\e[31mHello\e[34mWorld"
#
#   p red { "Hello" } + blue { "World" }
#   => "\e[31mHello\e[0m\e[34mWorld\e[0m"
#
# == Supported ANSI Comands
#
# The following is a list of supported codes.
#
#     save
#     restore
#     clear_screen
#     cls             # synonym for :clear_screen
#     clear_line
#     clr             # synonym for :clear_line
#     move
#     up
#     down
#     left
#     right
#     display
#
#     clear
#     reset           # synonym for :clear
#     bold
#     dark
#     italic          # not widely implemented
#     underline
#     underscore      # synonym for :underline
#     blink
#     rapid_blink     # not widely implemented
#     negative        # no reverse because of String#reverse
#     concealed
#     strikethrough   # not widely implemented
#
#     black
#     red
#     green
#     yellow
#     blue
#     magenta
#     cyan
#     white
#
#     on_black
#     on_red
#     on_green
#     on_yellow
#     on_blue
#     on_magenta
#     on_cyan
#     on_white
#
module ANSICode

  extend self
  @@file = File.open("/tmp/ansi_code_methods.rb", "w")
  
  # Define color codes.

  def self.define_ansicolor_method(name,code)
    @@file.write <<-HERE
      def #{name.to_s}(string = nil)
          "\e[#{code}m\#{string}\e[0m"
      end
    HERE
  end

  @@colors = [
    [ :reset        ,   0 ],     # synonym for :clear
    [ :bold         ,   1 ],
    [ :italic       ,   3 ],     # not widely implemented
    [ :underscore   ,   4 ],     # synonym for :underline
    [ :negative     ,   7 ],     # no reverse because of String#reverse
    [ :black        ,  30 ],
    [ :red          ,  31 ],
    [ :green        ,  32 ],
    [ :yellow       ,  33 ],
    [ :blue         ,  34 ],
    [ :magenta      ,  35 ],
    [ :cyan         ,  36 ],
    [ :white        ,  37 ],
    [ :on_black     ,  40 ],
    [ :on_red       ,  41 ],
    [ :on_green     ,  42 ],
    [ :on_yellow    ,  43 ],
    [ :on_blue      ,  44 ],
    [ :on_magenta   ,  45 ],
    [ :on_cyan      ,  46 ],
    [ :on_white     ,  47 ],
  ]

  @@colors.each do |c, v|
    define_ansicolor_method(c, v)
  end

end

