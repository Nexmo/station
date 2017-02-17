class DocumentationConstraint
  attr_reader :product

  def matches?(request)
    ['voice', 'messaging', 'account'].include? request.params[:product]
  end
end
