class DocumentationConstraint
  attr_reader :product

  def matches?(request)
    ['voice', 'messaging'].include? request.params[:product]
  end
end
