class Tutorial::Task
  extend ActiveModel::Naming

  attr_reader :name, :code_language, :current_step, :errors

  delegate :yaml, :path, to: :@file_loader

  def initialize(name:, current_step:, code_language: nil, title: nil, description: nil)
    @name         = name
    @title        = title
    @description  = description
    @code_language = code_language
    @current_step = current_step
    @file_loader = load_file!

    @errors = ActiveModel::Errors.new(self)
  end

  def load_file!
    Tutorial::FileLoader.new(
      root: Tutorial.task_content_path,
      doc_name: @name,
      code_language: @code_language,
      format: 'md'
    )
  end

  def validate!
    unless ['introduction', 'conclusion', 'prerequisites'].include? name
      path.present?
    end
  rescue ::Nexmo::Markdown::DocFinder::MissingDoc => _e
    @errors.add(:name, message: "could not find the file: #{name}")
  end

  def active?
    @name == @current_step
  end

  def self.make_from(name:, code_language:, current_step:)
    new(
      name: name,
      code_language: code_language,
      current_step: current_step
    )
  end

  def ==(other)
    name == other.name &&
      title == other.title &&
      description == other.description &&
      current_step == other.current_step
  end

  def eql?(other)
    self == other
  end

  def hash
    name.hash ^ title.hash ^ description.hash ^ current_step.hash
  end

  def title
    @title || yaml['title']
  end

  def description
    @description || yaml['description']
  end

  # The following methods are needed for validation

  def read_attribute_for_validation(attr)
    send(attr)
  end

  def self.human_attribute_name(attr, _options = {})
    attr
  end

  def self.lookup_ancestors
    [self]
  end
end
