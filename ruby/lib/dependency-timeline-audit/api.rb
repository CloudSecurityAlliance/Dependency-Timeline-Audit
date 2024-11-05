require 'net/http'
require 'json'

module DependencyTimelineAudit
  class API
    API_URL = 'https://rubygems.org/api/v1/versions/'
    CACHE_DIRECTORY = "#{Dir.pwd}/.dependency-timeline-audit/cache/ruby/"
    EXCEPTIONS_DIRECTORY = "#{Dir.pwd}/.dependency-timeline-audit/exceptions/ruby/"
    @@gem_cache = {}

    def self.fetch_gem_info(gem_name)
      if !cached?(gem_name) || cache_outdated?(gem_name)
        update_cache(gem_name)
      end

      gem_cache(gem_name)
    end

    def self.cached?(gem_name)
      File.exist?(gem_cache_file(gem_name))
    end

    # TODO: Implement cache_outdated? method using config.cache_expires_after
    def self.cache_outdated?(gem_name)
      false
    end

    def self.gem_cache_file(gem_name)
      File.join(CACHE_DIRECTORY, "#{gem_name}.json")
    end

    def self.update_cache(gem_name)
      response = rubygems_api_response(gem_name)
      gem_cache = GemCache.new(JSON.parse(response))

      FileUtils.mkdir_p(CACHE_DIRECTORY) unless File.directory?(CACHE_DIRECTORY)
      File.open(gem_cache_file(gem_name), 'w') do |file|
        file.write(JSON.pretty_generate(gem_cache.to_h))
      end

      gem_cache(gem_name)
    end

    def self.rubygems_api_response(gem_name)
      url = URI("#{API_URL}#{gem_name}.json")
      Net::HTTP.get(url)
    end

    def self.gem_cache(gem_name)
      if @@gem_cache[gem_name].nil? && cached?(gem_name)
        @@gem_cache[gem_name] = GemCache.new(JSON.parse(File.read(gem_cache_file(gem_name))))
      end

      @@gem_cache[gem_name]
    end
  end
end
