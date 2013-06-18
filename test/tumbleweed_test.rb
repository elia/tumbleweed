require 'test/unit'
require 'tempfile'
require 'open-uri'

require File.dirname(__FILE__) + "/../lib/tumbleweed"

class Test::Unit::TestCase
  def test_upload_theme
    assert_equal 3, [ENV['BLOG'], ENV['EMAIL'], ENV['PASSWORD']].compact.length, "BLOG, EMAIL and PASSWORD are required"
    random_string = rand.to_s
    
    theme_file = Tempfile.new(__FILE__)
    theme_file << random_string
    theme_file.flush
    Tumbleweed.upload_theme ENV['BLOG'], ENV['EMAIL'], ENV['PASSWORD'], theme_file.path
    
    actual = open("http://#{ENV['BLOG']}.tumblr.com/?#{rand}").read
    assert_include actual, random_string
  end
end