require 'spec_helper'

describe "pois/index" do
  before(:each) do
    assign(:pois, [
      stub_model(Poi,
        :trip_id => 1,
        :name => "Name",
        :location => "Location",
        :description => "MyText",
        :image => "Image",
        :voters => "Voters"
      ),
      stub_model(Poi,
        :trip_id => 1,
        :name => "Name",
        :location => "Location",
        :description => "MyText",
        :image => "Image",
        :voters => "Voters"
      )
    ])
  end

  it "renders a list of pois" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => 1.to_s, :count => 2
    assert_select "tr>td", :text => "Name".to_s, :count => 2
    assert_select "tr>td", :text => "Location".to_s, :count => 2
    assert_select "tr>td", :text => "MyText".to_s, :count => 2
    assert_select "tr>td", :text => "Image".to_s, :count => 2
    assert_select "tr>td", :text => "Voters".to_s, :count => 2
  end
end
