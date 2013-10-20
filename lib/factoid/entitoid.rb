# This is free software released into the public domain (CC0 license).


module Factoid
	class Entitoid
		def initialize(uuid)
			@uuid = uuid
			@factoids = []
		end

		attr_reader :uuid

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
