require File.dirname(__FILE__) + '/../spec_helper'

describe Concept do
  before do
    Concept.delete_all
    @concept = Factory.build(:concept, :name => "Cough")
  end

  describe "new concepts" do
    it "should be valid" do
      @concept.should be_valid
    end

    it "should display concept as string" do
      @concept.to_s.should == "Cough"
    end

    it "should display short name of concepts" do
      @concept.to_short_s.should == "Cough"
    end
  end

  describe "saved concepts" do
    before do
      @concept = concept_factory("Cough")
    end

    describe "yes/no answers" do
      before do
        @yes ||= concept_factory("Yes", "Y")
        @no ||= concept_factory("No", "N")
        @unknown ||= concept_factory("Unknown", "Unk")
        @not_applicable ||= concept_factory("Not applicable", "N/A")
      end
      it "should add yes and no concept answers" do
        @concept.add_yes_no_concept_answers
        @concept.concept_answers.map(&:answer_concept).should include(@yes.id, @no.id)
      end
      it "should add yes, no, unknown concept answers" do
        @concept.add_yes_no_unknown_concept_answers
        @concept.concept_answers.map(&:answer_concept).should include(@yes.id, @no.id, @unknown.id)
      end
      it "should add yes, no, unknown, not applicable concept answers" do
        @concept.add_yes_no_unknown_not_applicable_concept_answers
        @concept.concept_answers.map(&:answer_concept).should include(@yes.id, @no.id, @unknown.id, @not_applicable.id)
      end
    end

    describe "other concept methods" do
      before do
        @start ||= concept_factory("Start")
        @substitute ||= concept_factory("Substitute")
        @switch ||= concept_factory("Switch")
        @arv ||= concept_factory("ARV Regimen type")
      end
      it "should create field" do
        @concept.create_field
        @concept.fields.map(&:name).to_s.should == "Cough"
      end
      it "should create start substitute switch answers for regimen type" do
        answers = Concept.create_start_substitute_switch_answers_for_regimen_type
        answers.to_s.should == "StartSubstituteSwitch"
      end
    end
  end

  def concept_factory(name, short = nil)
    @user ||= Factory(:user)
    @concept_class ||= Factory(:concept_class, :creator => @user)
    @data_type ||= Factory(:concept_datatype, :creator => @user)
    short ||= name
    Factory(:concept, :name => name, :concept_class => @concept_class, :short_name => short,
            :concept_datatype => @data_type, :creator => @user)
  end
end
