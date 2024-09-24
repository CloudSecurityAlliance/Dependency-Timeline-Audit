lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'dependency-timeline-audit'

repo_url = 'https://github.com/CloudSecurityAlliance/Dependency-Timeline-Audit'

Gem::Specification.new do |s|
  s.version     = DependencyTimelineAudit.gem_version
  s.platform    = Gem::Platform::RUBY
  s.name        = 'dependency-timeline-audit'
  s.summary     = 'Dependency Timeline Audit Ruby Interface'
  s.description = 'Provides a way to audit your dependencies based on release timeline.'

  s.required_ruby_version = '>= 3.1.0'

  s.license = 'Apache-2.0'

  s.author   = 'Josh Buker'
  s.email    = 'crypto@joshbuker.com'
  s.homepage = "#{repo_url}"

  s.files = Dir['lib/**/*.rb']
  s.require_paths = ['lib']

  s.metadata = {
    'bug_tracker_uri'       => "#{repo_url}/issues",
    # 'changelog_uri'         => "#{repo_url}/releases/tag/v#{version}",
    # 'documentation_uri'     => "#{repo_url}/wiki",
    # 'source_code_uri'       => "#{repo_url}/tree/v#{version}",
    'rubygems_mfa_required' => 'true'
  }
end
