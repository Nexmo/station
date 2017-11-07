require 'colorize'

namespace :repos do
  desc 'Pull repos to local'
  task pull: :environment do

    ARGV.each { |a| task a.to_sym do ; end }

    repos = {}

    if ARGV[1]
      repos[ARGV[1]] = {
        'branch' => ARGV[2] || 'master',
      }

      if ['git://', 'git@', 'https://'].any? { |protocol| ARGV[1].include?(protocol) }
        repos[ARGV[1]]['repo_url'] = ARGV[1]

        begin
          repos[ARGV[1]]['directory'] = ARGV[1].match(/^(?:(?:git|https):\/\/|git@).+?(?:\/|:)(.+?).git/)[1]
        rescue NoMethodError
          raise "Could not understand URL #{ARGV[1]}"
        end
      else
        repos[ARGV[1]]['github'] = ARGV[1]
      end
    else
      repos = YAML.load_file("#{Rails.root}/config/repos.yml")
    end

    progressbar = ProgressBar.create(total: repos.count)

    warnings = []

    repos.each do |repo, config|
      if config['path']
        if File.directory?("#{Rails.root}/#{config['path']}")
          warnings << "A path has been used for #{repo}. This should be removed or commented out and rake repos:pull run again before committing"
        else
          puts "Path #{config['path']} provided for #{repo} but does not exist. Can not continue.".colorize(:light_red)
          exit 1
        end
      end
    end

    repos.each do |repo, config|
      directory = config['directory'] || repo

      system "rm -rf ./.repos/#{directory} 2>&1"

      if config['path']
        system "ln -s #{Rails.root}/#{config['path']} #{Rails.root}/.repos/#{directory}"
      else
        repo_url = config['github'] ? "git@github.com:#{config['github']}.git" : config['repo_url']
        system "git clone --depth=1 #{repo_url} -b #{config['branch']} ./.repos/#{directory} 2>&1", out: File::NULL
        system "rm -rf ./.repos/#{directory}/.git 2>&1", out: File::NULL
      end

      progressbar.increment
    end

    warnings.each { |warning| puts warning.colorize(:light_yellow) }
  end
end
