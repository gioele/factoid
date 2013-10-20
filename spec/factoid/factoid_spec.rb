# This is free software released into the public domain (CC0 license).


require 'spec_helpers'

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
			it "returns a single string" do
				expect(@name.value).to eql "Frédéric Chopin"
			end

			it "returns a date" do
				expect(@death_date.value).to eql Time.mktime(1849, 10, 17)
			end

			it "returns an entitoid ref" do
				place_ref = Factoid::EntitoidRef.new('zelazowa-wola')
				expect(@birth_place.value).to eql place_ref
			end
		end
	end
end
