require File.dirname(__FILE__) + '/../spec_helper'

describe ConceptDatatype do
  before do
    @datatype = Factory(:concept_datatype)
  end
  it "has a creator" do
    @datatype.created_by.should be_a_kind_of(User)
  end
  it "has_many :concepts" do
    @datatype.should respond_to(:concepts)
  end
end
