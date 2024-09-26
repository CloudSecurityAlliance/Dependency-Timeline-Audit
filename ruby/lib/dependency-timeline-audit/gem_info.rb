require 'net/http'
require 'json'

module DependencyTimelineAudit
  # Define a class for interacting with the RubyGems API
  class GemInfo
    API_URL = 'https://rubygems.org/api/v1/versions/'
    @@gem_cache = {}

    # Method to fetch the gem data and cache it
    def self.fetch_gem_data(gem_name)
      # Check if gem info is already cached
      unless @@gem_cache[gem_name]
        url = URI("#{API_URL}#{gem_name}.json")
        response = Net::HTTP.get(url)
        @@gem_cache[gem_name] = JSON.parse(response)
      end

      # Return cached gem info
      @@gem_cache[gem_name]
    end

    # Method to fetch the latest version and its created_at timestamp
    def self.latest_version(gem_name)
      versions = fetch_gem_data(gem_name)
      latest = versions.first # The first entry is the latest version
      version_number = latest['number']
      created_at = latest['created_at']
      { version: version_number, created_at: created_at }
    end

    # Method to fetch the created_at timestamp for a specific version
    def self.version_created_at(gem_name, version)
      versions = fetch_gem_data(gem_name)
      # Find the version that matches the requested version string
      version_info = versions.find { |v| v['number'] == version }

      version_info.present? ? version_info['created_at'] : nil
    end
  end
end
