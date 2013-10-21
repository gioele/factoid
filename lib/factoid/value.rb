# This is free software released into the public domain (CC0 license).


module Factoid
	class Value
		def initialize(type, raw_value)
			@type = type
			@raw_value = raw_value
		end

		EMPTY = Value.new(nil, nil).freeze

		def value(interpret, follow)
			raw = nil

			if @raw_value.elements.empty?
				raw = @raw_value.text
			else
				raw = @raw_value
			end

			if !interpret
				return raw
			end

			interpreter = Interpreters.find { |i| begin i.accept?(@type, raw); rescue; end; }
			v = interpreter.interpret(@type, raw)

			if !follow
				return v
			end

			# FIXME: use Dereferenciators (like Interpreters)
			if v.is_a? EntitoidRef
				r = v.deref
			else
				r = v
			end

			return r
		end

		class XSDDateInterpreter
			def self.accept?(type, value)
				return type == 'xsd:date'
			end

			def self.interpret(type, value)
				require 'time'
				return Time.parse(value)
			end
		end

		class EntitoidInterpreter
			def self.accept?(type, value)
				return !value.xpath('./f:*', NS).empty?
			end

			def self.interpret(type, value)
				require 'factoid/xml'

				# FIXME: allow also complete entitoids

				elem = value.at('./f:*', NS)
				return EntitoidRef.from_xml(elem)
			end
		end

		class IndentityInterpreter
			def self.accept?(type, value)
				return true
			end

			def self.interpret(type, value)
				return value
			end
		end

		Interpreters = [
			XSDDateInterpreter,
			EntitoidInterpreter,
			IndentityInterpreter,
		]
	end
end
