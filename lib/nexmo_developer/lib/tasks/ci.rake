require_relative '../common_errors'

namespace :ci do
  desc 'Verify all pages to make sure that no exceptions are thrown'
  task verify_pages: :environment do
    puts 'ci/verify_pages - Verify all pages to make sure that no exceptions are thrown'
    document_paths =
      [
        "#{Rails.configuration.docs_base_path}/_documentation/en/**/*.md",
        "#{Rails.configuration.docs_base_path}/_api/**/*.md",
        "#{Rails.configuration.docs_base_path}/_tutorials/**/*.md",
      ]

    document_paths.each do |path|
      Dir.glob(path).each do |filename|
        document = File.read(filename)
        begin
          Nexmo::Markdown::Renderer.new.call(document)
        rescue StandardError => e
          puts "Error whilst processing #{filename}"
          raise e
        end
      end
    end
  end

  desc 'Verify side navigation to make sure every page has valid YAML metadata'
  task verify_navigation: :environment do
    puts 'ci/verify_navigation - Verify side navigation to make sure every page has valid YAML metadata'
    session = ActionDispatch::Integration::Session.new(Rails.application)
    res = session.get '/documentation'

    # Check for migration pending error
    CommonErrors.check_for_migration_error(session.body)

    raise 'Error rendering documentation index page' if res == 500
  end

  desc 'Render all OAS based API references'
  task verify_oas_reference: :environment do
    puts 'ci/verify_oas_reference - Render all OAS based API references'
    session = ActionDispatch::Integration::Session.new(Rails.application)
    OpenApiConstraint.list.each do |name|
      res = session.get "/api/#{name}"

      # Check for migration pending error
      CommonErrors.check_for_migration_error(session.body)

      raise "Error rendering /api/#{name} OAS page" if res == 500
    end
  end

  desc 'Ensure all OAS error URLS resolve'
  task verify_error_urls_resolve: :environment do
    puts 'ci/verify_error_urls_resolve - Ensure all OAS error URLS resolve'
    session = ActionDispatch::Integration::Session.new(Rails.application)
    session.host! 'localhost' unless Rails.env.test?

    errors = []

    OpenApiConstraint.list.each do |name|
      puts " - Checking #{name}"
      definition = OpenApiDefinitionResolver.find(name)

      definition.endpoints.each do |endpoint|
        puts "   -  #{endpoint.method} #{endpoint.path.path}"
        endpoint.responses.each do |response|
          puts "     -  #{response.code}"
          next if response.code[0] == '2' # Successes don't have error messages

          response.formats.each do |format|
            puts "       -  #{format}"
            schema = response.schema(format)

            # Turn everything in to an array to simplify things
            if schema['oneOf']
              properties = schema['oneOf']
            else
              properties = [schema['properties']]
            end

            properties.each do |property|
              #  Workaround for issue when referencing from common errors
              # eg: 10DLC: - $ref: "common/common_errors.yml#/components/responses/DefaultError/content/application~1json/schema"
              next if property.blank?

              type = property['type']

              # Skip if it's an old-style error
              next unless type

              # Grab the example URL
              example = type['example']

              # If it has an example field, and it's a link to NDP
              if example&.starts_with?('https://developer.nexmo.com/api-errors')

                # Extract the error
                error = example.split('#')[1]

                # Remove the production prefix
                path = example.gsub('https://developer.nexmo.com', '')

                # Get the page
                session.get path

                next if path.include?('/subaccounts')

                # Check for migration pending error
                CommonErrors.check_for_migration_error(session.body)

                # Make sure it includes the correct ID
                errors.push({ 'document' => name, 'path' => path }) unless session.response.body.include?("<tr id=\"#{error}\">")
              end
            end
          end
        end
      end
    end

    if errors.length.positive?
      errors = errors.map do |e|
        "#{e['path']} (#{e['document']})"
      end.uniq
      raise "Missing Errors:\n\n#{errors.join("\n")}"
    end
  end

  task check_word_blocklist: :environment do
    puts 'ci/check_word_blocklist - Check that none words in the word blocklist are in use'
    markdown_files =
      [
        "#{Rails.configuration.docs_base_path}/_documentation/en/**/*.md",
        "#{Rails.configuration.docs_base_path}/_api/**/*.md",
        "#{Rails.configuration.docs_base_path}/_tutorials/**/*.md",
        "#{Rails.configuration.docs_base_path}/_partials/*.md",
        "#{Rails.configuration.docs_base_path}/_partials/**/*.md",
        "#{Rails.configuration.docs_base_path}/_modals/**/*.md",
      ]

    block_list = File.read('.disallowed_words').split("\n")

    errors = []
    markdown_files.each do |path|
      Dir.glob(path).each do |filename|
        block_list.each do |word|
          word = word.downcase
          document = File.read(filename).downcase
          if document.include? word
            errors.push("#{word} found in #{filename.gsub("#{Rails.configuration.docs_base_path}/", '')}")
          end
        end
      end
    end

    if errors.length.positive?
      raise "Blocked words found:\n\n#{errors.join("\n")}"
    end
  end

  task check_ruby_version: :environment do
    puts 'ci/check_ruby_version - Check that the current Ruby version is supported'
    # We treat .ruby-version as the canonical source
    ruby_version = File.read('.ruby-version').strip

    # Does our Gemfile match
    gemfile = File.read('Gemfile.lock')
    gemfile_version = gemfile.match(/RUBY VERSION.*ruby (\d+\.\d+\.\d+).*BUNDLED WITH/m)[1].strip

    # How about Docker?
    docker = File.read('../../Dockerfile')
    docker_version = docker.match(/FROM ruby:(\d+\.\d+\.\d+).*/)[1].strip

    errors = []

    errors.push("Gemfile.lock (#{gemfile_version}) does not match .ruby-version (#{ruby_version})") if gemfile_version != ruby_version
    errors.push("Dockerfile (#{docker_version}) does not match .ruby-version (#{ruby_version})") if docker_version != ruby_version

    if errors.length.positive?
      abort("Ruby version mismatch found:\n\n#{errors.join("\n")}")
    end
  end

  task validate_tutorials: :environment do
    p 'Validating tutorials...'
    TutorialList.all.each do |tutorial_list_item|
      # Consider every code language and the case when it is nil
      tutorial_list_item.languages.append(nil).each do |code_language|
        tutorial = Tutorial.load(tutorial_list_item.filename, nil, nil, code_language)

        tasks = tutorial.subtasks
        tasks.map(&:validate!)

        messages = tasks.map(&:errors).map(&:messages).flatten.reject(&:empty?)
        if messages.any?
          p "Errors for: #{tutorial.path}"
          messages.each do |errors|
            errors.each { |_k, v| p "* #{v.join(',')}".indent(4) }
          end
        end
      end
    end
    p 'Done!'
  end

  task all: %i[verify_pages verify_navigation verify_oas_reference verify_error_urls_resolve check_word_blocklist validate_tutorials]
end
