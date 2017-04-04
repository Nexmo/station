class IconFilter < Banzai::Filter
  def call(input)
    input.gsub!('✅', '<i class="fa fa-lg fa-check-circle color--success">')
    input.gsub!('❎', '<i class="fa fa-lg fa-times-circle color--error">')

    input
  end
end
