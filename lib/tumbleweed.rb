require "tumbleweed/version"

module Tumbleweed
  def self.upload_theme blog, user, password, theme_file, config_file
    url = 'https://www.tumblr.com'

    agent = Mechanize.new
    page = agent.get(url)

    # Login
    login_form = page.forms[1]
    login_form.email = email
    login_form.password = password
    agent.submit(login_form)

    page = agent.get("http://www.tumblr.com/customize/#{blog}")
    user_form_key = page.body.scan(/Tumblr\.Customize\.user_form_key\s*=\s*'([^']+)';/).flatten.first

    theme = File.read(theme_file)
    config = YAML.load_file(config_file)

    json = config.merge(
      'user_form_key' => user_form_key,
      'id'            => blog,
      'custom_theme'  => theme,
      'name'          => blog
    )

    agent.post("http://www.tumblr.com/customize_api/blog/#{blog}", json.to_json)
  end
end
