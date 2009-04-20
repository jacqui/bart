class Form < OpenMRS
  set_table_name "form"
  set_primary_key "form_id"

  has_many :form_fields, :foreign_key => :form_id, :dependent => :delete_all
  has_many :fields, :through => :form_fields
  has_many :encounters, :foreign_key => :form_id

  belongs_to :type_of_encounter, :class_name => "EncounterType",  :foreign_key => :encounter_type
  belongs_to :created_by, :class_name => "User", :foreign_key => :creator
end

