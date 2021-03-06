class RelationshipType < OpenMRS
  set_table_name "relationship_type"
  set_primary_key "relationship_type_id"

  has_many :relationships, :foreign_key => :relationship
  belongs_to :user, :foreign_key => :user_id
end


