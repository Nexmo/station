class CodeLanguage
  include ActiveModel::Model
  attr_accessor :key, :label, :lexer, :type
  attr_writer :weight, :linkable, :languages

  def weight
    @weight || 999
  end

  def linkable?
    @linkable || true
  end
end
