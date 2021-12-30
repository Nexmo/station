namespace :blog do
  desc 'Build index file (JSON)'
  task build_index: :environment do
    now = Time.now

    BlogpostParser.build
    
    after = Time.now

    puts "\n✨ Done in #{(after - now).round(2)}s ✨\n\n"
  end
end
