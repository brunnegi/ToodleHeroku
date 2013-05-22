require 'spec_helper'

describe "trips/show" do
  before(:each) do
    @trip = assign(:trip, stub_model(Trip,
      :name => "Name",
      :owner => 1,
      :details => "MyText",
      :participants => "Participants",
      :poi => "Poi",
      :dpoi => 2
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Name/)
    rendered.should match(/1/)
    rendered.should match(/MyText/)
    rendered.should match(/Participants/)
    rendered.should match(/Poi/)
    rendered.should match(/2/)
  end
end
