module DependencyTimelineAudit
  class GemVersionCache
    def initialize(version_info)
      @version_info = version_info || {}
    end

    def released_at
      @version_info['created_at']
    end
  end
end
