RSpec.configure do |config|
  config.include FactoryBot::Syntax::Methods
end

# Configure FactoryBot to find factories in the spec/factories directory
FactoryBot.definition_file_paths = [ File.join(Rails.root, 'spec', 'factories') ]
FactoryBot.find_definitions
