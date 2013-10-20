# This is free software released into the public domain (CC0 license).


require 'addressable/uri'

module Factoid
	class EntitoidRef
		def initialize(uri)
			@uri = Addressable::URI.parse(uri)
		end

		attr_reader :uri

		def eql?(other)
			if other.class != self.class
				return false
			end

			return other.uri == self.uri
		end
	end
end
