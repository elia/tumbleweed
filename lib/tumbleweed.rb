require "tumbleweed/version"
require "mechanize"
require "json"

module Tumbleweed
  def self.upload_theme blog, email, password, theme_file, config_file = nil
    agent = Mechanize.new
    page = agent.get "https://www.tumblr.com/login"

    login_form = page.forms.first
    login_form.action = "/login"
    login_form["user[email]"] = email
    login_form["user[password]"] = password
    agent.submit(login_form)

    page = agent.get("http://www.tumblr.com/customize/#{blog}")
    user_form_key = page.body.scan(/Tumblr\.Customize\.user_form_key\s*=\s*'([^']+)';/).flatten.first

    theme = File.read(theme_file)
    config = config_file ? YAML.load_file(config_file) : {}

    json = config.merge(
      'user_form_key' => user_form_key,
      'id'            => blog,
      'custom_theme'  => theme,
      'name'          => blog
    )

    agent.post("http://www.tumblr.com/customize_api/blog/#{blog}", json.to_json)
  end
end
