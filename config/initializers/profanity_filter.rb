require 'profanity-filter'

PF = ProfanityFilter.new(
  whitelist: YAML.load_file(
               Rails.root.join('config', 'scunthorpe_whitelist.yml')
             )
)