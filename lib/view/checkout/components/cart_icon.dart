import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:store_app/services/cart_services/cart_service.dart';
import 'package:store_app/services/cart_services/delivery_address_service.dart';
import 'package:store_app/services/dropdown_services/country_dropdown_service.dart';
import 'package:store_app/view/checkout/cart_page.dart';
import 'package:store_app/view/utils/constant_colors.dart';
import 'package:provider/provider.dart';

import '../../../services/dropdown_services/city_dropdown_services.dart';
import '../../../services/dropdown_services/state_dropdown_services.dart';
import '../../../services/profile_service.dart';

class CartIcon extends StatelessWidget {
  const CartIcon({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Provider.of<DeliveryAddressService>(context, listen: false)
            .cleatDeliveryAddress();
        final productDetails =
            Provider.of<ProfileService>(context, listen: false).profileDetails;

        Provider.of<CountryDropdownService>(context, listen: false)
            .setSelectedCountryId(
                productDetails?.userDetails.deliveryAddress?.countryId);
        // Provider.of<CountryDropdownService>(context, listen: false)
        //     .setCountryValue(productDetails?.userDetails.userCountry?.name);
        Provider.of<StateDropdownService>(context, listen: false)
            .setSelectedStatesId(
                productDetails?.userDetails.deliveryAddress?.stateId);
        // Provider.of<StateDropdownService>(context, listen: false)
        //     .setStatesValue(productDetails?.userDetails.userState?.name);
        Provider.of<CityDropdownService>(context, listen: false)
            .setSelectedCityId(
                productDetails?.userDetails.deliveryAddress?.city);
        // Provider.of<CityDropdownService>(context, listen: false)
        //     .setSelectedCityId(productDetails?.userDetails.city?.id);

        Provider.of<DeliveryAddressService>(context, listen: false)
            .fetchCountryStateShippingCost(context);
        // Provider.of<CountryDropdownService>(context, listen: false)
        //     .setDefault(context: context);
        Navigator.push(
          context,
          MaterialPageRoute<void>(
            builder: (BuildContext context) => const Cartpage(),
          ),
        );
      },
      child: Consumer<CartService>(
        builder: (context, p, child) => Stack(
          clipBehavior: Clip.none,
          alignment: Alignment.centerRight,
          children: [
            Container(
              padding: const EdgeInsets.only(left: 20, top: 5, bottom: 5),
              child: SvgPicture.asset(
                'assets/svg/cart.svg',
                height: 27,
              ),
            ),
            if (p.totalQty > 0)
              Positioned(
                  top: -5,
                  right: -10,
                  child: Container(
                    padding: const EdgeInsets.all(7),
                    decoration: const BoxDecoration(
                        shape: BoxShape.circle, color: primaryColor),
                    child: Text(
                      '${p.totalQty}',
                      style: const TextStyle(color: Colors.white, fontSize: 13),
                    ),
                  ))
          ],
        ),
      ),
    );
  }
}
