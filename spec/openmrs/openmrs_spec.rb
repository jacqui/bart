require File.dirname(__FILE__) + '/../spec_helper'

class FakeClass < OpenMRS

end

describe OpenMRS do
  it "inherits from ActiveRecord::Base" do
    OpenMRS.superclass.should == ActiveRecord::Base
  end

  describe "#before_save" do
    it "calls super"
    describe "changed_by attribute" do
      it "checks that the attribute exists"
      it "checks that there is a current_user"
      it "when existent, gets set to current_user"
      it "when no current user, does not get set"
      it "when not existent, does not get set"
    end
    describe "date_changed attribute" do
      it "checks that the attribute exists"
      it "when existent, gets set to Time.now"
      it "when not existent, does not get set"
    end
  end
  describe "#before_create" do
    it "calls super"
    describe "date_created attribute" do
      it "checks that the attribute exists"
      it "when existent, gets set to Time.now"
      it "when not existent, does not get set"
    end
    describe "creator attribute" do
      it "checks that the attribute exists"
      it "checks for the existence of current_user"
      it "when existent, gets set to current_user"
      it "when not existent, does not get set"
    end
    describe "location_id attribute" do
      it "checks that the attribute exists"
      it "checks for the existence of current_location"
      it "when existent, gets set to current_location"
      it "when not existent, does not get set"
      it "when location_id == 0, does not get set"
    end
  end
  describe "#void!" do
    it "requires a reason"
    it "calls void()"
    it "calls save!"
  end
  describe "#void" do
    it "requires a reason"
    it "returns nil if voided?"
    it "sets date_voided to Time.now"
    it "sets voided to true"
    it "sets void_reason to reason"
    it "checks there is a current_user"
    it "sets voided_by to current_user's user_id when current_user is defined"
    it "does not set voided_by when no current_user"
  end
  describe "#voided?" do
    it "checks the voided attribute exists"
    it "returns voided when attribute exists"
    it "raises an error when attribute does not exist"
  end
  describe "#composite_clone" do
    it "calls composite?"
    describe "when object is composite" do
      it "grabs attributes before they are typecast"
      it "sets an @attributes ivar"
    end
    describe "when not composite" do
      it "calls clone"
    end
  end
  describe ".find_like_name" do
    it "requires a name parameter"
    it "calls find with conditions on name"
  end
  describe ".cache_on" do
    it "takes a splat args"
    it "sets class attr_accessor named 'cached'"
    it "sets class attribute 'cached' to true"
  end
  describe ".cached?" do
    it "returns the value of cached attribute"
  end

end
