require 'bundler/inline'

gemfile do
  source 'https://rubygems.org'
  gem 'prawn'
  gem 'combine_pdf'
  gem 'pry'
end

Dir.glob(File.join('./snippets/**/', '*.rb')).each do |snippet|
  require snippet
end

send(ARGV.first)

# ruby run_snippet.rb hello_world
# ruby run_snippet.rb rectangle
# ruby run_snippet.rb text
# ruby run_snippet.rb grid
