import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:store_app/services/dropdown_services/country_dropdown_service.dart';
import 'package:store_app/services/featured_product_service.dart';
import 'package:store_app/services/filter_color_size_service.dart';
import 'package:store_app/services/order_service.dart';
import 'package:store_app/services/payment_services/bank_transfer_service.dart';
import 'package:store_app/services/place_order_service.dart';
import 'package:store_app/services/product_by_category_service.dart';
import 'package:store_app/services/recent_product_service.dart';
import 'package:store_app/services/refund_products_service.dart';
import 'package:store_app/services/refund_ticket_service/create_refund_ticket_service.dart';
import 'package:store_app/services/refund_ticket_service/refund_ticket_messages_service.dart';
import 'package:store_app/services/refund_ticket_service/refund_ticket_service.dart';
import 'package:store_app/services/translate_string_service.dart';
import 'package:store_app/services/auth_services/change_pass_service.dart';
import 'package:store_app/services/auth_services/email_verify_service.dart';
import 'package:store_app/services/auth_services/facebook_login_service.dart';
import 'package:store_app/services/auth_services/google_sign_service.dart';
import 'package:store_app/services/auth_services/login_service.dart';
import 'package:store_app/services/auth_services/logout_service.dart';
import 'package:store_app/services/auth_services/reset_password_service.dart';
import 'package:store_app/services/auth_services/signup_service.dart';
import 'package:store_app/services/bottom_nav_service.dart';
import 'package:store_app/services/campaign_service.dart';
import 'package:store_app/services/category_service.dart';
import 'package:store_app/services/child_category_service.dart';
import 'package:store_app/services/cart_services/favourite_service.dart';
import 'package:store_app/services/dropdown_services/priority_and_department_dropdown_service.dart';
import 'package:store_app/services/dropdown_services/ticket_status_dropdown_service.dart';
import 'package:store_app/services/intro_service.dart';
import 'package:store_app/services/payment_services/payment_gateway_list_service.dart';
import 'package:store_app/services/privacy_terms_service.dart';
import 'package:store_app/services/product_details_service.dart';
import 'package:store_app/services/profile_edit_service.dart';
import 'package:store_app/services/profile_service.dart';
import 'package:store_app/services/rtl_service.dart';
import 'package:store_app/services/search_product_service.dart';
import 'package:store_app/services/shipping_services/add_remove_shipping_address_service.dart';
import 'package:store_app/services/slider_service.dart';
import 'package:store_app/services/subcategory_service.dart';
import 'package:store_app/services/ticket_services/change_priority_service.dart';
import 'package:store_app/services/ticket_services/change_ticket_status_service.dart';
import 'package:store_app/services/write_review_service.dart';
import 'package:store_app/view/intro/splash.dart';
import 'package:store_app/services/shipping_services/shipping_list_service.dart';
import 'package:store_app/view/utils/constant_colors.dart';
import 'package:provider/provider.dart';
import 'services/cart_services/cart_service.dart';
import 'services/cart_services/coupon_service.dart';
import 'services/cart_services/delivery_address_service.dart';
import 'services/dropdown_services/city_dropdown_services.dart';
import 'services/dropdown_services/state_dropdown_services.dart';
import 'services/ticket_services/create_ticket_service.dart';
import 'services/ticket_services/support_messages_service.dart';
import 'services/ticket_services/support_ticket_service.dart';

