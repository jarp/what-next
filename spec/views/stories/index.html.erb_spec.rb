require 'rails_helper'

RSpec.describe "stories/index", type: :view do
  before(:each) do
    assign(:stories, [
      Story.create!(
        :name => "Name",
        :active => false,
        :taxonomy => "MyText"
      ),
      Story.create!(
        :name => "Name",
        :active => false,
        :taxonomy => "MyText"
      )
    ])
  end

  it "renders a list of stories" do
    render
    assert_select "tr>td", :text => "Name".to_s, :count => 2
    assert_select "tr>td", :text => false.to_s, :count => 2
    assert_select "tr>td", :text => "MyText".to_s, :count => 2
  end
end