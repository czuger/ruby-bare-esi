module RubyBareEsiGetPages
  module GetPageRetryOnError

    # Get a single page. Doesn't check for remaining pages, in case of error retry according to Error class retry parameters.
    #
    # @param page_number [Int] the number of the pages you are requesting, if there are more pages you need to get (default the first).
    #
    # @return [Hash] a hash containing the data you are requested. For data content see API.
    def get_page_retry_on_error( page_number=nil )
      parsed_result = nil
      retry_count = 0

      loop do
        begin
          parsed_result = get_page( page_number )
          break

        rescue EsiErrors::Base => error
          puts "RubyBareEsiGetPages::GetPageRetryOnError.get_page_retry_on_error : retry = #{error.retry?}" if @debug_mode

          if error.retry?

            retry_count += 1
            if retry_count >= 20
              raise 'Retry count exceeded.'
            end

            error.pause( test_mode: @test_mode )
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