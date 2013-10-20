# This is free software released into the public domain (CC0 license).


require 'addressable/uri'
require 'nokogiri'

require 'factoid/source'
require 'factoid/value'

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
			return @value_obj.value
		end
	end

	def self.from_xml(elem, context_sources)
		type = elem.name unless elem.name == 'factoid'
		type ||= elem.attr('type')

		context = {}
		elem.xpath('./*[name(.) != "value"]').each do |e|
			context[e.name] = e.text
		end

		value = Value.from_xml(elem)

		raw_sources = elem.xpath('f:source', NS)
		sources = raw_sources.map do |e|
			Source.from_xml(e)
		end

		return Factoid.new(type, context, value, sources, context_sources)
	end
end
