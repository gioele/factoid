# This is free software released into the public domain (CC0 license).


require 'nokogiri'

require 'factoid/entitoid'
require 'factoid/entitoid_ref'
require 'factoid/factoid'
require 'factoid/source'
require 'factoid/value'

module Factoid
	FACTOID_NS_URI = 'http://svario.it/factoid'

	NS = {
		'f' => FACTOID_NS_URI,
		'xlink' => 'http://www.w3.org/1999/xlink',
		'xsd' => 'http://www.w3.org/2001/XMLSchema-datatypes',
	}

	def Entitoid.from_xml(filename)
		x = Nokogiri::XML(open(filename))

		uuid = x.root.attr('xml:id')
		e = self.new(uuid)

		context_sources = []
		x.xpath('/*/f:sources/f:source').each do |s|
			context_sources << Source.from_xml(s)
		end

		x.xpath('/*/f:*', NS).each do |f|
			if f.name == 'sources'
				next
			end

			e.add_factoid(Factoid.from_xml(f, context_sources))
		end

		return e
	end

	def EntitoidRef.from_xml(elem)
		href = elem.attr('xlink:href')
		base = elem.document.url

		return EntitoidRef.new(href, base)
	end

	def Factoid.from_xml(elem, context_sources)
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

	def Source.from_xml(elem)
		uuid = elem.attr('xml:id')

		uri = elem.attr('xlink:href')

		default = (elem.attr('default') == 'true')

		#value = Value.from_xml(elem)
		value = Value::EMPTY

		return Source.new(uuid, uri, default, value)
	end

	def Value.from_xml(container_elem)
		elem = container_elem.at('./f:value', NS)

		type = elem.attr('type')
		# TODO: special case for entitoids
		# TODO: use type = :entitoid_ref instead of nil

		return Value.new(type, elem)
	end
end
