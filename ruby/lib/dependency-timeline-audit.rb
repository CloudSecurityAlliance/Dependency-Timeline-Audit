module DependencyTimelineAudit
  autoload :API,             'dependency-timeline-audit/api'
  autoload :Check,           'dependency-timeline-audit/check'
  autoload :Config,          'dependency-timeline-audit/config'
  autoload :GemCache,        'dependency-timeline-audit/gem_cache'
  autoload :GemVersionCache, 'dependency-timeline-audit/gem_version_cache'
  autoload :GemVersion,      'dependency-timeline-audit/gem_version'
  autoload :Gem,             'dependency-timeline-audit/gem'
  autoload :TextFormat,      'dependency-timeline-audit/text_format'
  autoload :VERSION,         'dependency-timeline-audit/version'

  def self.gem_version
    ::Gem::Version.new VERSION::STRING
  end
end
