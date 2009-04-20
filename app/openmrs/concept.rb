require 'app/openmrs/open_mrs'
class Concept < OpenMRS
  set_table_name "concept"
  set_primary_key "concept_id"

  set_fixture_name "name"

  validates_uniqueness_of :name

  has_many :answer_options, :through => :concept_answers
  has_many :concept_answers, :foreign_key => :concept_id
  has_many :concept_names, :foreign_key => :concept_id
  has_many :concept_numerics, :foreign_key => :concept_id
  has_many :concept_proposals, :foreign_key => :obs_concept_id
  has_many :concept_sets_controlled, :class_name => "ConceptSet", :foreign_key => :concept_set
  has_many :concept_sets, :foreign_key => :concept_id  # these are the concept sets that this concept belongs to
  has_many :concept_synonyms, :foreign_key => :concept_id
  has_many :concept_words, :foreign_key => :concept_id
  has_many :concepts, :through => :concept_sets_controlled # this is for concept set children
  has_many :drug_ingredients, :foreign_key => :ingredient_id
  has_many :drugs, :foreign_key => :concept_id do
    def filter(filter_text)
      find(:all, :conditions => ["name LIKE ?", "%#{filter_text}%"])
    end
  end
  has_many :field_answers, :foreign_key => :answer_id
  has_many :fields, :foreign_key => :concept_id
  has_many :obs, :class_name => "Observation", :foreign_key => :concept_id
  has_many :set_concepts, :through => :concept_sets # these are the concepts that this concept belongs to through sets

  belongs_to :concept_class, :foreign_key => :class_id
  belongs_to :concept_datatype, :foreign_key => :datatype_id
  belongs_to :created_by, :class_name => "User", :foreign_key => :creator

  def to_s
    name
  end

  def to_short_s
    short_name.blank? ? name : short_name
  end

  def add_concept_answer(concept_name)
    unless answer_options.include?(Concept.find_by_name(concept_name))
      ConceptAnswer.create(:concept_id => concept_id, :answer_concept => Concept.find_by_name(concept_name).id)
    end
  end

  def add_yes_no_concept_answers
    ["Yes","No"].each {|answer| add_concept_answer(answer) }
  end

  def add_yes_no_unknown_concept_answers
    ["Yes","No","Unknown"].each {|answer| add_concept_answer(answer) }
  end

  def add_yes_no_unknown_not_applicable_concept_answers
    ["Yes","No","Unknown","Not applicable"].each {|answer| add_concept_answer(answer) }
  end

  def self.create_start_substitute_switch_answers_for_regimen_type
    arv_regimen_type = Concept.find_by_name("ARV Regimen type")
    if ConceptAnswer.find_by_concept_id(arv_regimen_type.concept_id).nil?
      Concept.find(:all, :conditions => "name in ('Start', 'Substitute', 'Switch')").each do |concept|
        ConceptAnswer.create(:concept_id => arv_regimen_type.id, :answer_concept => concept.id)
      end
    end
  end

  def create_field
    field = Field.new
    case concept_datatype.name
    when "Coded"
      field.type = FieldType.find_by_name("select")
    when "Number"
      field.type = FieldType.find_by_name("number")
    when "Date"
      field.type = FieldType.find_by_name("date")
    else
      field.type = FieldType.find_by_name("alpha")
    end
    field.name = name
    field.concept = self
    field.save
  end

end

