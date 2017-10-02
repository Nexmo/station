namespace :diff do
  desc 'Build files for comparison'
  task 'execute': :environment do
    puts 'Building base'.colorize(:yellow)
    Rake::Task['diff:build:base'].invoke

    puts 'Updating repos'.colorize(:yellow)
    Rake::Task['repos:pull'].invoke

    puts 'Building comparison'.colorize(:yellow)
    Rake::Task['diff:build:compare'].invoke
    puts 'Comparing'.colorize(:yellow)

    Rake::Task['diff:compare'].invoke
  end

  desc 'Build files for comparison'
  task 'build:base': :environment do
    Diff.generate(mode: 'base')
  end

  desc 'Build files for comparison'
  task 'build:compare': :environment do
    Diff.generate(mode: 'compare')
  end

  desc 'Build files for comparison'
  task 'compare': :environment do
    Diff.diff
  end
end
