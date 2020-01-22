require_relative 'test_helper'

class ErrorsTest < Minitest::Test

  TESTS_TO_DO = [
    [ 20, '500 Internal Server Error', RuntimeError, 'Retry count exceeded.'],
    [ 20, '504 Gateway Timeout', RuntimeError, 'Retry count exceeded.'],
    [ 20, '504 Gateway Time-out', RuntimeError, 'Retry count exceeded.'],
    [ 20, '502 Bad Gateway', RuntimeError, 'Retry count exceeded.'],
    [ 1, '403 Forbidden', EsiErrors::Forbidden, nil],
    [ 1, '420 status code 420', EsiErrors::ErrorLimited, nil],
    [ 1, '404 Not Found', EsiErrors::NotFound, nil],
    [ 20, 'Net::OpenTimeout', RuntimeError, 'Retry count exceeded.'],
    [ 20, 'SocketError', RuntimeError, 'Retry count exceeded.'],
    [ 20, '503 Service Unavailable', RuntimeError, 'Retry count exceeded.'],
    [ 20, '520 status code 520', RuntimeError, 'Retry count exceeded.'],
  ]

  def test_all_errors
    TESTS_TO_DO.each do |test|
      # p test

      expect_times, error_message, error_klass, exception_message = test

      re = RubyEsi.new( 'characters/1/', test_mode: true, debug_mode: false )

      re.expects(:open).times(expect_times).returns(
        EsiFakeRequest.new( error_message: error_message ) )

      exception = assert_raises error_klass do
        re.get_page_retry_on_error
      end

      assert_equal(exception_message, exception.message) if exception_message
    end
  end

end