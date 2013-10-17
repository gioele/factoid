# This is free software released into the public domain (CC0 license).


require 'nokogiri'

require 'factoid/factoid'
require 'factoid/source'

module Factoid
	class Entitoid
		def initialize(uuid)
			@uuid = uuid
			@factoids = []
		end

		attr_reader :uuid

		def self.from_xml(filename)
			x = Nokogiri::XML(open(filename))

			uuid = x.root.attr('xml:id')
			e = self.new(uuid)

			context_sources = []
			x.xpath('/*/f:sources/f:source').each do |s|
				context_sources << Source.from_xml(s)
			end

			x.xpath('/*/f:*', ::Factoid::NS).each do |f|
				if f.name == 'sources'
					next
				end

				e.add_factoid(::Factoid.from_xml(f, context_sources))
			end

			return e
		end

		def add_factoid(factoid)
			@factoids << factoid
		end

		def factoids(name, context = {})
			if name == :all
				return @factoids
			end

			matching = @factoids.select { |f| f.match?(name, context) }
			return matching
		end

		def value(name, context = {})
			f = factoids(name, context)

			if f.empty?
				raise "Cannot return value, no factoid matches name: '#{name}', context: #{context}"
			end

			if f.count > 1
				raise "Cannot return value, too many factoids match name: '#{name}', context: #{context}"
			end

			return f.first.value
		end
	end
end
