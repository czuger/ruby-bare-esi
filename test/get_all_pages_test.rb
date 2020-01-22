require_relative 'test_helper'

class GetAllPagesTest < Minitest::Test

  def setup
    @page = EsiFakeRequest.new
    @re = RubyEsi.new( 'characters/1/', test_mode: true, debug_mode: false )
  end

  def test_get_all_pages_with_hash_input
    @re.expects(:open).returns( EsiFakeRequest.new( read_data: '{ "foo": "bar" }') )
    assert_equal([{ 'foo' => 'bar' }], @re.get_all_pages )
  end

  def test_get_all_pages_with_array_input
    @re.expects(:open).returns( EsiFakeRequest.new( read_data: '[ "foo", "bar" ]') )
    assert_equal(%w( foo bar ), @re.get_all_pages )
  end

  def test_get_all_pages_with_hash_input_with_multiple_pages
    @re = RubyEsi.new( 'characters/1/', test_mode: true, debug_mode: false )

    @re.expects(:open).times(2).returns(
      EsiFakeRequest.new( meta: { 'x-pages' => 2 }, read_data: '{ "foo": "bar" }') )

    assert_equal([{ 'foo' => 'bar' }, { 'foo' => 'bar' }], @re.get_all_pages )
  end


end