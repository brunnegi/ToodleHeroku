require 'spec_helper'

describe "pois/new" do
  before(:each) do
    assign(:poi, stub_model(Poi,
      :trip_id => 1,
      :name => "MyString",
      :location => "MyString",
      :description => "MyText",
      :image => "MyString",
      :voters => "MyString"
    ).as_new_record)
  end

  it "renders new poi form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => pois_path, :method => "post" do
      assert_select "input#poi_trip_id", :name => "poi[trip_id]"
      assert_select "input#poi_name", :name => "poi[name]"
      assert_select "input#poi_location", :name => "poi[location]"
      assert_select "textarea#poi_description", :name => "poi[description]"
      assert_select "input#poi_image", :name => "poi[image]"
      assert_select "input#poi_voters", :name => "poi[voters]"
    end
  end
end
