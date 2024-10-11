import 'package:flutter/material.dart';
import 'package:store_app/services/shipping_services/shipping_list_service.dart';
import 'package:store_app/services/translate_string_service.dart';
import 'package:store_app/view/shipping_address/add_shipping_address_page.dart';
import 'package:store_app/view/shipping_address/components/my_shipping_address_helper.dart';
import 'package:store_app/view/utils/common_helper.dart';
import 'package:store_app/view/utils/const_strings.dart';
import 'package:store_app/view/utils/constant_colors.dart';
import 'package:store_app/view/utils/constant_styles.dart';
import 'package:store_app/view/utils/others_helper.dart';
import 'package:provider/provider.dart';

class ShippingAddressListPage extends StatelessWidget {
  const ShippingAddressListPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //fetch Address
    Provider.of<ShippingListService>(context, listen: false).fetchAddressList();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: appbarCommon(ConstString.shippingAddress, context, () {
        Navigator.pop(context);
      }),
      body: SingleChildScrollView(
        child: Consumer<TranslateStringService>(
          builder: (context, ln, child) => Consumer<ShippingListService>(
            builder: (context, provider, child) => provider.isloading == false
                ? provider.addressList.isNotEmpty
                    ? Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: screenPadHorizontal, vertical: 20),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              for (int i = 0;
                                  i < provider.addressList.length;
                                  i++)
                                InkWell(
                                  splashColor: Colors.transparent,
                                  highlightColor: Colors.transparent,
                                  onTap: () {},
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 15, vertical: 20),
                                    margin: const EdgeInsets.only(bottom: 15),
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        border: Border.all(
                                          color: borderColor,
                                        ),
                                        borderRadius: BorderRadius.circular(8)),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            SizedBox(
                                              height: 26,
                                              child: Text(
                                                provider.addressList[i]
                                                        .fullName ??
                                                    '',
                                                style: const TextStyle(
                                                    color: greyPrimary,
                                                    fontSize: 14,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ),
                                            InkWell(
                                              onTap: () {
                                                MyDeliveryAddressHelper()
                                                    .deletePopup(
                                                        provider
                                                            .addressList[i].id,
                                                        context);
                                              },
                                              child: Container(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 6),
                                                child: const Icon(
                                                  Icons.delete_outline_outlined,
                                                  color: primaryColor,
                                                  size: 20,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        //Address
                                        paragraphCommon(
                                            '${provider.addressList[i].address} , ${provider.addressList[i].phone}, ${provider.addressList[i].email} ......',
                                            textAlign: TextAlign.start)
                                      ],
                                    ),
                                  ),
                                ),
                            ]),
                      )
                    : nothingfound(context,
                        ln.getString(ConstString.youDontHaveAddressSaved))
                : Container(
                    margin: const EdgeInsets.only(top: 80),
                    child: showLoading(primaryColor),
                  ),
          ),
        ),
      ),
      bottomNavigationBar: Container(
        height: 55,
        margin: const EdgeInsets.only(
          left: 20,
          right: 20,
          bottom: 20,
        ),
        child: buttonPrimary(ConstString.addOrReplaceAddress, () {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => const AddShippingAddressPage()));
        }),
      ),
    );
  }
}
