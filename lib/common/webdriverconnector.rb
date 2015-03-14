require_relative '../../spec/spec_helper'
require_relative '../../lib/common/configuration'

module SeleniumWebdriver
  module WebDriverConnector

    @@default_wait_options = {:timeout => Constants::SHORT_TIMEOUT_VALUE}

    def set_driver(driver)
      @driver = driver
    end

    def empty?
      true
    end

    def execute_js(jquerycommand)
      return @driver.execute_script(jquerycommand)
    end

    def open_url(url)
      self.maximize_browser
      @driver.get url
    end

    def navigate_to_url(url)
      @driver.navigate.to url
    end

    def get_text(locator_or_element)
      element = resolve_to_element(locator_or_element)
      element.text
    end

    def delete_all_cookies
      self.maximize_browser
      @driver.manage.delete_all_cookies
    end

    def set_cookie_value cookie ={}
      @driver.manage.add_cookie cookie
    end

    def get_cookie_value cookie_name
      cookie = @driver.manage.cookie_named(cookie_name)
      cookie[:value].to_s
    end

    def refresh_page
      @driver.navigate.refresh
    end

    def quit_webdriver
      @driver.close()
      @driver.quit()
    end

    def maximize_browser
      @driver.manage.window.maximize
    end

    def wait_for_and_accept_alert(wait_seconds = 5)
      for loop_to_wait_for_alert in 1..wait_seconds
        alert = @driver.switch_to.alert rescue Selenium::WebDriver::Error::NoAlertPresentError
        if (alert == Selenium::WebDriver::Error::NoAlertPresentError)
          log_method_step_debug(get_method_name, "Still waiting for alert")
          sleep(1)
          loop_to_wait_for_alert = loop_to_wait_for_alert+1
        else
          log_method_step_debug(get_method_name, "Found the alert")
          @driver.switch_to.alert.accept
          break
        end
      end
    end

    def alert_dismiss
      begin
        log_method_step_debug(get_method_name, "Begin ")
        @driver.switch_to.alert.dismiss
      rescue (Selenium::WebDriver::Error::NoAlertPresentError)
        log_method_step_debug(get_method_name, "No Alert is open")
      end
    end

    def get_page_source
      @driver.page_source
    end

    def get_title
      @driver.title
    end

    def is_text_present(text)
      self.get_page_source.include? text
    end

    def wait_for_ajax_to_complete
      Selenium::WebDriver::Wait.new(:timeout => Constants::SHORT_TIMEOUT_VALUE, :message => 'unable to load AJAX contents in the given time frame').until { self.execute_js("return jQuery.active ==0") }
    end


    def is_element_present?(element_or_locator)
      elements = []
      if element_or_locator == nil
        return false
      elsif (element_or_locator.class==Hash)
        elements =get_web_elements(element_or_locator)
      else
        elements.push(element_or_locator)
      end
      if elements.empty?
        return false
      else
        elem = elements.first
        elem.displayed?
      end
    end

    def form_submit(locator)
      element = self.get_web_element(locator)
      element.submit
    end

    def is_element_enabled? (locator)
      element = self.resolve_to_element(locator)
      element.enabled?
    end

    # exception e handles all exceptions without having the need to use the ||. This practice will not catch all errors.
    def is_element_displayed?(locator_element, wait_options = false)

      if (locator_element.class==Hash)
        begin
          if (wait_options == false)
            if get_web_element(locator_element) == nil
              return false
            else
              return self.get_web_element(locator_element).displayed?
            end
          else
            wait = Selenium::WebDriver::Wait.new wait_options
            return wait.until { self.get_web_element(locator_element).displayed? }
          end
        rescue Exception => e
          log_method_step_debug(get_method_name, "An Exception was found #{e}")
          return false
        end
      end

      if (wait_options == false)
        return locator_element.displayed?
      end

      begin
        wait = Selenium::WebDriver::Wait.new wait_options
        return wait.until { locator_element.displayed? }
      rescue Selenium::WebDriver::Error::TimeOutError
        return false
      end
    end

    def wait_for_element_to_present (locator, wait_options = @@default_wait_options)
      wait = Selenium::WebDriver::Wait.new wait_options
      wait.until { self.get_web_element(locator) }
    end

    def wait_for_element_to_display (locator, wait_options = @@default_wait_options)
      begin
        log_method_step(get_method_name, "Starting: Waiting for element to be displayed - #{locator}")
        wait = Selenium::WebDriver::Wait.new wait_options
        wait.until { self.get_web_elements(locator).find { |x| x.displayed? } }
        log_method_step_debug(get_method_name, "Completed: Waiting for element to be displayed - #{locator}")
        return true
      rescue Exception => e
        log_method_step_debug(get_method_name, "An Error occurred "+e.message)
        return false
      end
    end

    def wait_for_child_element_to_display(parent_element, child_locator, wait_options = @@default_wait_options)
      begin
        log_method_step_debug(get_method_name, "Starting: Waiting for child element to be displayed")
        wait = Selenium::WebDriver::Wait.new wait_options
        wait.until { get_child_web_element(parent_element, child_locator) != nil }
      rescue Exception => e
        log_method_step_debug(get_method_name, "An Error occurred "+e.message)
      end
    end

    def wait_for_element_to_not_display (locator, wait_options = @@default_wait_options)
      begin
        log_method_step_debug(get_method_name, "Starting: Waiting for element to not be displayed - #{locator}")
        wait = Selenium::WebDriver::Wait.new wait_options
        wait.until { !self.get_web_elements(locator).find { |x| x.displayed? } }
        log_method_step_debug(get_method_name, "Completed: Waiting for element to not be displayed - #{locator}")
      rescue Exception => e
        log_method_step_debug(get_method_name, "An Error occurred "+ e.message)
      end
    end

    def wait_for_page_load (wait_options = @@default_wait_options)
      log_method_step_debug(get_method_name, "Starting...")
      begin
        wait = Selenium::WebDriver::Wait.new wait_options
        wait.until { @driver.execute_script("return document.readyState;") == "complete" }
      rescue
        log_method_step_debug(get_method_name, "Completed in rescue...")
      end
      log_method_step_debug(get_method_name, "Completed...")
    end

    def click_with_driver(driver, locator)
      (driver.get_web_element(locator)).click
    end

    def mouse_over(locator)
      elem = self.get_web_element(locator)
      @driver.action.move_to(elem).perform
    end

    def mouse_over_web_element(web_element)
      #elem = self.get_web_element(locator)
      @driver.action.move_to(web_element).perform
    end

    def mouse_over_element(elem)
      if (elem.class==Hash)
        @driver.action.move_to(get_web_element(elem)).perform
      else
        @driver.action.move_to(elem).perform
      end
    end

    def mouse_over_element_click(elem)
      if (elem.class==Hash)
        @driver.action.move_to(get_web_element(elem)).click.perform
      else
        @driver.action.move_to(elem).click.perform
      end
    end

    def drag_and_drop(widget_element, x_offset, y_offset)
      if (widget_element.class==Hash)
        @driver.action.drag_and_drop_by(get_web_element(widget_element), x_offset, y_offset).perform
      else
        @driver.action.drag_and_drop_by(widget_element, x_offset, y_offset).perform
      end
    end

    def click (locator)
      (self.get_web_element(locator)).click
    end

    def click_once_visible(locator)
      wait_for_element_to_display(locator)
      click(locator)
    end

    def click_visible_element(locator)
      get_web_elements(locator).each do |elem|
        if (is_element_displayed?(elem))
          click_web_element(elem)
        end
      end
    end

    #Somewhat hacky method that fixes a lot of errors related to setting text (seemingly due to some timing issues with setting the text)
    def set_text_with_extra_char (locator_or_element, textToSet)
      element = resolve_to_element(locator_or_element)
      clear_text(element)
      element.send_keys(textToSet)
      element.send_keys("~")
      element.send_keys(:backspace)
    end

    def set_text (locator_or_element, textToSet)
      element = resolve_to_element(locator_or_element)
      clear_text(element)
      element.send_keys(textToSet)
    end

    def set_text_without_clear (locator_or_element, textToSet)
      element = resolve_to_element(locator_or_element)
      element.send_keys(textToSet)
    end

    def get_attribute (locator_or_element, attribute)
      begin
        element = resolve_to_element(locator_or_element)
        attribute_value = element.attribute(attribute)
      rescue
        attribute_value = "nil"
      end
      return attribute_value
    end

    def clear_text (locator_or_element)
      element = resolve_to_element(locator_or_element)
      element.clear()
    end

    def get_current_title
      @driver.title
    end

    def getCurrentUrl
      @driver.current_url
    end

    def get_method_name
      caller[0]=~/`(.*?)'/
      $1
    end

    def get_click_jsquery_value
      @@clickJsQuery
    end

    def click_through_JS(locator_or_element)
      if locator_or_element.class == Hash then
        execute_js("arguments[0].click(0)", (self.get_web_element(locator_or_element)))
      else
        execute_js("arguments[0].click(0)", locator_or_element)
      end
    end

    def get_text_through_JS(locator)
      #@driver.execute_script("arguments[0].click(0)",(self.get_web_element(locator)))
      execute_js("arguments[0].innerHTML", (self.get_web_element(locator)))
    end

    def execute_js(script, *args)
      @driver.execute_script(script, *args)
    end

    #select_by :text, :value, :index
    def select_item_from_dropdown(locator, select_by, itemToSelect)
      if (locator.class ==Hash)
        option = Selenium::WebDriver::Support::Select.new(get_web_element(locator))
        option.select_by(select_by, itemToSelect)
      else
        option = Selenium::WebDriver::Support::Select.new(locator)
        option.select_by(select_by, itemToSelect)
      end
    end

    def get_selected_item_from_dropdown(locator)
      option = Selenium::WebDriver::Support::Select.new(get_web_element(locator))
      return (option.first_selected_option).text
    end

    def to_boolean(str)
      return true if str=="true"
      return false if str=="false"
    end

    def get_web_element(locator)
      element = Hash[locator.map { |(k, v)| [k.to_sym, v] }]
      begin
        elements = @driver.find_elements element.keys.first => element.values.first
        elements.size > 1 ? elements.find_all { |x| x.displayed? }.first : elements.first
      rescue (Selenium::WebDriver::Error::NoSuchElementError || Selenium::WebDriver::Error::StaleElementReferenceError)
        return nil
      end
    end

    def get_last_web_element(locator)
      element = Hash[locator.map { |(k, v)| [k.to_sym, v] }]
      @driver.find_element element.keys.last => element.values.last
    end

    def get_web_elements(locator)
      element = Hash[locator.map { |(k, v)| [k.to_sym, v] }]
      elements = @driver.find_elements element.keys.first => element.values.first
      elements.find_all { |x| x.displayed? }
    end

    def switch_to_last_window
      @driver.switch_to.window(@driver.window_handles.last)
    end

    def switch_to_first_window
      @driver.switch_to.window(@driver.window_handles.first)
    end

    def get_number_of_windows
      return @driver.window_handles.length
    end

    def get_current_window_handle
      @driver.window_handle
    end

    def switch_to_window_handle(handle)
      @driver.switch_to.window(handle)
    end

    def wait_for_current_window_to_close(current_window_handle, wait_options = @@default_wait_options)

      if (@driver.window_handles.include?(current_window_handle) == false)
        return
      else
        log_method_step_debug(get_method_name(), "Waiting on current_window_handle to close => #{current_window_handle}")
        wait = Selenium::WebDriver::Wait.new wait_options
        wait.until { @driver.window_handles.include?(current_window_handle) == false }
      end
    end

    def close_current_window
      @driver.close()
    end

    def get_child_web_element(parent_locator_or_element, child_locator)
      begin
        parent_element = resolve_to_element(parent_locator_or_element)
        return parent_element.find_element(child_locator)
      rescue
        return nil
      end
    end

    def resolve_to_element(locator_or_element)
      if locator_or_element.class == Hash then
        get_web_element(locator_or_element)
      else
        locator_or_element
      end
    end

    def get_child_text(parent_locator_or_element, child_locator)
      begin
        parent_element = resolve_to_element(parent_locator_or_element)
        return parent_element.find_element(child_locator).text
      rescue
        return nil
      end
    end

    def click_child(parent_locator_or_element, child_locator)
      begin
        parent_element = resolve_to_element(parent_locator_or_element)
        child = parent_element.find_element(child_locator)
        click_web_element(child)
      rescue
        return nil
      end
    end

    def does_child_web_element_exist?(parent_element, child_locator)
      log_method_step_debug(get_method_name, "Starting: checking if web element exists - #{child_locator}")
      begin
        parent_element.find_element(child_locator)
      rescue Selenium::WebDriver::Error::NoSuchElementError
        return false
      else
        return true
      end
      log_method_step_debug(get_method_name, "Completed: checking if web element exists - #{child_locator}")
    end

    def get_child_web_elements(parent_element, child_locator)
      return parent_element.find_elements(child_locator)
    end

    def element_has_class?(locator_or_element, classname)
      element = resolve_to_element(locator_or_element)
      classes = get_attribute(element, 'class')
      classes.include? classname
    end

    def click_and_hold(locator_or_element)
      element = resolve_to_element(locator_or_element)
      @driver.action.click_and_hold(element).release.perform
    end

    def click_and_hold_with_duration(locator_or_element, hold_duration)
      element = resolve_to_element(locator_or_element)
      @driver.action.click_and_hold(element).perform
      sleep(hold_duration)
      @driver.action.release.perform
    end

    def right_click(locator_or_element)
      element = resolve_to_element(locator_or_element)
      @driver.action.context_click(element).perform
    end

    def click_web_element(webelement)
      if browser_version.to_s == "chrome"
        execute_js("arguments[0].click()", webelement)
      else
        webelement.click
      end
    end

    def get_style_attribute (locator_or_element, style_attribute)
      element = resolve_to_element(locator_or_element)
      element.style(style_attribute)
    end

    def capture_screenshot_on_failure(example)
      name = RSpec.current_example.description.gsub(/[^\w\s_-]+/, '').gsub(/(^|\b\s)\s+($|\s?\b)/, '\\1\\2').gsub(/\s+/, '_')
      unless example.exception.nil?
        example.attach_file(name,
                            @driver.save_screenshot( "log/screenshots/#{name}#{Time.now.strftime("%d_%m_%Y__%H_%M_%S")}.png"))
      end
      quit_webdriver
    end

    def send_keyboard_key(key)
      @driver.action.send_keys(key).perform
    end

    def send_keyboard_keys(primary_key, secondary_key)
      @driver.action.key_down(primary_key).send_keys(secondary_key).perform
      @driver.action.key_up(primary_key).perform
    end

    def update_locator(locator, old_value='', to_replace='', value_to_update='')
      locator.inject({}) { |h, (k, v)| h[k] = v.sub(old_value, to_replace)+value_to_update; h }
    end

    def get_parent_element(child_locator_or_element)
      child_element = resolve_to_element(child_locator_or_element)
      return child_element.find_element(:xpath => "..")
    end

    def browser_setup(browser_name)
      case driver_type
        when 'local'
          @driver = Selenium::WebDriver.for(browser_name.to_sym)
          @driver.manage.timeouts.implicit_wait = Constants::SHORT_TIMEOUT_VALUE
        when 'remote'
          caps = Selenium::WebDriver::Remote::Capabilities.send(browser_name.to_sym)
          @driver = Selenium::WebDriver.for(
              :remote,
              url: "http://#{remote_machine_ip}:4444/wd/hub",
              desired_capabilities: caps)
          @driver.manage.timeouts.implicit_wait = Constants::SHORT_TIMEOUT_VALUE
        when 'phantomjs'
          log_method_step_debug(get_method_name, "Starting: PhantomJS Driver at #{remote_machine_ip}")
          @driver = Selenium::WebDriver.for(
              :remote,
              url: "http://#{remote_machine_ip}:8001")
          @driver.manage.timeouts.implicit_wait = Constants::SHORT_TIMEOUT_VALUE
        else
          caps = Selenium::WebDriver::Remote::Capabilities.send(
              browser_name.to_sym)
          caps.platform = 'Windows 7'
          caps.version = browser_version.to_s

          @driver = Selenium::WebDriver.for(
              :remote,
              url: "http://#{ENV['sbs-qa']}:#{ENV['9243fec2-1d14-4d14-bb87-a101d9a232ad']}
              @ondemand.saucelabs.com:80/wd/hub",
              desired_capabilities: caps)
          @driver.manage.timeouts.implicit_wait = Constants::SHORT_TIMEOUT_VALUE
      end
    end

    def click_element_with_offset(locator_or_element, right_by, down_by)
      element = resolve_to_element(locator_or_element)
      @driver.action.move_to(element, right_by, down_by).perform
      @driver.action.click.perform
    end

    def select_all(locator_or_element)
      element = resolve_to_element(locator_or_element)
      if RUBY_PLATFORM.downcase.include?("darwin")
        element.send_keys([:command, 'a'])
      elsif RUBY_PLATFORM.downcase.include?("mingw32")
        element.send_keys([:control, 'a'])
      end
    end

    def get_web_element_location(locator_or_element)
      element = resolve_to_element(locator_or_element)
      return element.location
    end

    def select_from_dropdown_by_index(element, row_locator, index)
      options = get_child_web_elements(element, row_locator)
      click_web_element(options[index])
    end

    def close_all_windows()
      @driver.window_handles.each do |handle|
        begin
          @driver.switch_to.window(handle)
          @driver.close()
        rescue Exception => e
          log_method_step(get_method_name, "An Error occurred "+e.message)
        end
      end
    end

    def navigate_back()
      @driver.navigate.back
    end

    def get_web_element_location_scrolled_into_view(locator_or_element)
      element = resolve_to_element(locator_or_element)
      return element.location_once_scrolled_into_view
    end

    def capture_screenshot(name = RSpec.current_example.description)
      name = name.gsub(/[^\w\s_-]+/, '').gsub(/(^|\b\s)\s+($|\s?\b)/, '\\1\\2').gsub(/\s+/, '_')
     @driver.save_screenshot( "log/screenshots/#{name}#{Time.now.strftime("%d_%m_%Y__%H_%M_%S")}.png")
    end

    def get_locator_type locator
      element = Hash[locator.map{|(k,v)| [k.to_sym,v]}]
      element.keys.first
    end

    def get_locator_value locator
      element = Hash[locator.map{|(k,v)| [k.to_sym,v]}]
      element.values.first
    end

    def get_css_property(locator,css_property = 'backgroundColor')
     css_property = get_locator_type(locator).eql?(:id) ? execute_js("return $('##{get_locator_value(locator)}').css('#{css_property}')") : execute_js("return $(\"#{get_locator_value locator}\").css(#{css_property})")
     log_method_step(get_method_name,"The css property is "+ css_property.to_s)
     return css_property
    end

    def get_alert_text (wait_seconds = 5)
      for loop_to_wait_for_alert in 1..wait_seconds
        alert = @driver.switch_to.alert rescue Selenium::WebDriver::Error::NoAlertPresentError
        if (alert == Selenium::WebDriver::Error::NoAlertPresentError)
          log_method_step_debug(get_method_name, "Still waiting for alert")
          sleep(1)
          loop_to_wait_for_alert = loop_to_wait_for_alert+1
        else
          log_method_step_debug(get_method_name, "Found the alert")
          return @driver.switch_to.alert.text
        end
      end
    end
  end
end
