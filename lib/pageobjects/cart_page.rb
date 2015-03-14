require_relative '../../spec/spec_helper'

module Walmart
  module Mobile
    module CartPage

      @@cart_page = MobileCartPageObjects.new

      def get_product_name_cart_page
        item_name_in_cart = get_text(@@cart_page.cart_item_name)
        log_method_step(get_method_name, "Current item in cart: #{item_name_in_cart}")
        return item_name_in_cart
      end

      def click_checkout
        click(@@cart_page.checkout_button)
      end

      def remove_items
        all_remove_links = get_web_elements(@@cart_page.remove_item)
        all_remove_links.each do |element|
          click_web_element(element)
        end
      end

      def click_sign_out
        click(@@cart_page.sign_out_link)
      end

      def is_cart_empty?
        is_element_displayed?(@@cart_page.empty_cart)
      end

      def is_only_one_item_in_cart
        text_for_number_of_items = get_text(@@cart_page.item_count)
        if text_for_number_of_items.include? "(1)"
          return true
        else
          return false
        end
      end

    end
  end
end
