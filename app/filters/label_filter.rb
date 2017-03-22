class LabelFilter < Banzai::Filter
  def call(input)
    input.gsub(/\[(\w+)\]/) do |_s|
      "<span class='label #{class_name($1)}'>#{$1}</span> "
    end
  end

  private

  def class_name(text)
    case text
    when 'POST'
      'label--code label--positive'
    when 'GET'
      'label--code'
    when 'DELETE'
      'label--code label--negative'
    when 'PUT'
      'label--code label--warning'
    end
  end
end
