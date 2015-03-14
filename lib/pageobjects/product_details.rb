require_relative '../../spec/spec_helper'

module Walmart
  module Mobile
    module ProductDetails

      @@product_details = MobileProductDetailsPageObjects.new

      def add_item_to_cart
        wait_for_element_to_display(@@product_details.add_to_cart_button)
        click(@@product_details.add_to_cart_button)
      end

    end
  end
end

