require_relative '../../spec/spec_helper'

module Walmart
  module Mobile
    module SearchHelper

      @@search_results_page = MobileSearchResultsPageObjects.new

      def click_first_item_on_search
        wait_for_element_to_display(@@search_results_page.search_result_items)
        all_items = get_web_elements(@@search_results_page.search_result_items)
        click_web_element(all_items[1])
      end

    end
  end
end
