class Observation < OpenMRS
  set_table_name "obs"
  set_primary_key "obs_id"

  has_many :complex_obs, :foreign_key => :obs_id
  has_many :concept_proposals, :foreign_key => :obs_id
  has_many :notes, :foreign_key => :obs_id

  belongs_to :answer_concept, :class_name => "Concept", :foreign_key => :value_coded
  belongs_to :concept, :foreign_key => :concept_id
  belongs_to :drug, :foreign_key => :value_drug
  belongs_to :encounter, :foreign_key => :encounter_id
  belongs_to :location, :foreign_key => :location_id
  belongs_to :patient, :foreign_key => :patient_id
  belongs_to :order, :foreign_key => :order_id
  belongs_to :user, :foreign_key => :user_id

  named_scope :unvoided, :conditions => { :voided => 0 }
  named_scope :by_concept_id, lambda {|concept_id|
    { :conditions => { :concept_id => concept_id } }
  }
  named_scope :by_concept_name, lambda {|concept_name|
    {
      :include => 'concept',
      :conditions => ["concept.name = ?", concept_name],
      :order => "obs_datetime ASC"
    }
  }
  named_scope :by_concept_name_with_result, lambda {|concept_name, result|
    {
      :include => [:concept, :answer_concept],
      :conditions => ["concept.name = ? and answer_concepts_obs.name=?", concept_name, result],
      :order => "obs_datetime ASC"
    }
  }
  named_scope :on_date, lambda {|date|
    { :conditions => ["DATE(obs_datetime) = ?", date],
      :order => "obs_datetime"}
  }
  named_scope :with_result, lambda {|result|
    {
      :include => :answer_concept,
      :conditions => ["concept.name = ?", result],
      :order => "obs_datetime DESC"
    }
  }

  def self.find_by_concept_id(concept_id)
    unvoided.by_concept_id(concept_id)
  end
  def self.find_by_concept_name(concept_name)
    unvoided.by_concept_name(concept_name)
  end
  def self.find_by_concept_name_on_date(concept_name,date)
    unvoided.by_concept_name(concept_name).on_date(date)
  end
  def self.find_by_concept_name_with_result(concept_name, result)
    unvoided.by_concept_name_with_result(concept_name, result)
  end

  def to_short_s
    return concept.to_short_s + ":"  + attributes.collect{|name,value|
      next if value.nil? or value == "" or name !~ /value/
        case name
        when "value_coded"
          answer_concept.to_short_s
        when "value_drug"
          drug.to_abbreviation
        else
          value.to_s
        end
    }.compact.join(", ")
  end
  #
  # this to_s is meant to be an improvement on result_to_string
  def to_s
    return concept.name + ": "  + attributes.collect{|name,value|
      next if value.nil? or value == "" or name !~ /value/
        case name
        when "value_coded"
          answer_concept.name
        when "value_drug"
          drug.name
        else
          value.to_s
        end
    }.compact.join(", ")
  end

  def result_to_string
    return answer_concept.name unless value_coded.nil?
    return value_datetime.to_s unless value_datetime.nil?
    return value_text unless value_text.nil?
    return value_boolean.to_s unless value_boolean.nil?
    if concept.name =~ /Location/ and !(value_numeric.nil?)
      return Location.find(value_numeric).name unless value_numeric.nil?
    else
      return value_numeric.to_s unless value_numeric.nil?
    end
  end

end


### Original SQL Definition for obs ####
#   `obs_id` int(11) NOT NULL auto_increment,
#   `patient_id` int(11) NOT NULL default '0',
#   `concept_id` int(11) NOT NULL default '0',
#   `encounter_id` int(11) default NULL,
#   `order_id` int(11) default NULL,
#   `obs_datetime` datetime NOT NULL default '0000-00-00 00:00:00',
#   `location_id` int(11) NOT NULL default '0',
#   `obs_group_id` int(11) default NULL,
#   `accession_number` varchar(255) default NULL,
#   `value_group_id` int(11) default NULL,
#   `value_boolean` tinyint(1) default NULL,
#   `value_coded` int(11) default NULL,
#   `value_drug` int(11) default NULL,
#   `value_datetime` datetime default NULL,
#   `value_numeric` double default NULL,
#   `value_modifier` varchar(2) default NULL,
#   `value_text` text,
#   `date_started` datetime default NULL,
#   `date_stopped` datetime default NULL,
#   `comments` varchar(255) default NULL,
#   `creator` int(11) NOT NULL default '0',
#   `date_created` datetime NOT NULL default '0000-00-00 00:00:00',
#   `voided` tinyint(1) NOT NULL default '0',
#   `voided_by` int(11) default NULL,
#   `date_voided` datetime default NULL,
#   `void_reason` varchar(255) default NULL,
#   PRIMARY KEY  (`obs_id`),
#   KEY `answer_concept` (`value_coded`),
#   KEY `answer_concept_drug` (`value_drug`),
#   KEY `encounter_observations` (`encounter_id`),
#   KEY `obs_concept` (`concept_id`),
#   KEY `obs_enterer` (`creator`),
#   KEY `obs_location` (`location_id`),
#   KEY `obs_order` (`order_id`),
#   KEY `patient_obs` (`patient_id`),
#   KEY `user_who_voided_obs` (`voided_by`),
#   CONSTRAINT `answer_concept` FOREIGN KEY (`value_coded`) REFERENCES `concept` (`concept_id`),
#   CONSTRAINT `answer_concept_drug` FOREIGN KEY (`value_drug`) REFERENCES `drug` (`drug_id`),
#   CONSTRAINT `encounter_observations` FOREIGN KEY (`encounter_id`) REFERENCES `encounter` (`encounter_id`),
#   CONSTRAINT `obs_concept` FOREIGN KEY (`concept_id`) REFERENCES `concept` (`concept_id`),
#   CONSTRAINT `obs_enterer` FOREIGN KEY (`creator`) REFERENCES `users` (`user_id`),
#   CONSTRAINT `obs_location` FOREIGN KEY (`location_id`) REFERENCES `location` (`location_id`),
#   CONSTRAINT `obs_order` FOREIGN KEY (`order_id`) REFERENCES `orders` (`order_id`),
#   CONSTRAINT `patient_obs` FOREIGN KEY (`patient_id`) REFERENCES `patient` (`patient_id`),
#   CONSTRAINT `user_who_voided_obs` FOREIGN KEY (`voided_by`) REFERENCES `users` (`user_id`)
