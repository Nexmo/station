module Translator
  module Utils
    def locale_without_region(locale)
      case locale
      when 'zh-CN', 'cn'
        :cn
      when 'ja', 'ja-JP'
        :ja
      else
        :en
      end
    end

    def storage_folder(filename, locale)
      if filename.starts_with? '_documentation'
        dir_path = Pathname.new(file_uri(filename)).dirname.to_s
        "#{Rails.configuration.docs_base_path}/_documentation/#{locale}/#{dir_path}"
      elsif filename.starts_with? 'config/locales'
        Pathname.new(file_uri(filename)).dirname.to_s
      else
        raise 'Unexpected file path'
      end
    end

    def file_path(filename, locale)
      folder = storage_folder(filename, locale)
      file_name = if filename.starts_with? '_documentation'
                    Pathname.new(file_uri(filename)).basename.to_s
                  elsif filename.starts_with? 'config/locales'
                    "#{locale}#{Pathname.new(file_uri(filename)).extname}"
                  end
      "#{folder}/#{file_name}"
    end

    def file_uri(filename)
      filename.gsub(%r{_documentation/[a-z]{2}/}, '')
    end
  end
end
