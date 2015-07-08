
class LoginPage < SitePrism::Page
  set_url "/"

  element :sign_in_link, :xpath, "//li[@class='gn-signin']/a[@class='gn-title']"
  def initialize
  end

  def click_on_sign_in
    sign_in_link.click
  end
end