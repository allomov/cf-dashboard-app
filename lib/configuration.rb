require 'ostruct'

class Configuration < OpenStruct

  attr_accessor :config

  def initialize(file_path, options = {})
  	super()
    file_config = File.exists?(file_path) ? YAML.load_file(file_path) : {}
    @config = options[:default_options].merge(file_config)
    options[:config_options].each do |option|
      self.send(:"#{option}=", ENV["#{options[:prefix].upcase}_#{option.upcase}"] || @config[option.to_s])
    end
  end

end
