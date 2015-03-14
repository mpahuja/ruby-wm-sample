require_relative '../../spec/spec_helper'

module Walmart
  module Mobile
    module ProductHelper

      @@product_details = MobileProductDetailsPageObjects.new
      @@common = CommonPageObjects.new

      def get_product_name
        current_product_name = get_child_text(@@product_details.product_name,@@common.h2_tag)
        log_method_step(get_method_name, "Current product name: #{current_product_name}")
        return current_product_name
      end

    end
  end
end