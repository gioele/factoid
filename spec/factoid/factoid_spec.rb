# This is free software released into the public domain (CC0 license).


require 'spec_helpers'

require 'nokogiri'

require 'factoid/entitoid'
require 'factoid/entitoid_ref'
require 'factoid/factoid'
require 'factoid/xml'

describe Factoid::Factoid do
	before (:all) do
		e = Factoid::Entitoid.from_xml('spec/fixtures/chopin.xml')
		@name = e.factoids('name', 'language' => 'fra').first
		@death_date = e.factoids('death-date').first
		@birth_place = e.factoids('birth-place').first
	end

	describe "#value" do
		context "with no arguments" do
			it "returns a string" do
				expect(@name.value).to eql "Frédéric Chopin"
			end

			it "returns a date" do
				expect(@death_date.value).to eql Time.mktime(1849, 10, 17)
			end

			it "returns an entitoid ref" do
				place_ref = Factoid::EntitoidRef.new('zelazowa-wola', 'spec/fixtures/chopin.xml')
				expect(@birth_place.value).to eql place_ref
			end
		end

		context "with no interpretation" do
			it "returns a string" do
				expect(@name.value(false)).to eql "Frédéric Chopin"
			end

			it "returns a string also for dates" do
				expect(@death_date.value(false)).to eql "1849-10-17"
			end

			it "returns an XML element" do
				expect(@birth_place.value(false)).to be_a Nokogiri::XML::Node
			end
		end

		context "with follows" do
			it "returns a string" do
				expect(@name.value(true, true)).to eql "Frédéric Chopin"
			end

			it "returns a string also for dates" do
				expect(@death_date.value(true, true)).to eql Time.mktime(1849, 10, 17)
			end

			it "returns an entitoid" do
				zelazowa_wola = Factoid::Entitoid.from_xml('spec/fixtures/zelazowa-wola.xml')
				expect(@birth_place.value(true, true)).to eql zelazowa_wola
			end
		end
	end
end
