require 'pp'

module EsiErrors

  class EsiErrors::Base < RuntimeError
    def self.dispatch( exception )

      # return EsiErrors::SocketError.new if exception.message =~ /SocketError/

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

      error
    end

    def retry?
      false
    end

  end

end

