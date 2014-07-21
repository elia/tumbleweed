require 'tumbleweed/version'
require 'mechanize'
require 'json'
require 'logger'

module Tumbleweed
  LOGIN_URL = 'https://www.tumblr.com/login'

  def self.upload_theme blog_name, email, password, theme_file, config_file = nil
    agent = Mechanize.new
    agent.log = Logger.new(STDERR) if ENV['DEBUG']
    page = agent.get LOGIN_URL

    form = page.forms.find { |form| form.action == LOGIN_URL }
    form['user[email]'] = email
    form['user[password]'] = password
    agent.submit(form)
    raise 'login failed' unless agent.cookies.find { |cookie| cookie.name == 'logged_in' }

    page = agent.get("https://www.tumblr.com/customize/#{blog_name}")
    body = page.body

    blog = JSON.parse(body[/Tumblr\._init\.blog = (\{[^\n]+\});/, 1])
    blog.reverse_merge(YAML.load_file(config_file)) if config_file
    blog['user_form_key'] = body[/Tumblr\._init\.user_form_key = '([^\n]+)';/, 1]
    blog['secure_form_key'] = body[/Tumblr\._init\.secure_form_key = '([^\n]+)';/, 1]
    blog['custom_theme'] = theme_file == '-' ? STDIN.read : File.read(theme_file)
    blog['id'] = blog_name

    agent.post("https://www.tumblr.com/customize_api/blog/#{blog_name}", blog.to_json)
  end
end
