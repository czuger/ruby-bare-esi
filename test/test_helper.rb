require 'simplecov'
SimpleCov.start

$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)

require_relative '../lib/ruby-bare-esi'

require 'minitest/autorun'
require 'mocha/minitest'
require 'pp'
require 'ostruct'
require 'json'

class EsiFakeRequest

  DEFAULT_META = { 'x-pages' => 1, 'x-esi-error-limit-remain' => 100, 'x-esi-error-limit-reset' => 100 }

  attr_reader :meta

  def initialize( read_data: '{}', meta: {}, error_message: nil )
    @read_data = read_data
    @meta = DEFAULT_META.clone
    @meta.merge!( meta )
    @error_message = error_message
  end

  def read
    raise @error_message if @error_message
    @read_data
  end

end