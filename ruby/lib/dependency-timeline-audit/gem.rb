module DependencyTimelineAudit
  class Gem
    attr_reader :name, :locked_version, :latest_version, :config

    def initialize(config:, name:, locked_version:)
      @config = config
      @name = name
      @locked_version = GemVersion.new(gem: self, name: locked_version)
      @latest_version = GemVersion.new(gem: self, name: api.latest_version)
    end

    def to_s
      name.to_s
    end

    def print_info
      puts "Gem: #{TextFormat.bold}#{name}#{TextFormat.reset}"
      TextFormat.color = locked_version.color
      puts "  - Locked to: #{locked_version.name} (Released: #{format_date(locked_version.released_at)})"
      TextFormat.color = latest_version.color
      puts "  - Latest: #{latest_version.name} (Released: #{format_date(latest_version.released_at)})"
      TextFormat.reset!
    end

    private

    def api
      API.fetch_gem_info(name)
    end

    def format_date(date_string)
      date = Date.parse(date_string)
      date.strftime("%Y-%m-%d")
    end
  end
end
