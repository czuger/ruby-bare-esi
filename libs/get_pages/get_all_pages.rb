module RubyEsiGetPages
  module GetAllPages

    # Get a single page. Doesn't check for remaining pages, in case of error fail.
    #
    # @param expect [String] used only for tests.
    #
    # @return [Hash] a hash containing the data you are requested. For data content see API.
    def get_all_pages( expect: nil )
      result = []
      @params[:page] = 1

      loop do
        puts "RubyEsi.get_all_pages : requesting page #{@params[:page]}/#{@pages_count}" if @debug_mode

        pages = get_page

        unless pages.empty?
          result += pages if pages.is_a? Array
          result << pages if pages.is_a? Hash
        else
          puts 'RubyEsi.get_all_pages : page is empty' if @debug_mode
        end

        if @pages_count == 0 || @pages_count == 1
          puts 'RubyEsi.get_all_pages : no other pages to download - breaking out' if @debug_mode
          break
        else
          puts "RubyEsi.get_all_pages : More pages to download : #{@pages_count}" if @debug_mode
          @params[:page] += 1
        end

        if @params[:page] && @params[:page] > @pages_count
          puts 'RubyEsi.get_all_pages : No more pages to download - breaking out' if @debug_mode
          @params.delete(:page)
          break
        end
      end

      result
    end

  end
end