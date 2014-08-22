require 'minitest/autorun'
require 'tempfile'
require 'open-uri'

require File.dirname(__FILE__) + "/../lib/tumbleweed"

describe Tumbleweed do
  before do
    assert_equal 3, [ENV['BLOG'], ENV['EMAIL'], ENV['PASSWORD']].compact.length, "BLOG, EMAIL and PASSWORD are required"
  end

  it "uploads a theme" do
    unique_string = [Time.now, rand].to_s

    theme_file = Tempfile.new('tumbleweed')
    theme_file << unique_string
    theme_file.flush
    Tumbleweed.upload_theme ENV['BLOG'], ENV['EMAIL'], ENV['PASSWORD'], theme_file.path
    
    actual = open("http://#{ENV['BLOG']}.tumblr.com/?#{rand}").read
    actual.must_include unique_string
  end

  it "downloads a theme" do
  end
end