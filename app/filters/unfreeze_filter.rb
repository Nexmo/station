class UnfreezeFilter < Banzai::Filter
  def call(input)
    input.gsub(/FREEZESTART(.+?)FREEZEEND/m) do |s|
      Base64.decode64($1).force_encoding(Encoding::UTF_8)
    end
  end
end
