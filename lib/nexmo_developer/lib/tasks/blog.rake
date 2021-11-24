namespace :blog do
  desc "Build index file (JSON)"
  task build_index: :environment do
    BlogpostParser.build
  end
end
  