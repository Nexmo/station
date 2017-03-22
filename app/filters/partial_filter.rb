class PartialFilter < Banzai::Filter
  def call(input)
    input.gsub(/```partial(.+?)```/m) do |_s|
      config = YAML.safe_load($1)
      File.read(config['source'])
    end
  end
end
