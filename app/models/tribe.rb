class Tribe < OpenMRS
  set_table_name "tribe"
  set_primary_key "tribe_id"

  has_many :patients, :foreign_key => :tribe
end


### Original SQL Definition for tribe ####
#   `tribe_id` int(11) NOT NULL auto_increment,
#   `retired` tinyint(1) NOT NULL default '0',
#   `name` varchar(50) NOT NULL default '',
#   PRIMARY KEY  (`tribe_id`)
