require 'test_helper'

class RubyEsiTest < Minitest::Test

  def setup
  end

  def test_rest_url_mantatory
    assert_raises do
      RubyEsi.new
    end
  end

end