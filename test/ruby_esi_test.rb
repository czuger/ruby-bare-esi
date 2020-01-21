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

  def test_rest_url_mentatory
    re = RubyEsi.new( 'characters/1/', verbose_output: true )

    re.expects(:open).returns( @page )

    assert re.get_page
  end


end