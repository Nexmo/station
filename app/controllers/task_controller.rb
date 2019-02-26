class TaskController < ApplicationController
  before_action :set_task
  before_action :set_task_step

  def index
    # Load the task file from config
    task_path = "#{Rails.root}/config/tasks/#{@task}.yml"
    return not_found unless File.exist? task_path
    task_config = YAML.safe_load(File.read(task_path))
    @product = task_config['product']
    tasks = task_config['tasks']

    # If we don't have a current task step, redirect to the introduction if we have one
    # Or the first task if not
    unless @task_step
      if task_config['introduction']
        return redirect_to "/task/#{@task}/introduction"
      end
      first_task = tasks[0].gsub('/', '--')
      return redirect_to "/task/#{@task}/#{first_task}"
    end

    # If we do have a task, make sure it's not "introduction" or "conclusion"
    if ['introduction', 'conclusion'].include? @task_step
      task_content = task_config[@task_step]
      return not_found unless task_content
      @content = MarkdownPipeline.new.call(task_content['content'])
    else
        step_path = "#{task_root}/#{@task_step}.md"
        return not_found unless File.exist? step_path
        step_content = File.read(step_path)
        @content = MarkdownPipeline.new.call(step_content)
    end

    # Generate complete task navigation
    @subtasks = tasks.map do |t|
      t_path = "#{task_root}/#{t}.md"
      raise "Subtask not found: #{t}" unless File.exist? (t_path)
      subtask_config = YAML.safe_load(File.read(t_path))
      next {
        'path' => t,
        'title' => subtask_config['title'],
        'description' => subtask_config['description']
      }
    end

    # If we have an intro, it's the first task
    if task_config['introduction']
    @subtasks.unshift({
                     'path' => "introduction",
                     'title' => task_config['introduction']['title'],
                     'description' => task_config['introduction']['description']

                   })
    end

    if task_config['conclusion']
     @subtasks.push({
                     'path' => "conclusion",
                     'title' => task_config['conclusion']['title'],
                     'description' => task_config['conclusion']['description']

                   })
     end
   # If we have a conclusion, it's the last task

    # What's the next link in this task?
    current_task_index = @subtasks.pluck('path').index(@task_step)
    @next_task = current_task_index + 1

    # How about the previous?
    @previous_task = current_task_index - 1
    if @previous_task < 0
      @previous_task = nil
    end

    # Configure our sidebar navigation
    @namespace_path = "_documentation/#{@product}"
    @namespace_root = '_documentation'
    @sidenav_root = "#{Rails.root}/_documentation"

    # Render the page
    render layout: 'documentation'
  end

  def not_found
    render 'static/404', status: :not_found, formats: [:html]
  end

  private

  def set_task
    @task = params[:task_name]
    return not_found unless @task
  end

  def set_task_step
    return unless params[:task_step]
    @task_step = params[:task_step].gsub('--', '/')
  end

  def task_root
    "#{Rails.root}/_tasks"
  end

end
