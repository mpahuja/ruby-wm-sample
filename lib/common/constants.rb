module Constants

  Mobile_Home_Page_Object = "lib/uilocators/mobile_home_page.yml"
  Mobile_Search_Results_Page_Object = "lib/uilocators/mobile_search_results.yml"
  Mobile_Product_Details_Page_Object = "lib/uilocators/mobile_product_details.yml"
  Mobile_Cart_Page_Object = "lib/uilocators/mobile_cart_page.yml"
  Mobile_Sign_In_Page_Object = "lib/uilocators/mobile_sign_in.yml"
  Common_Page_Objects = "lib/uilocators/common.yml"
  Mobile_Shipping_Options_Page_Objects = "lib/uilocators/mobile_shipping_options.yml"
  Mobile_Ship_Home_Info_Page_Objects = "lib/uilocators/mobile_ship_home_info.yml"

  #Timeouts
  TINY_TIMEOUT_VALUE = 3
  TINY_TIMEOUT = {:timeout => TINY_TIMEOUT_VALUE}
  SHORT_TIMEOUT_VALUE = 10
  SHORT_TIMEOUT = {:timeout => SHORT_TIMEOUT_VALUE}
  LONG_TIMEOUT_VALUE = 60
  LONG_TIMEOUT = {:timeout => LONG_TIMEOUT_VALUE}
  HUGE_TIMEOUT_VALUE = 120
  HUGE_TIMEOUT = {:timeout => HUGE_TIMEOUT_VALUE}
  FIFTEEN_SECOND_TIMEOUT_VALUE = 15
  FIFTEEN_SECOND_TIMEOUT = {:timeout => FIFTEEN_SECOND_TIMEOUT_VALUE}
  SIXTY_SECOND_TIMEOUT_VALUE = 60
  SIXTY_SECOND_TIMEOUT = {:timeout => SIXTY_SECOND_TIMEOUT_VALUE}
  CONFIG_PROPERTIES = "config/config.properties"
end
