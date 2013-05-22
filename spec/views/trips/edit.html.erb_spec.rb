require 'spec_helper'

describe "trips/edit" do
  before(:each) do
    @trip = assign(:trip, stub_model(Trip,
      :name => "MyString",
      :owner => 1,
      :details => "MyText",
      :participants => "MyString",
      :poi => "MyString",
      :dpoi => 1
    ))
  end

  it "renders the edit trip form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => trips_path(@trip), :method => "post" do
      assert_select "input#trip_name", :name => "trip[name]"
      assert_select "input#trip_owner", :name => "trip[owner]"
      assert_select "textarea#trip_details", :name => "trip[details]"
      assert_select "input#trip_participants", :name => "trip[participants]"
      assert_select "input#trip_poi", :name => "trip[poi]"
      assert_select "input#trip_dpoi", :name => "trip[dpoi]"
    end
  end
end
