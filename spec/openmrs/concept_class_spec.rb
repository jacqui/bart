require File.dirname(__FILE__) + '/../spec_helper'

describe ConceptClass do
  before do
    @concept_class = Factory(:concept_class)
  end

  it "has a creator" do
    @concept_class.created_by.should be_a_kind_of(User)
  end
  it "has_many :concepts" do
    @concept_class.should respond_to(:concepts)
  end

end
