class Relationship < OpenMRS
  set_table_name "relationship"
  set_primary_key "relationship_id"

  belongs_to :person, :foreign_key => :person_id
  belongs_to :relative, :class_name => "Person", :foreign_key => :relative_id
  belongs_to :type, :foreign_key => :relationship_type_id
  belongs_to :user, :foreign_key => :user_id
end

