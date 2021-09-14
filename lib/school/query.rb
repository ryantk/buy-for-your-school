# require "dry-initializer"
# require "types"
require "yaml"

module School
  class Query

    # School::Query.new('tmp/gias.yml')
    #
    def initialize(path)
      @gias = YAML.load_file(path)
    end

    def by_name(name)
      @gias.select do |establishment|
        establishment[:school][:name].match?(name)
      end
    end

    def by_federation(name)
      @gias.select do |establishment|
        establishment[:federation][:name].match?(name)
      end
    end

    def by_urn(urn)
      @gias.detect { |establishment| establishment[:urn].eql?(urn.to_i) }
    end

    def by_ukprn(ukprn)
      @gias.detect { |establishment| establishment[:ukprn].eql?(ukprn.to_i) }
    end

  end
end
