# This is free software released into the public domain (CC0 license).


require 'addressable/uri'

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

		def ref?
			# FIXME: separate SourceRef class
			return !@uri.nil?
		end

		def ==(other)
			if other.equal?(self)
				return true
			end

			if other.is_a?(Source)
				if other.ref?
					return other.uri == self.uri
				else
					return other.value == self.value
				end
			end

			if ref?
				return Addressable::URI.parse(other) == @uri
			else
				return other == @value.to_s
			end
		end

		# FIXME: move part of == to eql?; add tests
	end
end
