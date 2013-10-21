# This is free software released into the public domain (CC0 license).


require 'addressable/uri'

require 'factoid/entitoid'

module Factoid
	class EntitoidRef
		def initialize(uri, base)
			@uri = Addressable::URI.parse(uri)
			@base = base
		end

		attr_reader :uri

		def full_uri
			return Addressable::URI.join(@base, @uri)
		end

		def deref
			return Entitoid.from_xml(full_uri)
		end

		def eql?(other)
			if other.class != self.class
				return false
			end

			return other.full_uri == self.full_uri
		end
	end
end
