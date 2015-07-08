I have created a small framework from scratch based on Rspec, capybara & selenium-webdriver. For parsing rest apis, I’m using Rest-clint & Rexml.

I have automate following scenario:

TEST SCENARIO:
————————
1. Sign In (Background)
2. File upload & verification
       - Loop through images & get the image attribute (Name & Camera).
       - Browse file from image directory
       - Edit the view permission from flickr editor.
       - Click on upload
       - Verify image upload in first tile using ‘image name’ on first tile.
       - Fetch ‘camera’ & ‘title’ attribute from Flickrs apis & compare it with attributes of local file.

HOW TO RUN:
———————

Go to root directory.
bundle install — It will install all the required gem.
Go to Config directory & update your flick username, password & api key.
bundle exec rspec spec/flickr.rb

General Info:
- I have used page object concept for login scenario. This is just for showing that I’m aware of this concept.
- For getting image attributes, I have used exifr gem
- For handling ajax call synchronizations
- Used ‘raise’ & expectations
- Configured a basic html report
- Used logger for logging info.
- Tested this script. Its running fine & iterating over all images & showing the desired result.

There is always room for improvement so I can make changes as per your suggestion/review comments.
