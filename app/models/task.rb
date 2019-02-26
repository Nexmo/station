class Task
  include ActiveModel::Model
  attr_accessor :raw, :name, :current_step, :title, :description, :product, :subtasks

  def content_for(step_name)
    if ['introduction', 'conclusion'].include? step_name
      raise "Invalid step: #{step_name}" unless raw[step_name]
      return raw[step_name]['content']
    end

    path = "#{self.class.task_content_path}/#{step_name}.md"
    raise "Invalid step: #{step_name}" unless File.exist? path
    content = File.read(path)

    # Strip off leading YAML
    content.gsub(/\A(---.+?---)/mo, '').strip
  end

  def first_step
    subtasks.first['path']
  end

  def next_step
    current_task_index = subtasks.pluck('path').index(@current_step)
    subtasks[current_task_index + 1]
  end

  def previous_step
    current_task_index = subtasks.pluck('path').index(@current_step)
    return nil unless current_task_index
    return nil if current_task_index <= 0
    subtasks[current_task_index - 1]
  end

  def self.load(name, current_step)
    document_path = "#{task_config_path}/#{name}.yml"
    document = File.read(document_path)
    config = YAML.safe_load(document)
    Task.new({
      raw: config,
      name: name,
      current_step: current_step,
      title: config['title'],
      description: config['description'],
      product: config['product'],
      subtasks: load_subtasks(config['introduction'], config['tasks'], config['conclusion']),
    })
  end

  def self.load_subtasks(introduction, tasks, conclusion)
    tasks ||= []

    tasks = tasks.map do |t|
      t_path = "#{task_content_path}/#{t}.md"
      raise "Subtask not found: #{t}" unless File.exist? t_path
      subtask_config = YAML.safe_load(File.read(t_path))
      {
        'path' => t,
        'title' => subtask_config['title'],
        'description' => subtask_config['description'],
      }
    end

    if introduction
      tasks.unshift({
        'path' => 'introduction',
        'title' => introduction['title'],
        'description' => introduction['description'],
      })
    end

    if conclusion
      tasks.push({
        'path' => 'conclusion',
        'title' => conclusion['title'],
        'description' => conclusion['description'],
      })
    end

    tasks
  end

  def self.task_config_path
    Pathname.new("#{Rails.root}/config/tasks")
  end

  def self.task_content_path
    Pathname.new("#{Rails.root}/_tasks")
  end
end
