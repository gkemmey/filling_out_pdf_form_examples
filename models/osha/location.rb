module Osha
  class Location
    attr_accessor :name, :city, :state

    def initialize(attributes = {})
      attributes.each { |name, value| send("#{name}=", value) }
    end
  end
end
