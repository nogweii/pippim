module ANSICode
  extend self
      def reset(string = nil)
          "[0m#{string}[0m"
      end
      def bold(string = nil)
          "[1m#{string}[0m"
      end
      def italic(string = nil)
          "[3m#{string}[0m"
      end
      def underscore(string = nil)
          "[4m#{string}[0m"
      end
      def negative(string = nil)
          "[7m#{string}[0m"
      end
      def black(string = nil)
          "[30m#{string}[0m"
      end
      def red(string = nil)
          "[31m#{string}[0m"
      end
      def green(string = nil)
          "[32m#{string}[0m"
      end
      def yellow(string = nil)
          "[33m#{string}[0m"
      end
      def blue(string = nil)
          "[34m#{string}[0m"
      end
      def magenta(string = nil)
          "[35m#{string}[0m"
      end
      def cyan(string = nil)
          "[36m#{string}[0m"
      end
      def white(string = nil)
          "[37m#{string}[0m"
      end
      def on_black(string = nil)
          "[40m#{string}[0m"
      end
      def on_red(string = nil)
          "[41m#{string}[0m"
      end
      def on_green(string = nil)
          "[42m#{string}[0m"
      end
      def on_yellow(string = nil)
          "[43m#{string}[0m"
      end
      def on_blue(string = nil)
          "[44m#{string}[0m"
      end
      def on_magenta(string = nil)
          "[45m#{string}[0m"
      end
      def on_cyan(string = nil)
          "[46m#{string}[0m"
      end
      def on_white(string = nil)
          "[47m#{string}[0m"
      end
end
