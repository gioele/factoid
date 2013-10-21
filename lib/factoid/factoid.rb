# This is free software released into the public domain (CC0 license).


module Factoid
	class Factoid
		def initialize(type, context, value_obj, sources, context_sources)
			@type = type
			@context = context
			@value_obj = value_obj

			@sources = sources
			@context_sources = context_sources
		end

		attr_reader :type
		attr_reader :value_obj
		attr_reader :context

		def sources
			if !@sources.empty?
				return @sources
			end

			uris = @context_sources.select { |s| s.default? }

			return uris
		end

		def match?(type, context)
			if @type != type # FIXME: check type hierarchy
				return false
			end

			return context.to_a.all? { |k, v| @context[k.to_s] == v }
		end

		def value(interpret = true, follow = false)
			return @value_obj.value(interpret, follow)
		end

		def eql?(other)
			if other.equal?(self)
				return true
			end

			if other.class != self.class
				return false
			end

			same = other.type == self.type &&
			       other.value.eql?(self.value) &&
			       other.sources == self.sources

			return same
		end
	end
end
