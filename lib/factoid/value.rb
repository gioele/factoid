# This is free software released into the public domain (CC0 license).


module Factoid
	class Value
		def initialize(value, raw_value)
			@value = value
			@raw_value = raw_value
		end

		EMPTY = Value.new(nil, nil).freeze

		def empty?
			return @value.nil? || @value.empty?
		end

		def to_str
			return @value
		end

		def ==(other)
			if other == @value
				return true
			end

			if other == @raw_value
				return true
			end

			return @value.to_str == other
		end

		def self.from_xml(container_elem)
			elem = container_elem.at('./f:value', NS)

			if elem.nil?
				return Value::EMPTY
			end

			text = elem.text
			text ||= ''

			# TODO: read type from attribute @type

			text.gsub!(/\n|\t/, ' ')
			text.strip!
			text.squeeze!

			return Value.new(text, elem)
		end
	end
end
