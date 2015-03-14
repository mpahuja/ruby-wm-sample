require_relative '../../spec/spec_helper'

module Walmart
  module Mobile
    module SignInHelper

      @@signin_page = MobileSignInPageObjects.new

      def login_existing_account(email_address,password)
        set_text(@@signin_page.email,email_address)
        set_text(@@signin_page.password,password)
        click(@@signin_page.signin_button)
        wait_for_element_to_not_display(@@signin_page.password,password)
      end

    end
  end
end