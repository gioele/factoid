# This is free software released into the public domain (CC0 license).


require 'spec_helpers'

require 'factoid/entitoid'

describe Factoid::Entitoid do
	before(:all) do
		@e = Factoid::Entitoid.from_xml('spec/fixtures/chopin.xml')
	end

	it "can be loaded from XML" do
		expect(@e).to be_a Factoid::Entitoid
		expect(@e.uuid).to eql "chopin-23"
	end

	describe "#factoids" do
		it "returns all the factoids" do
			expect(@e.factoids(:all)).to have(7).items
		end

		it "returns all the factoids of type 'name'" do
			expect(@e.factoids('name')).to have(4).items
		end

		it "returns all the factoids of type 'name' with a certain context" do
			expect(@e.factoids('name', :language => 'fra')).to have(2).items
		end
	end

	describe "#value" do
		it "returns a single string value" do
			expect(@e.value('death-date')).to eq "1849-10-17"
		end

		it "raises an exception if the request is ambiguous" do
			expect { @e.value('birth-date') }.to raise_error
		end

		it "raises an exception if no factoid exists" do
			expect { @e.value('unk-property') }.to raise_error
		end
	end

	describe "#source" do
		it "returns the stated source" do
			f = @e.factoids('birth-date').first

			expect(f.sources).to eq ["#bcert"]
		end

		it "returns the default source" do
			f = @e.factoids('birth-date').last

			expect(f.sources).to eq ["http://en.wikipedia.org/wiki/Frédéric_Chopin"]
		end
	end
end
