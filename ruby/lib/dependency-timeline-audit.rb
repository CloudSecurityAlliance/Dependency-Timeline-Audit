module DependencyTimelineAudit
  autoload :VERSION, 'dependency-timeline-audit/version'

  def self.gem_version
    Gem::Version.new VERSION::STRING
  end
end
