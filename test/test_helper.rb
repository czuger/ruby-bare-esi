require 'simplecov'
SimpleCov.start

$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)

require_relative '../libs/ruby_esi'

require 'minitest/autorun'
require 'mocha/minitest'
require 'pp'

