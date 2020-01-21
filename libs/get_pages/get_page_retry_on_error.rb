module RubyEsiGetPages
  module GetPageRetryOnError

    def get_page_retry_on_error( page_number=nil )
      parsed_result = nil
      retry_count = 0

      loop do
        begin
          parsed_result = get_page( page_number )
          break

        rescue JSON::ParserError
          next

        rescue
          if error.retry?

            retry_count += 1
            if retry_count >= 20
              raise 'Retry count exceeded.'
            end

            error.pause
            next
          else
            raise error
          end
        end
      end

      parsed_result
    end

  end
end