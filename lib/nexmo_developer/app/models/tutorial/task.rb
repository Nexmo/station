class Tutorial::Task
  attr_reader :name, :code_language, :current_step

  delegate :yaml, :path, to: :@file_loader

  def initialize(name:, current_step:, code_language: nil, title: nil, description: nil)
    @name         = name
    @title        = title
    @description  = description
    @code_language = code_language
    @current_step = current_step
    @file_loader = load_file!
  end

  def load_file!
    Tutorial::FileLoader.new(
      root: Tutorial.task_content_path,
      doc_name: @name,
      code_language: @code_language,
      format: 'md'
    )
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
end
