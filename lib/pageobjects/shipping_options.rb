require_relative '../../spec/spec_helper'

module Walmart
  module Mobile
    module ShippingOptions

      @@shipping_options = MobileShippingOptionsPageObjects.new
      @@common = CommonPageObjects.new

      def click_continue_on_shipping_page
        click(@@common.continue_button)
        wait_for_element_to_not_display(@@shipping_options.item_description_in_cart)
      end

      def get_product_name_in_cart
        product_name_in_cart = get_child_text(@@shipping_options.item_description_in_cart, @@common.div_tag)
        log_method_step(get_method_name,"Product name in cart: #{product_name_in_cart}")
        return product_name_in_cart
      end

      def select_ship_to_home
        radio_buttons = get_web_elements(@@shipping_options.radio_button_options)
        click_web_element(radio_buttons[0])
      end

    end
  end
end
