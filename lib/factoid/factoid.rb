# This is free software released into the public domain (CC0 license).


require 'addressable/uri'
require 'nokogiri'

require 'factoid/source'
require 'factoid/value'

module Factoid
	class Factoid
		def initialize(type, context, value, sources, context_sources)
			@type = type
			@context = context
			@value = value

			@sources = sources
			@context_sources = context_sources
		end

		attr_reader :type
		attr_reader :context
		attr_reader :value

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
