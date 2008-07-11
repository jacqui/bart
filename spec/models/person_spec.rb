require File.dirname(__FILE__) + '/../spec_helper'

describe Person do
  # You can move this to spec_helper.rb
  set_fixture_class :person => Person
  fixtures :person

  sample({
    :person_id => 1,
    :patient_id => 1,
    :user_id => 1,
  })

  it "should be valid" do
    person = create_sample(Person)
    person.should be_valid
  end

  it "should all relationships"
  
end