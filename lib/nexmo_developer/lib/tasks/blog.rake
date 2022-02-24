namespace :blog do
  desc 'Build index file (JSON)'
  task build_index: :environment do
    now = Time.zone.now

    BlogpostParser.build

    after = Time.zone.now

    puts "\n✨ Done in #{(after - now).round(2)}s ✨\n\n"
  end
end
