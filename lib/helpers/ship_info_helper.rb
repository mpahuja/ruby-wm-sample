require_relative '../../spec/spec_helper'

module Walmart
  module Mobile
    module ShipInfoHelper

      @@ship_info = MobileShipHomeInfoPageObjects.new
      @@common = CommonPageObjects.new

      def set_shipping_address
        log_method_step(get_method_name,"Starting with #{street_address_1}, #{city}, #{state}, #{zip_code}")
        if is_element_displayed? (@@ship_info.street_address_1)
          set_text(@@ship_info.street_address_1,street_address_1)
          set_text(@@ship_info.zip_code,zip_code)
          set_text(@@ship_info.city,city)
          select_item_from_dropdown(@@ship_info.state,:value,state)
          set_text(@@ship_info.phone_number,phone_number)
          click(@@ship_info.preferred_shipping_address_check_box)
          click(@@common.continue_button)
          wait_for_element_to_not_display(@@ship_info.street_address_1)
        end
        click(@@common.cart_link)
        log_method_step(get_method_name, "Completed..")
      end

    end
  end
end