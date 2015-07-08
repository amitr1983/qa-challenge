class YahooPage < SitePrism::Page
  element :user_id_field, '#login-username'
  element :password_field, '#login-passwd'
  element :submit_btn, '#login-signin'

  def sign_in(username, password)
    begin
      user_id_field.set username
      password_field.set password
      submit_btn.click
    rescue Capybara::ElementNotFound => e
      $stderr.puts e.message
    end
  end
end