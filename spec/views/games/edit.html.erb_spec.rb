require 'spec_helper'

describe "games/edit" do
  before(:each) do
    @game = assign(:game, stub_model(Game,
      :user => "MyString",
      :width => 1,
      :height => 1,
      :colors => 1,
      :score => 1,
      :matrix => "MyText"
    ))
  end

  it "renders the edit game form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", game_path(@game), "post" do
      assert_select "input#game_user[name=?]", "game[user]"
      assert_select "input#game_width[name=?]", "game[width]"
      assert_select "input#game_height[name=?]", "game[height]"
      assert_select "input#game_colors[name=?]", "game[colors]"
      assert_select "input#game_score[name=?]", "game[score]"
      assert_select "textarea#game_matrix[name=?]", "game[matrix]"
    end
  end
end
