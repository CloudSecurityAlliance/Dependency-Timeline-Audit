module DependencyTimelineAudit
  class TextFormat
    class << self
      def color=(color)
        case color
        when :red
          print red
        when :green
          print green
        when :yellow
          print yellow
        else
          raise ArgumentError, "Unknown color: #{color}"
        end
      end

      def style=(style)
        case style
        when :bold
          print bold
        else
          raise ArgumentError, "Unknown style: #{style}"
        end
      end

      def reset!
        print reset
      end

      def reset
        "\e[0m"
      end

      def bold
        "\e[1m"
      end

      def red
        "\e[31m"
      end

      def green
        "\e[32m"
      end

      def yellow
        "\e[33m"
      end
    end
  end
end
