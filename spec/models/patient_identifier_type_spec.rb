require File.dirname(__FILE__) + '/../spec_helper'

describe PatientIdentifierType do

  sample({
    :name => "Home phone number",
    :format => "text",
    :date_created => "2006-10-30 10:06:12 +02:00".to_time,
    :creator => 1,
    :check_digit => false,
    :description => "text",
  })

  it "should be valid" do
    patient_identifier_type = create_sample(PatientIdentifierType)
    patient_identifier_type.should be_valid
  end
   
  it "should find by name" do
    PatientIdentifierType.find_by_name("Occupation").should == patient_identifier_type(:patient_identifier_type_00003)
  end  

end
