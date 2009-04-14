require File.dirname(__FILE__) + '/../spec_helper'

describe Concept do
  before do
    @concept, @concept2 = Concept.all(:limit => 2)
  end
  it "should load cache" do
    Concept.load_cache.first.name.should == "Agrees to followup"
  end
  it "should return one concept for find from ids on a single id" do
    Concept.find_from_ids([@concept.id], {}).should == @concept
  end
  it "should return multiple concepts for find from ids on an array" do
    Concept.find_from_ids([@concept.id, @concept2.id], {}).should include(@concept, @concept2)
  end
  it "should find by name" do
    Concept.find_by_name(@concept.name).should == @concept
  end
end
