require_relative '../../spec/spec_helper'

module Walmart
  module Mobile
    module HomePage

      @@mobile_home_page = MobileHomePageObjects.new

      def set_search_item_field(item_to_be_searched)
        wait_for_element_to_display(@@mobile_home_page.collection)
        wait_for_element_to_display(@@mobile_home_page.search_item_text_field)
        set_text(@@mobile_home_page.search_item_text_field,item_to_be_searched)
      end

      def click_search_go_button
        click(@@mobile_home_page.search_go_button)
      end

    end
  end
end
