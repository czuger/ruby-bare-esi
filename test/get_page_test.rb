require 'test_helper'

class RubyEsiTest < Minitest::Test

  def setup
    @page = EsiFakeRequest.new
    @re = RubyEsi.new( 'characters/1/', silent_mode: true )
  end

  def test_rest_url_mandatory
    assert_raises do
      RubyEsi.new
    end
  end

  def test_get_page
    @re.expects(:open).returns( @page )
    assert_equal( {}, @re.get_page )
  end

  def test_get_page_with_json_parse_error
    @re.expects(:open).returns( EsiFakeRequest.new( read_data: '{:}') )
    assert_raises JSON::ParserError do
      @re.get_page
    end
  end

  def test_get_page_with_internal_server_error
    @re.expects(:open).returns( EsiFakeRequest.new( error_message: '500 Internal Server Error' ) )
    assert_raises EsiErrors::GatewayTimeout do
      @re.get_page
    end
  end

end