void main() {
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent, // transparent status bar
    statusBarIconBrightness: Brightness.dark,
  ));

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => LoginService()),
        ChangeNotifierProvider(create: (_) => SignupService()),
        ChangeNotifierProvider(create: (_) => CountryDropdownService()),
        ChangeNotifierProvider(create: (_) => StateDropdownService()),
        ChangeNotifierProvider(create: (_) => ProfileService()),
        ChangeNotifierProvider(create: (_) => ChangePassService()),
        ChangeNotifierProvider(create: (_) => EmailVerifyService()),
        ChangeNotifierProvider(create: (_) => LogoutService()),
        ChangeNotifierProvider(create: (_) => ResetPasswordService()),
        ChangeNotifierProvider(create: (_) => TranslateStringService()),
        ChangeNotifierProvider(create: (_) => GoogleSignInService()),
        ChangeNotifierProvider(create: (_) => FacebookLoginService()),
        ChangeNotifierProvider(create: (_) => RtlService()),
        ChangeNotifierProvider(create: (_) => CategoryService()),
        ChangeNotifierProvider(create: (_) => SliderService()),
        ChangeNotifierProvider(create: (_) => CouponService()),
        ChangeNotifierProvider(create: (_) => PaymentGatewayListService()),
        ChangeNotifierProvider(create: (_) => DeliveryAddressService()),
        ChangeNotifierProvider(create: (_) => BankTransferService()),
        ChangeNotifierProvider(create: (_) => CartService()),
        ChangeNotifierProvider(create: (_) => SearchProductService()),
        ChangeNotifierProvider(create: (_) => FavouriteService()),
        ChangeNotifierProvider(create: (_) => ProfileEditService()),
        ChangeNotifierProvider(create: (_) => BottomNavService()),
        ChangeNotifierProvider(create: (_) => SubCategoryService()),
        ChangeNotifierProvider(create: (_) => ChildCategoryService()),
        ChangeNotifierProvider(create: (_) => ProductDetailsService()),
        ChangeNotifierProvider(create: (_) => SupportTicketService()),
        ChangeNotifierProvider(create: (_) => CreateTicketService()),
        ChangeNotifierProvider(create: (_) => SupportMessagesService()),
        ChangeNotifierProvider(create: (_) => TicketStatusDropdownService()),
        ChangeNotifierProvider(create: (_) => ChangePriorityService()),
        ChangeNotifierProvider(create: (_) => ChangeTicketStatusService()),
        ChangeNotifierProvider(create: (_) => ShippingListService()),
        ChangeNotifierProvider(create: (_) => CampaignService()),
        ChangeNotifierProvider(create: (_) => PrivacyTermsService()),
        ChangeNotifierProvider(create: (_) => IntroService()),
        ChangeNotifierProvider(create: (_) => RefundProductsService()),
        ChangeNotifierProvider(create: (_) => OrderService()),
        ChangeNotifierProvider(create: (_) => RefundTicketService()),
        ChangeNotifierProvider(create: (_) => CreateRefundTicketService()),
        ChangeNotifierProvider(create: (_) => RefundTicketMessagesService()),
        ChangeNotifierProvider(create: (_) => PlaceOrderService()),
        ChangeNotifierProvider(create: (_) => FeaturedProductService()),
        ChangeNotifierProvider(create: (_) => ProductByCategoryService()),
        ChangeNotifierProvider(create: (_) => FilterColorSizeService()),
        ChangeNotifierProvider(create: (_) => RecentProductService()),
        ChangeNotifierProvider(create: (_) => WriteReviewService()),
        ChangeNotifierProvider(create: (_) => CityDropdownService()),
        ChangeNotifierProvider(
            create: (_) => AddRemoveShippingAddressService()),
        ChangeNotifierProvider(
            create: (_) => PriorityAndDepartmentDropdownService()),
      ],
      child: MaterialApp(
        title: 'Nazmart',
        builder: (context, rtlchild) {
          return Consumer<RtlService>(
            builder: (context, rtlP, child) => Directionality(
              textDirection:
                  rtlP.rtl == false ? TextDirection.ltr : TextDirection.rtl,
              child: rtlchild!,
            ),
          );
        },
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          pageTransitionsTheme: const PageTransitionsTheme(builders: {
            TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
            TargetPlatform.android: ZoomPageTransitionsBuilder(),
          }),
          primarySwatch: Colors.blue,
          scaffoldBackgroundColor: Colors.white,
          appBarTheme: const AppBarTheme(
            backgroundColor: Colors.blue,
            systemOverlayStyle: SystemUiOverlayStyle.dark,
          ),
          buttonTheme: const ButtonThemeData(buttonColor: primaryColor),
          textSelectionTheme:
              const TextSelectionThemeData(cursorColor: primaryColor),
        ),
        home: const SplashScreen(),
      ),
    );
  }
}
