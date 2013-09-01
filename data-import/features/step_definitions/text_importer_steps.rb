Given(/^I have a tab delimited text file$/) do
  @file = File.open('spec/support/test_input.txt')
end

Given(/^I go to the text importer$/) do
  visit text_importer_url
end

When(/^I upload the text file$/) do
  attach_file("file", File.absolute_path(@file.path))
  click_button('Upload')
end

Then(/^I should see the imported purchase total$/) do
  page.should have_content '95.00'
end
