module DependencyTimelineAudit
  class GemVersion
    attr_reader :gem, :config, :name

    def initialize(gem:, name:)
      @gem = gem
      @config = gem.config
      @name = name.to_s
    end

    def ==(other)
      return name == other.name if other.is_a?(GemVersion)

      nil
    end

    def to_s
      name.to_s
    end

    # If release date is unknown, leave it as not outdated
    def outdated?
      return false if released_at.nil?
      released_at <= config.outdated_threshold
    end

    def latest?
      gem.latest_version == self
    end

    def color
      return :red if outdated?
      return :green if latest?
      :yellow
    end

    def released_at
      api.released_at
    end

    private

    def api
      API.fetch_gem_info(gem.name).version(name)
    end
  end
end
