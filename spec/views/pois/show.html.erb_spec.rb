require 'spec_helper'

describe "pois/show" do
  before(:each) do
    @poi = assign(:poi, stub_model(Poi,
      :trip_id => 1,
      :name => "Name",
      :location => "Location",
      :description => "MyText",
      :image => "Image",
      :voters => "Voters"
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/1/)
    rendered.should match(/Name/)
    rendered.should match(/Location/)
    rendered.should match(/MyText/)
    rendered.should match(/Image/)
    rendered.should match(/Voters/)
  end
end
