module RubyEsiGetPages
  module GetPage

    # Get a single page. Doesn't check for remaining pages, in case of error fail.
    #
    # @param page_number [Int] the number of the pages you are requesting, if there are more pages you need to get (default the first).
    #
    # @return [Hash] a hash containing the data you are requested. For data content see API.
    def get_page( page_number=nil )
      @params[:page] = page_number if page_number
      url = build_url
      puts "Fetching : #{url}" if @debug_mode

      parsed_result = nil

      begin
        @request = open( url )

        set_headers

        json_result = @request.read
        parsed_result = JSON.parse( json_result )

      rescue JSON::ParserError => parse_error
        warn 'Got parse error !!!' unless @silent_mode
        raise parse_error

      rescue => e
        error = EsiErrors::Base.dispatch( e, debug_mode: @debug_mode )
        error_print( error )

        raise error
      end

      parsed_result
    end

  end
end