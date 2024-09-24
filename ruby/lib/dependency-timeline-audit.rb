module DependencyTimelineAudit
  autoload :Check, 'dependency-timeline-audit/check'
  autoload :GemInfo, 'dependency-timeline-audit/gem_info'
  autoload :VERSION, 'dependency-timeline-audit/version'

  def self.gem_version
    Gem::Version.new VERSION::STRING
  end
end
