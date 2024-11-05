module DependencyTimelineAudit
  class GemCache
    attr_reader :versions

    def initialize(gem_info)
      @versions = gem_info || []
    end

    def latest_version
      latest = versions.first # The first entry is the latest version
      version_number = latest['number']
    end

    # Find the version that matches the requested version string
    def version(version_number)
      version_info = versions.find { |v| v['number'] == version_number }
      GemVersionCache.new(version_info)
    end

    def to_h
      versions
    end
  end
end
