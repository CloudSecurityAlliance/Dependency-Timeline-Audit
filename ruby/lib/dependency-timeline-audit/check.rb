require 'date'

module DependencyTimelineAudit
  class Check
    attr_reader :config

    def initialize(config:)
      @config = config
    end

    def check
      outdated_versions = []
      locked_gems.each do |gem|
        outdated_versions.push(gem) if gem.locked_version.outdated?
        gem.print_info if config.verbose
      end

      print "\n" if config.verbose

      if outdated_versions.any?
        TextFormat.color = :red
        puts "Outdated gems detected!"
        puts " - #{outdated_versions.join(', ')}"

        exit(1) # Failure
      else
        puts "All gems are within the accepted threshold!"

        exit(0) # Success
      end
    end

    private

    def locked_gems
      lockfile_parser = Bundler::LockfileParser.new(File.read(config.lockfile))
      lockfile_parser.specs.map do |spec|
        if spec.source.is_a?(Bundler::Source::Git)
          Gem.new(config: config, name: spec.name, locked_version: spec.source.revision)
        else
          Gem.new(config: config, name: spec.name, locked_version: spec.version)
        end
      end
    end
  end
end
