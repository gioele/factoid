factoid: read, manipulate and save factoids
===========================================

`factoid` is a Ruby library to manipulate _factoids_ and _entitoids_
inside Ruby applications without touching the their XML representations.

Factoids and Entitoids are representations of pieces of information
about a certain entity. These representations not only store the
information itself, but also keep track of provenance (who stated
something, where, when) and context (under which assumption is a
certain piece of information valid?). Using factoids one can store
and manage different values for the same property of an entity.

For example, instead of just storing that

> composer with ID 14 has property 'name' = 'Frédéric Chopin'

using factoids one can say

> there is a composer with ID 14

> Wikipedia says that composer#14 has
> * a property 'name',
> * with context 'language' = 'fra',
> * and value 'Frédéric Chopin'.

> Book with ISBN 9780007351824 says that composer#14 has
> * a property 'name',
> * with context 'language' = 'pol',
> * and value 'Fryderyk Chopin'.

The name of composer 14 is then both _Frédéric Chopin_ and _Fryderyk
Chopin_ depending on the context.

Factoids and entitoids are described more in depth at
<http://svario.it/factoid>.

The `factoid` gem makes it possible to load and save factoids, to search
and select factoids that match certain patterns and to access complex
information in a simple way.


Examples
--------

    c14 = Factoid::Entitoid.from_xml('composer14.xml')

    puts "Known names:"
    puts
    c.factoids('name').each do |fact|
    	puts " #{fact.value} in #{fact.context['language']}"
	puts "   (from #{fact.sources})"
	puts
    end

    # Known names:
    #
    #  Frédéric Chopin in fra
    #    (from http://en.wikipedia.org/wiki/Frédéric_Chopin)
    #  Fryderyk Chopin in pol
    #    (from urn:isbn:9780007351824)


Requirements
------------

factoid is based on Nokogiri and uses Addressable to manage URIs.


Install
-------

Install the factoid gem using RubyGems

    gem install factoid

or Bundler

    # in Gemfile
    gem 'factoid'

To use the factoid gem in your project, load it with

    require 'factoid'


Author
------

* Gioele Barabucci <http://svario.it/gioele> (initial author)


Development
-----------

Code
: <http://svario.it/factoid/ruby> (redirects to GitHub)

Report issues
: <http://svario.it/factoid/ruby/issues>

Documentation
: <http://svario.it/factoid/ruby/docs>


License
-------

This is free software released into the public domain (CC0 license).

See the `COPYING` file or <http://creativecommons.org/publicdomain/zero/1.0/>
for more details.
