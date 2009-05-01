require File.dirname(__FILE__) + '/../spec_helper'

describe OpenMRS do
  before do
    @concept = Concept.new
    User.stubs(:current_user)
    @user = User.new
  end

  context "changed_by" do
    context "when subclass has attribute" do
      context "with current_user" do
        before do
          User.stubs(:current_user).returns(stub_model(User, Factory.attributes_for(:user)))
        end
        it "sets to current_user's user_id" do
          lambda { @concept.save }.should change(@concept, :changed_by).to(User.current_user.user_id)
        end
      end
      context "without a current_user" do
        before do
          User.stubs(:current_user)
        end
        it "does not set the attribute" do
          lambda { @concept.save }.should_not change(@concept, :changed_by)
        end
      end
    end
    context "date_changed" do
      context "when attribute exists" do
        it "gets set to Time.now" do
          lambda{ @concept.save }.should change(@concept, :date_changed)
        end
      end
    end
  end

  context "#before_create" do
    context "date_created" do
      context "when attribute exists" do
        it "gets set to Time.now" do
          lambda{ @concept.save }.should change(@concept, :date_created)
        end
      end
    end
    context "creator" do
      context "with current_user" do
        before do
          User.stubs(:current_user).returns(stub_model(User, Factory.attributes_for(:user)))
        end
        it "sets to current_user's user_id" do
          lambda { @concept.save }.should change(@concept, :creator).to(User.current_user.user_id)
        end
      end
      context "without a current_user" do
        before do
          User.stubs(:current_user)
        end
        it "does not set the attribute" do
          lambda { @concept.save }.should_not change(@concept, :creator)
        end
      end
    end
    context "location_id attribute" do
      before do
        @concept.stubs(:location_id)
        @concept.stubs(:location_id=)
      end
      context "with current_location" do
        before do
          Location.stubs(:current_location).returns(stub_model(Location, Factory.attributes_for(:location)))
        end
        it "sets to current_location's location_id" do
          @concept.expects(:location_id=)
          @concept.save
        end
      end
      context "without a current_location" do
        before do
          Location.stubs(:current_location)
        end
        it "does not set the attribute" do
          @concept.expects(:location_id).never
          @concept.save
        end
      end
    end
  end
  context "#void!" do
    before do
      @user.stubs(:void)
      @user.stubs(:save!)
    end
    it "requires a reason" do
      lambda{ @user.void! }.should raise_error
    end
    it "calls void" do
      @user.expects(:void).with('foo')
      @user.void!('foo')
    end
    it "calls save!" do
      @user.expects(:save!)
      @user.void!('foo')
    end
  end
  context "#void" do
    before do
      @user.stubs(:voided?).returns(false)
    end
    it "requires a reason" do
      lambda{ @user.void }.should raise_error
    end
    it "returns nil if voided?" do
      @user.stubs(:voided?).returns(true)
      @user.void('foo').should be_nil
    end
    it "sets date_voided to Time.now" do
      lambda { @user.void('foo') }.should change(@user, :date_voided)
    end
    it "sets voided to true" do
      lambda { @user.void('foo') }.should change(@user, :voided).to(true)
    end
    it "sets void_reason to reason" do
      lambda { @user.void('foo') }.should change(@user, :void_reason).to('foo')
    end
    it "sets voided_by to current_user's user_id when current_user is defined" do
      voider = Factory(:user)
      User.stubs(:current_user).returns(voider)
      lambda { @user.void('foo') }.should change(@user, :voided_by).to(voider.user_id)
    end
    it "does not set voided_by when no current_user" do
      User.stubs(:current_user)
      lambda { @user.void('foo') }.should_not change(@user, :voided_by)
    end
  end
  context "#voided?" do
    it "returns the boolean value when the attribute exists" do
      @user.stubs(:voided).returns(true)
      @user.should be_voided
    end
    it "raises an error when attribute does not exist" do
      lambda do
        @concept.voided?
      end.should raise_error
    end
  end

  context "#composite_clone" do
    context "on a non-composite record" do
      before do
        @user.stubs(:composite?).returns(false)
      end

      it "calls clone" do
        clone = @user.clone
        @user.expects(:clone).returns(clone)
        @user.composite_clone
      end
    end

    context "on a composite record" do
      before do
        @user.stubs(:composite?).returns(true)
      end

      it "makes a new record of the same type" do
        blank = User.new
        User.expects(:new).yields(blank)
        @user.composite_clone
      end

      it "fetches the uncast attributes and sets them on the clone" do
        blank = User.new
        User.expects(:new).yields(blank)
        @user.expects(:attributes_before_type_cast).returns({})
        blank.expects(:instance_variable_set).with('@attributes', {})
        @user.composite_clone
      end
    end
  end

#  context ".find_like_name" do
#    it "requires a name parameter"
#    it "calls find with conditions on name"
#  end
#  context ".cache_on" do
#    it "takes a splat args"
#    it "sets class attr_accessor named 'cached'"
#    it "sets class attribute 'cached' to true"
#  end
#  context ".cached?" do
#    it "returns the value of cached attribute"
#  end

end
