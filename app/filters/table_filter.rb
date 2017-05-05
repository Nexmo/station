class TableFilter < Banzai::Filter
  def call(input)
    input.gsub!(/^\|{0,1}\s{0,1}-{2,}.+?\|.+?$/, '-- | --')
    input
  end
end
