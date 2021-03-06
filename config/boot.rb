require 'combine_pdf'
require 'erb'
require 'prawn'
require 'pry'
require 'singleton'
require 'yaml'

require 'active_support/concern'
require 'active_support/core_ext/array/access.rb'
require 'active_support/core_ext/class/attribute'
require 'active_support/core_ext/string/access'

class App
  include Singleton

  ROOT = File.expand_path '../..', __FILE__

  def self.root
    ROOT
  end

  def self.rand_date
    Time.at(rand(Time.new(2020, 1, 1).to_i..(Time.new(2020, 4, 12).to_i))).strftime("%m/%d/%Y")
  end

  def self.lorem_ipsum
    [
      "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt " \
        "ut labore et dolore magna aliqua.",
      "Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea " \
        "commodo consequat.",
      "Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat " \
        "nulla pariatur.",
      "Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit " \
        "anim id est laborum."
    ].then { |li| li.sample(rand(li.length + 1)) }.join(" ")
  end

  def self.monsters_inc
    Osha::Location.new(name: "Monsters, Inc.", city: "Monstropolis", state: "New York")
  end

  def self.osha_incidents
    instance.osha_incidents
  end

  def osha_incidents
    @incidents ||= YAML.load(
                     ERB.new(File.read(File.join(App.root, 'fixtures/osha_incidents.yml.erb'))).result
                   ).
                   values.
                   collect { |attributes| Osha::Incident.new(attributes) }

  end
end

Dir.glob(File.join(App.root, 'models/**/*.rb')).each do |model_file|
  require model_file
end

Dir.glob(File.join(App.root, 'pdfs/**/*.rb')).
    sort_by { |file| file.include?("layout.rb") ? 0 : 1 }.
    each do |file|
  require file
end
