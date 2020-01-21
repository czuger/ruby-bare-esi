require 'test_helper'

class RubyEsiTest < Minitest::Test

  def setup
    @page = EsiFakeRequest.new
  end

  def test_rest_url_mandatory
    assert_raises do
      RubyEsi.new
    end
  end

  def test_get_page
    re = RubyEsi.new( 'characters/1/', verbose_output: false )
    re.expects(:open).returns( @page )
    assert_equal( {}, re.get_page )
  end

end