class DocumentationConstraint
  attr_reader :product

  def matches?(request)
    ['voice', 'messaging', 'account', 'global'].include? request.params[:product]
  end
end
