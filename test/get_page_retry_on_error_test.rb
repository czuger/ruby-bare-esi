require 'test_helper'

class GetPageRetryOnErrorTest < Minitest::Test

  def setup
    @page = EsiFakeRequest.new
    @re = RubyEsi.new( 'characters/1/', test_mode: true, debug_mode: false )
  end

  def test_get_page_retry_on_error_single_step
    @re.expects(:open).returns( @page )
    assert_equal( {}, @re.get_page_retry_on_error )
  end

  def test_get_page_with_json_parse_error
    @re.expects(:open).returns( EsiFakeRequest.new( read_data: '{:}') )
    assert_raises JSON::ParserError do
      @re.get_page_retry_on_error
    end
  end

  def test_get_page_with_internal_server_error
    @re.expects(:open).times(20).returns( EsiFakeRequest.new( error_message: '500 Internal Server Error' ) )
    assert_raises RuntimeError do
      @re.get_page_retry_on_error
    end
  end

  def test_get_page_with_not_found_error
    @re.expects(:open).returns( EsiFakeRequest.new( error_message: '404 Not Found' ) )
    assert_raises EsiErrors::NotFound do
      @re.get_page_retry_on_error
    end
  end

end