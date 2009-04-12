require File.dirname(__FILE__) + '/../spec_helper'

describe Encounter do
  before do
    @encounter = Factory(:encounter)
  end

  it "should be valid" do
    @encounter.should be_valid
  end

  it "should find by date" do
    Encounter.find_by_date("2007-03-05".to_date).first.should == encounter(:andreas_art_visit)
  end

  it "should be retrospective only if datetime is 1 sec after mid-night" do
    @encounter.encounter_datetime = '2008-01-02 00:00:01'
    @encounter.should be_retrospective

    @encounter.encounter_datetime = '2008-01-02 00:00:02'
    @encounter.should_not be_retrospective
  end

  it "should be voided if it has no observations" do
    @encounter.should be_voided
    encounter_type = Factory(:encounter_type)
    @encounter.update_attributes( :encounter_type => encounter_type.id,
                                  :encounter_datetime => Time.now)
    observation = Factory(:observation, :obs_datetime => Time.now, :value_text => 'Unknown', :encounter => @encounter)
    Encounter.find(observation.encounter.id).should_not be_voided
  end

  it "should return type name for name" do
    @encounter.name.should == @encounter.type.name
  end

  it "should be displayable as a string" do
    @encounter.to_s.should == 'Encounter:Andreas Jahn HIV First visit Observations:0'
    encounter_type = Factory(:encounter_type, :name => 'ART Visit')
    @encounter.type = encounter_type
    @encounter.encounter_datetime = Time.now
    @encounter.patient_id = 1
    @encounter.save
    @encounter.to_s.should == 'Encounter:Andreas Jahn ART Visit Observations:0'
  end

  it "should update patients outcomes" do
    encounter_type = EncounterType.find_by_name('ART Visit')
    @encounter.update_attributes( :encounter_type => encounter_type.id,
                                  :encounter_datetime => Time.now,
                                  :patient_id => 1)
    @encounter.patient.reset_outcomes
    @encounter.patient.outcome.name.should == 'On ART'

    observation = Factory(:observation,
                          :obs_datetime => Time.now,
                          :value_text => 'Unknown',
                          :encounter => @encounter,
                          :patient => @encounter.patient,
                          :concept_id => Concept.find_by_name('Continue treatment at current clinic').id,
                          :value_coded => Concept.find_by_name('Transfer out').id)
    @encounter.reload
    @encounter.update_outcomes
    @encounter.reload
    @encounter.patient.historical_outcomes.reload
    @encounter.patient.outcome.name.should == 'Transfer out'
  end

  it "should get encounters by user" do
    encounters = Encounter.encounters_by_start_date_end_date_and_user("01-01-2007".to_date,Date.today,users(:mikmck).id)
    encounters.map(&:name).uniq.sort.should == ["Height/Weight", "Give drugs", "ART Visit", "HIV First visit", "HIV Staging", "HIV Reception", "Transfer Out", "Transfer Out With Note"].sort
  end

end
