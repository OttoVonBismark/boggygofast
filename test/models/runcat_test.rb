require 'test_helper'

class RuncatTest < ActiveSupport::TestCase
  def setup
    @game = games(:ori)
    @runcat = @game.runcats.build(category: "any%", rules: "This is a line of text")
  end

  test "runcat should be valid" do
    assert @runcat.valid?
  end

  test "category should be present" do
    @runcat.category = nil
    refute @runcat.valid?
  end

  test "rules should be present" do
    @runcat.rules = nil
    refute @runcat.valid?
  end

end
