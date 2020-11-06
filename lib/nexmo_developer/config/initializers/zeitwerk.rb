Rails.autoloaders.each do |autoloader|
  autoloader.inflector = Zeitwerk::Inflector.new
  autoloader.inflector.inflect(
    'smartling_api' => 'SmartlingAPI',
    'api' => 'API'
  )
end
