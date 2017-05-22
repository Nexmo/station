class DocumentationConstraint
  attr_reader :product

  def matches?(request)
    ['voice', 'messaging', 'verify', 'account', 'concepts'].include? request.params[:product]
  end
end
