# This is free software released into the public domain (CC0 license).


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
				require 'factoid/entitoid_ref'

				# TODO: use EntitoidRef.from_xml
				e = @raw_value.at('./f:*', NS)
				href = e.attr('xlink:href')

				v = EntitoidRef.new(href)
			else
				v = raw
			end

			# FIXME: follow

			return v
		end
	end
end
