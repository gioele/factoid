# This is free software released into the public domain (CC0 license).


require 'factoid/entitoid_ref'
require 'factoid/xml'

module Factoid
	class Value
		def initialize(type, raw_value)
			@type = type
			@raw_value = raw_value
		end

		EMPTY = Value.new(nil, nil).freeze

		def value(interpret = true, follow = false)
			raw = nil

			if @raw_value.elements.empty?
				raw = @raw_value.text
			else
				raw = @raw_value
			end

			if !interpret
				return raw
			end

			# TODO: move to separate decoders

			if @type == 'xsd:date'
				require 'time'

				v = Time.parse(raw)
			elsif !@raw_value.xpath('./f:*', NS).empty?
				e = @raw_value.at('./f:*', NS)
				href = e.attr('xlink:href')

				v = EntitoidRef.new(href)
			else
				v = raw
			end

			# FIXME: follow

			return v
		end

		def self.from_xml(container_elem)
			elem = container_elem.at('./f:value', NS)

			type = elem.attr('type')
			# TODO: special case for entitoids
			# TODO: use type = :entitoid_ref instead of nil

			return Value.new(type, elem)
		end
	end
end
