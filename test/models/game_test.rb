require 'test_helper'

class GameTest < ActiveSupport::TestCase
  def setup
    @game = Game.new(name: "Super Metroid", slug: "super_metroid")
  end

  test "should be valid" do
    assert @game.valid?
  end

  test "name should be present" do
    @game.name = ""
    refute @game.valid?
  end

  test "slug should be present" do
    @game.slug = ""
    refute @game.valid?
  end

  test "slug should be preformatted before saving" do
    mixed_case_slug = "SuPeR MeTrOiD"
    @game.slug = mixed_case_slug
    @game.save
    assert_equal mixed_case_slug.parameterize.underscore, @game.reload.slug
  end
end
