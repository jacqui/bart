require 'factory_girl/syntax/sham'

Sham.email      {|n| "somebody#{n}@example.com" }
Sham.username   {|n| "mike#{n}" }
Sham.first_name {|n| "Mike#{n}" }
Sham.last_name  {|n| "McKay#{n}" }
Sham.password   {|n| "rAnDoMsTrInG#{n}" }

Factory.define :concept do |c|
  c.name          "xCough"
  c.association   :concept_datatype
  c.date_created  { Time.now.to_formatted_s(:db) }
  c.date_changed  { Time.now.to_formatted_s(:db) }
  c.association   :created_by, :factory => :user
  c.association   :changed_by, :factory => :user
  c.is_set        false
  c.association   :concept_class
  c.description   nil
  c.retired       false
end

Factory.define :concept_answer do |c|
  c.association   :concept
  c.association   :answer_option, :factory => :concept
  c.association   :created_by, :factory => :user
  c.date_created  { Time.now.to_formatted_s(:db) }
end

Factory.define :concept_class do |c|
  c.association   :created_by, :factory => :user
  c.date_created  { Time.now.to_formatted_s(:db) }
  c.name          "Anatomy"
  c.description   "Anatomic sites / descriptors"
end

Factory.define :concept_datatype do |c|
  c.association   :created_by, :factory => :user
  c.date_created      { Time.now.to_formatted_s(:db) }
  c.name              "Boolean"
  c.hl7_abbreviation  "BIT"
  c.description       "Boolean value (yes/no, true/false)"
end
Factory.define :drug do |d|
  d.date_created  { Time.now.to_formatted_s(:db) }
  d.name          "Stavudine 6"
  d.route         "PO"
  d.units         "mg"
  d.combination   true
  d.association   :created_by, :factory => :user
  d.association   :concept
end

Factory.define :drug_order do |d|
  d.association :order
  d.association :drug_inventory
end

Factory.define :encounter do |e|
  e.date_created        { Time.now.to_formatted_s(:db) }
  e.encounter_datetime  { 1.week.ago.to_formatted_s(:db) }
  e.association         :type, :factory => :encounter_type
  e.association         :form
  e.association         :location
  e.association         :patient
  e.association         :provider, :factory => :user
  e.association         :created_by, :factory => :user
end

Factory.define :encounter_type do |e|
  e.name          "HIV First visit"
  e.date_created  { Time.now.to_formatted_s(:db) }
end

Factory.define :form do |f|
  f.build         1
  f.published     1
  f.association   :encounter_type
  f.association   :created_by, :factory => :user
  f.date_created  { Time.now.to_formatted_s(:db) }
  f.date_changed  { Time.now.to_formatted_s(:db) }
  f.date_retired  { Time.now.to_formatted_s(:db) }
  f.changed_by    1
  f.retired       false
  f.retired_by    1
end

Factory.define :location do |l|
  l.name          "Chinthembwe Health Centre"
  l.date_created  { Time.now.to_formatted_s(:db) }
  l.association   :created_by, :factory => :user
  l.description   "Private Health Facility"
end

Factory.define :observation do |o|
  o.association   :location
  o.date_created  { Time.now.to_formatted_s(:db) }
  o.voided        false
  o.obs_datetime  "2007-03-05 17:37:33"
  o.value_numeric 66
end

Factory.define :order do |o|
  o.date_created  { Time.now.to_formatted_s(:db) }
  o.association   :created_by, :factory => :user
  o.association   :encounter
  o.association   :order_type
  o.voided        false
end

Factory.define :order_type do |ot|
  ot.date_created  { Time.now.to_formatted_s(:db) }
  ot.association   :created_by, :factory => :user
  ot.name          "Give drugs"
end

Factory.define :patient do |p|
  p.birthdate_estimated false
  p.birthdate           { 20.years.ago.to_formatted_s(:db) }
  p.civil_status        1
  p.changed_by          1
  p.association         :creator, :factory => :user
  p.dead                1
  p.date_changed        { Time.now.to_formatted_s(:db) }
  p.date_created        { Time.now.to_formatted_s(:db) }
  p.date_voided         { Time.now.to_formatted_s(:db) }
  p.death_date          { Time.now.to_formatted_s(:db) }
  p.health_center       1
  p.association         :voided_by, :factory => :user
  p.voided              false
end

Factory.define :user do |u|
  u.salt          { User.random_string(10) }
  u.password      { |a| User.encrypt(Sham.password, a.salt) }
  u.date_created  { Time.now.to_formatted_s(:db) }
  u.date_changed  { Time.now.to_formatted_s(:db) }
  u.date_voided   { Time.now.to_formatted_s(:db) }
  u.voided        false
  u.username      { Sham.username }
  u.system_id     "Baobab Admin"
  u.first_name    { Sham.first_name }
  u.last_name     { Sham.last_name }
end
