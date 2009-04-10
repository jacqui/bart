class EncounterType < OpenMRS
  set_table_name "encounter_type"
  set_primary_key "encounter_type_id"

  cache_on "name"

  has_many :forms, :foreign_key => :encounter_type
  has_many :encounters, :foreign_key => :encounter_type

  belongs_to :user, :foreign_key => :user_id

  def url
    return "/form/show/" + self.forms.first.id.to_s unless self.forms.blank?
    return "/drug_order/dispense" if name == "Give drugs"
    return "/patient/update_outcome" if name == "Update outcome"
  end
end
