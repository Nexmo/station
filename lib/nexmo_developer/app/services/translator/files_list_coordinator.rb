module Translator
  class FilesListCoordinator
    def self.call(attrs = {})
      new(attrs).call
    end

    def initialize(days:)
      @days = days
    end

    def call
      # create list of files since days through git log
      # filter list for only allowed GA products
      # -> documentation by folder path
      # -> use_cases through product key in document frontmatter
      # -> tutorials through reading the tutorial config
      files

      process_files(files)
    end

    def files
      @files ||= `git log --since="#{@days}".days --name-only --oneline --diff-filter=AMR --pretty=format: master _documentation/en _tutorials/en _use_cases/en | uniq | awk 'NF'`.split('/n')
    end

    def process_files(files)
      files.each do |f|
        if f.include?('_documentation')
          process_doc_file(f)
        elsif f.include?('_use_cases')
          process_use_case_file(f)
        elsif f.include?('_tutorials')
          process_tutorial_file(f)
        else
          raise ArgumentError, "The following file did not match documentation, use cases or tutorials: #{f}"
        end
      end
    end

    def process_doc_file(file)
      allowed_products.each do |product|
        return file if file.include?(product)
      end

      ''
    end

    def process_use_case_file(file)
      allowed_products.each do |product|
        return file if use_case_product(file).include?(product)
      end

      ''
    end

    def use_case_product(file)
      @use_case_product ||= YAML.safe_load("#{Rails.configuration.docs_base_path}/#{file}")['products']

      raise ArgumentError, "Missing 'products' key in use case document: #{file}" unless @use_case_product
    end

    def process_tutorial_file(file); end

    def allowed_products
      @allowed_products ||= [
        'account',
        'application',
        'conversion',
        'numbers',
        'number-insight',
        'sms',
        'tools',
        'verify',
        'voice',
      ].freeze
    end

    def allowed_tutorial_files
      file_names = []

      list = TutorialList.all

      list = list.reject { |l| allowed_products.each { |product| l.products.include?(product) } }
    end
  end
end
