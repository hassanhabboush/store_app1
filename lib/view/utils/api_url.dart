class ApiUrl {
  static const String siteUrl = 'https://www.hexfashion.xyz';
  static String get baseUri => '$siteUrl/api/tenant/v1';

  static final String refundProductsListUri = '$baseUri/user/refund';
  static final String loginUri = '$baseUri/login';
  static final String registerUri = '$baseUri/register';
  static final String logoutUri = '$baseUri/user/logout';
  static final String checkoutUri = '$baseUri/checkout';
  static final String changePassUri = '$baseUri/user/change-password';
  static final String searchItemsUri = '$baseUri/search-items';
  static final String usernameCheckUri = '$baseUri/username';
  static final String sendOtpUri = '$baseUri/send-otp-in-mail';
  static final String otpSuccessUri = '$baseUri/otp-success';
  static final String socialLoginUri = '$baseUri/social-login';
  static final String resetPassUri = '$baseUri/reset-password';
  static final String couponUri = '$baseUri/coupon';
  static final String shippingCostUri = '$baseUri/shipping-charge';
  static final String vatAndShipCostUri = '$baseUri/checkout-calculate?country';
  static final String departmentUri = '$baseUri/user/get-department';
  static final String gatewayListUri = '$baseUri/payment-gateway-list';
  static final String addShippingUri = '$baseUri/user/add-shipping-address';
  static final String stateSearchUri = '$baseUri/search/state';
  static final String citySearchUri = '$baseUri/search/city';
  static final String countrySearchUri = '$baseUri/search/country';
  static final String paymentUpdateUri = '$baseUri/update-payment';
  static final String removeShippingUri =
      '$baseUri/user/shipping-address/delete';
  static final String shipAddressListUri = "$baseUri/user/all-shipping-address";
  static final String ticketPriorityChangeUri =
      '$baseUri/user/ticket/priority-change';
  static final String ticketStatusChangeUri =
      '$baseUri/user/ticket/status-change';
  static final String createTicketUri = '$baseUri/user/ticket/create';
  static final String createRefundTicketUri =
      '$baseUri/user/refund-ticket/create';
  static final String ticketMessageUri = '$baseUri/user/ticket';
  static final String refundTicketMessageUri = '$baseUri/user/refund-ticket';
  static final String ticketMessageSendUri = '$baseUri/user/ticket/chat/send';
  static final String refundTicketMessageSendUri =
      '$baseUri/user/refund-ticket/chat/send';
  static final String ticketListUri = '$baseUri/user/ticket?page';
  static final String refundTicketListUri = '$baseUri/user/refund-ticket?page';
  static final String campaignProductsUri = '$baseUri/campaign/product';
  static final String featuredProductsUri = '$baseUri/featured/product';
  static final String recentProductsUri = '$baseUri/recent/product';
  static final String campaignListUri = '$baseUri/campaign';
  static final String categoryUri = '$baseUri/category';
  static final String childCategoryUri = '$baseUri/child-category';
  static final String stateListUri = '$baseUri/state';
  static final String cityListUri = '$baseUri/city';
  static final String countryListUri = '$baseUri/country';
  static final String currencyUri = '$baseUri/get-currency-symbol';
  static final String discoverProductsUri = '$baseUri/product?name=&page';
  static final String introUri = '$baseUri/mobile-intro';
  static final String privacyPolicyUri = '$baseUri/privacy-policy-page';
  static final String termsUri = '$baseUri/terms-and-condition-page';
  static final String productDetailsUri = '$baseUri/product';
  static final String updateProfileUri = '$baseUri/user/update-profile';
  static final String profileDataUri = '$baseUri/user/profile';
  static final String deleteAccountUri = '$baseUri/user/account/delete';
  static final String rtlUri = '$baseUri/site-currency-symbol';
  static final String languageUri = '$baseUri/language';
  static final String searchUri = '$baseUri/product';
  static final String sliderUri = '$baseUri/mobile-slider';
  static final String subcategoryUri = '$baseUri/subcategory';
  static final String translateUri = '$baseUri/translate-string';
  static final String orderListUri = '$baseUri/user/order';
  static final String refundProductUri = '$baseUri/user/order/refund';
  static final String writeReviewUri = '$baseUri/product-review';
}
