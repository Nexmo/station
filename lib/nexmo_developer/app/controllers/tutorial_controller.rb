class TutorialController < ApplicationController
  before_action :set_navigation
  before_action :set_tutorial_step
  before_action :set_tutorial, except: %i[list single]
  before_action :check_tutorial_step, except: %i[list single]
  before_action :set_sidenav

  def list
    @product = params['product']
    @code_language = params['code_language']

    if @product
      @tutorials = TutorialList.tasks_for_product(@product)
    else
      @tutorials = TutorialList.all
    end
    @tutorials = @tutorials.select { |t| t.languages.include?(@code_language) } if @code_language

    @document_title = 'Tutorials'

    render layout: 'page'
  end

  def index
    if @tutorial_step == 'prerequisites'
      @content = render_to_string(partial: 'prerequisites', layout: false)
    else
      @content = Nexmo::Markdown::Renderer.new({
        code_language: @code_language,
        current_user: current_user,
      }).call(@tutorial.content_for(@tutorial_step))
    end

    # If it's an intro/conclusion we can't link to a specific task, so make sure that
    # we're linking to a non-product tutorial link as the canonical link
    if ['introduction', 'conclusion'].include?(@tutorial_step)
      @canonical_url = helpers.canonical_base + request.original_fullpath.gsub(%r{^/#{params[:product]}}, '')
    else
      # Otherwise it's a single step, which we can link to
      @canonical_url = "#{helpers.canonical_base}/task/#{@tutorial_step}"
    end

    render layout: 'documentation'
  end

  def single
    path = "#{Rails.configuration.docs_base_path}/_tutorials/#{I18n.default_locale}/#{params[:tutorial_step]}.md"
    @content = File.read(path)
    @content = Nexmo::Markdown::Renderer.new({
                                      code_language: @code_language,
                                      current_user: current_user,
                                    }).call(@content)
    render layout: 'documentation'
  end

  private

  def set_navigation
    @navigation = :tutorials
  end

  def set_sidenav
    @sidenav = Sidenav.new(
      namespace: params[:namespace],
      locale: params[:locale],
      request_path: request.path,
      navigation: @navigation,
      code_language: params[:code_language],
      product: params[:product]
    )
  end

  def set_tutorial
    @tutorial_name = params[:tutorial_name]
    render_not_found unless @tutorial_name
    @tutorial = Tutorial.load(
      @tutorial_name,
      @tutorial_step,
      params[:product],
      params[:code_language]
    )
  end

  def set_tutorial_step
    return unless params[:tutorial_step]

    @tutorial_step = params[:tutorial_step]
  end

  def check_tutorial_step
    # If we don't have a current tutorial step, redirect to the first available page
    return if @tutorial_step

    redirect_to url_for(
      controller: :tutorial,
      action: action_name,
      product: @tutorial.current_product,
      tutorial_name: @tutorial.name,
      tutorial_step: @tutorial.first_step,
      code_language: @tutorial.code_language
    )
  end
end
