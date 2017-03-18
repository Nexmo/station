namespace :repos do
  desc 'Pull repos to local'
  task :pull => :environment do
    repos = YAML.load_file("#{Rails.root}/config/repos.yml")
    progressbar = ProgressBar.create(total: repos.count)

    repos.each do |repo, reference|
      repo_url = "git@github.com:#{repo}.git"
      system "rm -rf ./.repos/#{repo} 2>&1", out: File::NULL
      system "git clone --depth=1 #{repo_url} -b #{reference} ./.repos/#{repo} 2>&1", out: File::NULL
      system "rm -rf ./.repos/#{repo}/.git 2>&1", out: File::NULL
      progressbar.increment
    end
  end
end
