require 'spec_helper'
image_dir= "Images"

logger = Logger.new(STDOUT)
logger.level = Logger::INFO


feature "Flickr Photo Upload & Verification" do
  before(:all) do
    image_dir= "Images"
    config_file = "Config/config.yaml"
    @get_config = YAML.load_file(config_file)
  end

  background do
    logger.info("Flickr: Homepage")
    visit @get_config['ur']
    @page = LoginPage.new
    raise "Page not loaded.." if not @page.should have_title("Flickr, a Yahoo company | Flickr - Photo Sharing!")

    logger.info("Flickr: Click on Sign in link")
    @page.click_on_sign_in

    logger.info("Login on Yahoo")
    @yahoo_page = YahooPage.new
    @yahoo_page.sign_in(@get_config['username'],@get_config['password'])
    raise "Login not successful.." if not @page.should have_title("Welcome to Flickr - Photo Sharing")
  end

  scenario "Upload a File" do
    Dir.glob("#{image_dir}/*.{jpg,png,gif,jpeg}") do |image|

      logger.info("Get Camera model of local Image")
      # I have used exifr gem for getting image attributes

      if not EXIFR::JPEG.new(image).model.nil?
        camera=EXIFR::JPEG.new(image).make + " " + EXIFR::JPEG.new(image).model
        camera.downcase!
      end

      puts "Camera model is #{camera}"

      file_type=File.extname(image)
      image_title = File.basename image, file_type
      STDOUT.puts "Going to upload a #{file_type} image"

      logger.info("Flickr: Navigate to upload page")
      @page.find('a[data-track=Upload-main]').click

      logger.info("Flickr: Click on file upload button")
      @page.find("#main > #upload-cr > #upload-container > #upload-screen > #panel-grid > #working-area-wrapper > #empty-state > #empty-state-content > .hide-on-drag-hover > .browse-button-wrapper > #choose-photos-and-videos", :visible=>false).set (Dir.pwd+'/'+image)

      logger.info("Flickr Upload: Select Image")
      @page.find(".thumbnail").click

      logger.info("Flickr Image Edit: Make your photo public")
      first("li", :text=> "Visible to everyone").hover
      find(:li, ".privacy-public", :visible=> false).click
      find(:radio, "#editr-panel-privacy-public-1", :visible=> false).set(true)

      logger.info("Flickr Upload: Click on upload button")
      @page.find(:xpath, "//input[@id='action-publish']").click

      logger.info("Flickr Upload: Confirm Select Image")
      @page.find("#confirm-publish").click

      logger.info("Flickr: Close dialog box if appears")
      close_button=@page.first(".close-x")
      close_button.click unless close_button.nil?


      logger.info("Flickr: Verify image uploadby checking image name")
      if @page.first("div", image_title).nil?
        $stderr.puts "Image didn't get uploaded correctly"
      else
        $stdout.puts "Image uploaded correctly with Correct title"
      end

      logger.info("Flickr: Get Image url")
      flickr_image_url = @page.find_link("#{image_title}", :visible => false, :match => :first)[:href]
      p flickr_image_url
      $stdout.puts "Flickr image url is #{flickr_image_url}"

      logger.info("Flickr: Get url of Uploaded Image")
      photo_id = flickr_image_url.match(/photos\/[^\/]+\/([0-9]+)/)[1]

      logger.info("Flickr: camera attribute of uploaded image from API")

      camera_model_api=get_api_camera_attribute(@get_config['exif_api_url'], @get_config['api_key'],photo_id)

      logger.info("Flickr: verifying that camera attribute is correct on Flickr API.")
      if camera == camera_model_api.downcase
        $stdout.puts "Camera Model is matching. Expected:#{camera} & Actual: #{camera_model_api}"
      else
        $stderr.puts "Camera Model is NOT matching. Expected:#{camera} & Actual: #{camera_model_api}"
      end


      get_title_api=get_api_title_attribute(@get_config['info_api_url'], @get_config['api_key'],photo_id)

      logger.info("Flickr: verifying that title attribute is correct on Flickr API")
      if image_title == get_title_api
        $stdout.puts "Image title is Matching. Expected:#{image_title} & Actual: #{get_title_api}"
      else
        $stderr.puts "Image title is NOT matching.Expected:#{image_title} & Actual: #{get_title_api}"
      end

      logger.info("Go back to home page")
      @page.first("a", "main-logo", :visible=> false).click
    end
  end
end