require 'pp'

module EsiErrors

  class EsiErrors::Base < RuntimeError

    PAUSE_DURATION_VALUE=60
    RETRY=false

    def self.dispatch( exception, debug_mode: false )

      # return EsiErrors::SocketError.new if exception.message =~ /SocketError/

      puts "EsiErrors::Base got exception : #{exception.inspect}" if debug_mode

      case exception.message

        when '500 Internal Server Error'
          error = EsiErrors::GatewayTimeout.new
        when '504 Gateway Timeout', '504 Gateway Time-out'
          error = EsiErrors::GatewayTimeout.new
        when '502 Bad Gateway'
          error = EsiErrors::BadGateway.new
        when '403 Forbidden'
          error = EsiErrors::Forbidden.new
        when '420 status code 420'
          error = EsiErrors::ErrorLimited.new
        when '404 Not Found'
          error = EsiErrors::NotFound.new
        when 'Net::OpenTimeout'
          error = EsiErrors::OpenTimeout.new
        when 'SocketError'
          error = EsiErrors::SocketError.new
        when '503 Service Unavailable'
          error = EsiErrors::ServiceUnavailable.new
        when '520 status code 520'
          error = EsiErrors::UnknownError.new
        else
          puts exception.full_message
          # pp exception.backtrace_locations
          raise 'Unhandled error'
      end

      if debug_mode
        puts "EsiErrors::Base about to return : #{error.inspect}"
        puts "EsiErrors::Base : retry = #{error.retry?}"
      end

      error
    end

    def retry?
      self.class::RETRY
    end

    def pause(  test_mode: false )
      sleep( self.class::PAUSE_DURATION_VALUE ) unless test_mode
    end

  end

end

require_relative 'bad_gateway'
require_relative 'error_limited'
require_relative 'forbidden'
require_relative 'gateway_timeout'
require_relative 'internal_server_error'
require_relative 'not_found'
require_relative 'open_timeout'
require_relative 'service_unavailable'
require_relative 'socket_error'
require_relative 'unknown_error'
