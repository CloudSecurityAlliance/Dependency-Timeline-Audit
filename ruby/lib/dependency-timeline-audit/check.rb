require 'date'
require 'active_support/all'

module DependencyTimelineAudit
  class Check
    # TODO: activesupport is kinda hefty for just grabbing 1.year.ago, remove
    def self.outdated_threshold
      1.year.ago
    end

    def self.check(lockfile: 'Gemfile.lock', verbose: true)
      outdated_versions = []
      locked_gems.each do |gem|
        lock_released_at = GemInfo.version_created_at(gem[:name], gem[:locked_version])
        latest_version = GemInfo.latest_version(gem[:name])
        outdated_versions.push(gem[:name]) if gem_outdated?(lock_released_at)
        print_info(gem, lock_released_at, latest_version) if verbose
      end

      print "\n" if verbose

      if outdated_versions.any?
        set_text_color_red
        puts "Outdated gems detected!"
        puts " - #{outdated_versions.join(', ')}"

        exit(1) # Failure
      else
        reset_text_style
        puts "All gems are within the accepted threshold!"

        exit(0) # Success
      end
    end

    private

    def self.gem_outdated?(released_at)
      released_at <= outdated_threshold
    end

    def self.print_info(gem, lock_released_at, latest_version)
      puts "Gem: \e[1m#{gem[:name]}\e[0m"
      set_text_color(lock_released_at, gem[:locked_version] == latest_version[:version])
      puts "  - Locked to: #{gem[:locked_version]} (Released: #{format_date(lock_released_at)})"
      set_text_color(latest_version[:created_at])
      puts "  - Latest: #{latest_version[:version]} (Released: #{format_date(latest_version[:created_at])})"
      reset_text_style
    end

    def self.set_text_color(released_at, using_latest = true)
      if gem_outdated?(released_at)
        set_text_color_red
      else
        if using_latest
          set_text_color_green
        else
          set_text_color_yellow
        end
      end
    end

    def self.set_text_bold
      print "\e[1m"
    end

    def self.set_text_color_red
      print "\e[31m"
    end

    def self.set_text_color_green
      print "\e[32m"
    end

    def self.set_text_color_yellow
      print "\e[33m"
    end

    def self.reset_text_style
      print "\e[0m"
    end

    def self.locked_gems
      lockfile = Bundler::LockfileParser.new(File.read('Gemfile.lock'))
      lockfile.specs.map do |gem|
        { name: gem.name, locked_version: gem.version.to_s }
      end
    end

    def self.format_date(date_string)
      date = Date.parse(date_string)
      date.strftime("%Y-%m-%d")
    end
  end
end
