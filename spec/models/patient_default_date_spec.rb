require File.dirname(__FILE__) + '/../spec_helper'

describe PatientDefaultDate do

  # If this fails then you need to migrate the views into your test database
  it "should have the view" do
    PatientDefaultDate.find(:all).should be_empty
  end

end
