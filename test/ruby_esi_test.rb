require 'test_helper'

class RubyEsiTest < Minitest::Test

  def setup
    @regions_list = [ 10000001 ]
    @region_hash = { 'constellations' => [ 20000001 ] }
    @constellation_hash = { 'name' => 'San Matar', 'systems' => [ 30000001 ] }
    @system_hash = { 'name' => 'Tanoo', 'stations' => [ 60012526 ] }
    @station_hash = { 'name' => 'Tanoo V - Moon 1 - Ammatar Consulate Bureau' }
  end


  def test_basic
    dus = RubyEsi.new( verbose_output: true )

    p :foo
    # dus.expects(:set_auth_token)
    # dus.expects(:get_all_pages).returns(@regions_list )
    #
    # dus.expects(:get_page_retry_on_error).with( expect: :region ).returns(@region_hash )
    #
    # dus.expects(:get_page_retry_on_error).with( expect: :constellation ).returns(@constellation_hash )
    #
    # dus.expects(:get_page_retry_on_error).with( expect: :system ).returns(@system_hash )
    #
    # dus.expects(:get_page_retry_on_error).with( expect: :station ).returns(@station_hash )

    assert( dus.get_page )
  end

end