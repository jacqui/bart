require File.dirname(__FILE__) + '/../spec_helper'

describe ConceptAnswer do
  before do
    @concept = Factory(:concept, :changed_by => nil)
    @answer = Factory(:concept, :name => "Unintentional weight loss in the absence of concurrent illness", :changed_by => nil, :created_by => @concept.created_by, :concept_datatype => @concept.concept_datatype)
    @concept_answer = Factory(:concept_answer, :concept => @concept, :answer_option => @answer)
  end
  it "has a concept" do
    @concept_answer.concept.should be_a_kind_of(Concept)
  end
  it "has a creator" do
    @concept_answer.created_by.should be_a_kind_of(User)
  end
  it "requires a unique answer_concept per concept" do
    ConceptAnswer.new(:concept => @concept, :answer_concept => @concept_answer.answer_concept).should have(1).error_on(:answer_concept)
  end
end
