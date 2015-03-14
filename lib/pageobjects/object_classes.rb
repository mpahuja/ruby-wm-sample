require_relative '../../spec/spec_helper'
require_relative '../../lib/common/yaml_properties_holder'

class MobileHomePageObjects
  def self.properties_file
    Constants.const_get(:Mobile_Home_Page_Object)
  end
  extend YAMLPropertiesHolder
end

class MobileSearchResultsPageObjects
  def self.properties_file
    Constants.const_get(:Mobile_Search_Results_Page_Object)
  end
  extend YAMLPropertiesHolder
end

class MobileProductDetailsPageObjects
  def self.properties_file
    Constants.const_get(:Mobile_Product_Details_Page_Object)
  end
  extend YAMLPropertiesHolder
end

class MobileCartPageObjects
  def self.properties_file
    Constants.const_get(:Mobile_Cart_Page_Object)
  end
  extend YAMLPropertiesHolder
end

class MobileSignInPageObjects
  def self.properties_file
    Constants.const_get(:Mobile_Sign_In_Page_Object)
  end
  extend YAMLPropertiesHolder
end

class CommonPageObjects
  def self.properties_file
    Constants.const_get(:Common_Page_Objects)
  end
  extend YAMLPropertiesHolder
end

class MobileShippingOptionsPageObjects
  def self.properties_file
    Constants.const_get(:Mobile_Shipping_Options_Page_Objects)
  end
  extend YAMLPropertiesHolder
end

class MobileShipHomeInfoPageObjects
  def self.properties_file
    Constants.const_get(:Mobile_Ship_Home_Info_Page_Objects)
  end
  extend YAMLPropertiesHolder
end

