class DocumentationConstraint
  attr_reader :product

  def matches?(request)
    ['voice', 'messaging', 'account', 'concepts'].include? request.params[:product]
  end
end
