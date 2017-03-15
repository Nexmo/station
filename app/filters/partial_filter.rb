class PartialFilter < Banzai::Filter
  def call(input)
    input.gsub(/```partial(.+?)```/m) do |s|
      config = YAML.load($1)
      File.read(config['source'])
    end
  end
end
