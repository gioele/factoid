# This is free software released into the public domain (CC0 license).


require 'addressable/uri'

require 'factoid/value'

module Factoid
	class Source
		def initialize(uuid, uri, default, value)
			@uuid = uuid
			@uri = Addressable::URI.parse(uri)
			@default = default
			@value = value
		end

		attr_reader :uuid
		attr_reader :uri
		attr_reader :value

		def default?
			return @default
		end

		def ==(other)
			if other.equal?(self)
				return true
			end

			return value.empty? && Addressable::URI.parse(other) == uri
		end

		def self.from_xml(elem)
			uuid = elem.attr('xml:id')

			uri = elem.attr('href')

			default = (elem.attr('default') == 'true')

			value = Value.from_xml(elem)

			return Source.new(uuid, uri, default, value)
		end
	end
end
