require 'open-uri'
require 'json'

require_relative 'errors/base'

require_relative 'get_pages/get_page'
require_relative 'get_pages/get_page_retry_on_error'

# This class is the entry point for all method allowing data retrieval from the ESI API
#
# @author Cédric ZUGER - 2020
class RubyEsi

  include RubyEsiGetPages::GetPage
  include RubyEsiGetPages::GetPageRetryOnError

  # This is the default address of the ESI API
  ESI_BASE_URL='https://esi.evetech.net/latest/'
  # And the default server used for the requests
  ESI_DATA_SOURCE={ datasource: :tranquility }

  # This initialize an RubyEsi download object.
  #
  # @param rest_url [String] the path of the method to access ESI (the exact path you would send to the API).
  # @param params [Hash] the params if required.
  # @param test_mode [Boolean] turns on or off test_mode. test_mode is off by default. It is turned on only during
  # tests to turn off some errors warnings and to reduce sleep time in case of automatic retry.
  # @param debug_mode [Boolean] turns on debugging if required. This also turn on verbose_mode.
  def initialize( rest_url = nil, params = {}, test_mode: false, debug_mode: false )

    raise "RubyEsi.initialize : rest_url can't be nil" unless rest_url

    @debug_mode = debug_mode || ENV['EBS_DEBUG_MODE'] == 'true'
    @test_mode = test_mode

    puts 'RubyEsi.initialize : debug mode on' if @debug_mode

    @rest_url = rest_url
    @params = params.merge( ESI_DATA_SOURCE )
    @forbidden_count = 0
  end

  def get_all_pages( expect: nil )
    result = []
    @params[:page] = 1

    loop do
      puts "RubyEsi.initialize : requesting page #{@params[:page]}/#{@pages_count}" if @debug_mode

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

  def set_auth_token( user=nil )

    # p user

    return false unless user.expires_on && user.token && user.renew_token

    unless user
      user_id = File.open( 'config/character_id.txt' ).read.to_i
      user = User.find_by_uid( user_id )
    end

    if user.expires_on < Time.now().utc
      puts "Token expired - #{user.expires_on} < #{Time.now().utc}"
      renew_token( user )
    end

    @params[:token] = user.token

    true
  end

  private

  def renew_token( user )
    client_id = secret_key = nil
    if File.exists?( 'config/omniauth.yaml' )
      results = YAML.load( File.open( 'config/omniauth.yaml' ).read )

      if results && results[:esi]
        client_id, secret_key = results[:esi]
      end
    end

    auth64 = Base64.strict_encode64( "#{client_id}:#{secret_key}" )
    auth_string = "Basic #{auth64}"

    RestClient.log = 'stdout' if @debug_mode

    c = RestClient.post 'https://login.eveonline.com/oauth/token',
                        { grant_type: :refresh_token, refresh_token: user.renew_token },
                        { 'Authorization' => auth_string }
    response = JSON.parse( c.body )

    user.update!( token: response['access_token'], expires_on: Time.now() + response['expires_in'] )
  end

  def error_print( e )
    unless @test_mode
      warn "#{Time.now} - Requesting #{@rest_url}, #{@params.inspect} got '#{e}', limit_remains = #{@errors_limit_remain}, limit_reset = #{@errors_limit_reset}"
    end

    STDOUT.flush
  end

  def set_headers
    puts "RubyEsi.set_headers : request = #{@request}" if @debug_mode

    @pages_count = @request.meta['x-pages'].to_i
    @errors_limit_remain = @request.meta['x-esi-error-limit-remain']
    @errors_limit_reset = @request.meta['x-esi-error-limit-reset']
  end

  def build_url
    url = ( @rest_url + '?' + @params.map{ |k, v| "#{k}=#{v}" }.join( '&' ) ).gsub( '//', '/' )
    ESI_BASE_URL + url
  end

end