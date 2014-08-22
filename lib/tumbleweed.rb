require 'tumbleweed/version'
require 'mechanize'
require 'json'
require 'logger'

module Tumbleweed
  LOGIN_URL = 'https://www.tumblr.com/login'
  
  class Client
    attr_reader :agent
    
    def initialize
      @agent = Mechanize.new
      @agent.log = Logger.new(STDERR) if ENV['DEBUG']
    end

    def login(email, password)
      page = @agent.get LOGIN_URL
      form = page.forms.find { |form| form.action == LOGIN_URL }
      form['user[email]'] = email
      form['user[password]'] = password
      @agent.submit(form)
      raise 'login failed' unless @agent.cookies.find { |cookie| cookie.name == 'logged_in' }
    end

    def customize(blog_name)
      page = @agent.get("https://www.tumblr.com/customize/#{blog_name}")
      body = page.body

      blog_json = JSON.parse(body[/Tumblr\._init\.blog = (\{[^\n]+\});/, 1])
      [body, blog_json]
    end

    def post(blog_name, json)
      @agent.post("https://www.tumblr.com/customize_api/blog/#{blog_name}", json)
    end
  end

  def self.upload_theme blog_name, email, password, theme_file, config_file = nil
    client = Client.new
    client.login(email, password)

    body, blog = client.customize(blog_name)
    blog.reverse_merge(YAML.load_file(config_file)) if config_file
    blog['user_form_key'] = body[/Tumblr\._init\.user_form_key = '([^\n]+)';/, 1]
    blog['secure_form_key'] = body[/Tumblr\._init\.secure_form_key = '([^\n]+)';/, 1]
    blog['custom_theme'] = theme_file == '-' ? STDIN.read : File.read(theme_file)
    blog['id'] = blog_name

    client.post(blog_name, blog.to_json)
  end

  def self.download_theme blog_name, email, password
    client = Client.new
    client.login(email, password)

    body, blog_json = client.customize(blog_name)
    blog_json['custom_theme']
  end
end
