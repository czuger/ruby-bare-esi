require 'test_helper'

class ErrorsTest < Minitest::Test

  def setup
    @re = RubyEsi.new( 'characters/1/', test_mode: true, debug_mode: false )
  end

  # def test_bad_gateway_error
  #   @re.expects(:open).times(20).returns( EsiFakeRequest.new( error_message: '502 Bad Gateway' ) )
  #   assert_raises RuntimeError do |exception|
  #     @re.get_page_retry_on_error
  #   end
  # end

  # def test_internal_server_error
  #   @re.expects(:open).times(20).returns( EsiFakeRequest.new( error_message: '500 Internal Server Error' ) )
  #   assert_raises RuntimeError do
  #     @re.get_page_retry_on_error
  #   end
  # end
  #
  # def test_not_found_error
  #   @re.expects(:open).returns( EsiFakeRequest.new( error_message: '404 Not Found' ) )
  #   assert_raises EsiErrors::NotFound do
  #     @re.get_page_retry_on_error
  #   end
  # end


end