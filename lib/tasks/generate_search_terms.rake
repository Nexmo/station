namespace :search_terms do
  desc "Generate"
  task :generate => :environment do
    SearchTerms.generate
  end
end
