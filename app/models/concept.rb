require 'app/openmrs/concept'

class Concept
  def self.load_cache
    @@concept_hash_by_name = Hash.new
    @@concept_hash_by_id = Hash.new
    find(:all).each do |concept|
      @@concept_hash_by_name[concept.name.downcase] = concept
      @@concept_hash_by_id[concept.id] = concept
    end
  end

  load_cache

  # Use the cache hash to get these fast
  def self.find_from_ids(args, options)
    return super if args.length > 1
    @@concept_hash_by_id[args.first] || super
  end

  def self.find_by_name(concept_name)
    @@concept_hash_by_name[concept_name.to_s.downcase] || super
  end

end

### Original SQL Definition for concept ####
#   `concept_id` int(11) NOT NULL auto_increment,
#   `retired` tinyint(1) NOT NULL default '0',
#   `name` varchar(255) NOT NULL default '',
#   `short_name` varchar(255) default NULL,
#   `description` text,
#   `form_text` text,
#   `datatype_id` int(11) NOT NULL default '0',
#   `class_id` int(11) NOT NULL default '0',
#   `is_set` tinyint(1) NOT NULL default '0',
#   `icd10` varchar(255) default NULL,
#   `loinc` varchar(255) default NULL,
#   `creator` int(11) NOT NULL default '0',
#   `date_created` datetime NOT NULL default '0000-00-00 00:00:00',
#   `default_charge` int(11) default NULL,
#   `version` varchar(50) default NULL,
#   `changed_by` int(11) default NULL,
#   `date_changed` datetime default NULL,
#   `form_location` varchar(50) default NULL,
#   `units` varchar(50) default NULL,
#   `view_count` int(11) default NULL,
#   PRIMARY KEY  (`concept_id`),
#   KEY `concept_classes` (`class_id`),
#   KEY `concept_creator` (`creator`),
#   KEY `concept_datatypes` (`datatype_id`),
#   KEY `user_who_changed_concept` (`changed_by`),
#   CONSTRAINT `concept_classes` FOREIGN KEY (`class_id`) REFERENCES `concept_class` (`concept_class_id`),
#   CONSTRAINT `concept_creator` FOREIGN KEY (`creator`) REFERENCES `users` (`user_id`),
#   CONSTRAINT `concept_datatypes` FOREIGN KEY (`datatype_id`) REFERENCES `concept_datatype` (`concept_datatype_id`),
#   CONSTRAINT `user_who_changed_concept` FOREIGN KEY (`changed_by`) REFERENCES `users` (`user_id`)
