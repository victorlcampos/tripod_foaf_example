class Person
  include Tripod::Resource

  rdf_type 'http://xmlns.com/foaf/0.1/Person'
  graph_uri 'http://xmlns.com/foaf/0.1/people'

  field :name, 'http://xmlns.com/foaf/0.1/name'
  field :knows, 'http://xmlns.com/foaf/0.1/knows', multivalued: true, is_uri: true
end

# Blz, aqui eu digo quais são os campos que vão ter no RDF. Nas triplas, no caso eu só preenchi o nome até agora