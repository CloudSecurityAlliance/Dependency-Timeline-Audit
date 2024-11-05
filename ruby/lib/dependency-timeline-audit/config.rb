require 'active_support/all'

module DependencyTimelineAudit
  class Config
    attr_reader :verbose, :lockfile, :outdated_threshold

    def initialize(options)
      @verbose = value_or_default(options[:verbose], false)
      @lockfile = value_or_default(options[:lockfile], 'Gemfile.lock')
      @outdated_threshold = value_or_default(options[:outdated_threshold], 3)

      # FIXME: There is probably a better way to handle the guard clauses and type casting
      if @outdated_threshold.to_i <= 0
        raise InvalidOption, "Outdated Threshold must be an integer greater than 0"
      end

      # TODO: activesupport is kinda hefty for just grabbing X.years.ago, remove
      @outdated_threshold = @outdated_threshold.to_i.years.ago
    end

    private

    def value_or_default(value, default)
      !value.nil? ? value : default
    end
  end
end
