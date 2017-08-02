require 'simplecov'
SimpleCov.start
require 'minitest/autorun'
require 'minitest/pride'
require "minitest/emoji"

SimpleCov.start do
  add_filter "/test/"
end
