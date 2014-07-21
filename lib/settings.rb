require 'settingslogic'

class Settings < Settingslogic
  source File.join(Rails.root, 'config', 'cf.yml')
  # namespace Rails.env
end