require_relative "../../spec/spec_helper"

RSpec.describe 'Mobile Page' do

  before(:example) do
    browser_setup(browser_version)
  end

  after(:example) do |example|
    capture_screenshot_on_failure(example)
  end

  it "should add an item to cart " do |example|
    log_start_test("#{example.description}")
    delete_all_cookies
    open_url("http://#{app_url}")
    wait_for_page_load
    set_search_item_field("television")
    click_search_go_button
    click_first_item_on_search
    get_product_name
    add_item_to_cart
    product_name_cart_page = get_product_name_cart_page
    expect(is_only_one_item_in_cart).to eq(true)
    click_checkout
    login_existing_account(email_address, email_password)
    product_name_in_cart = get_product_name_in_cart
    expect(product_name_cart_page).to eq(product_name_in_cart)
    select_ship_to_home
    click_continue_on_shipping_page
    set_shipping_address
    remove_items
    expect(is_cart_empty?).to eq(true)
    click_sign_out
    log_complete_test("#{example.description}")
  end
end