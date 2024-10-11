import 'package:flutter/material.dart';
import 'package:store_app/services/common_service.dart';
import 'package:store_app/services/dropdown_services/city_dropdown_services.dart';
import 'package:store_app/services/dropdown_services/country_dropdown_service.dart';
import 'package:store_app/services/dropdown_services/state_dropdown_services.dart';
import 'package:store_app/services/profile_edit_service.dart';
import 'package:store_app/services/profile_service.dart';
import 'package:store_app/services/shipping_services/add_remove_shipping_address_service.dart';
import 'package:store_app/services/translate_string_service.dart';
import 'package:store_app/view/auth/signup/dropdowns/country_states_dropdowns.dart';
import 'package:store_app/view/utils/common_helper.dart';
import 'package:store_app/view/utils/const_strings.dart';
import 'package:store_app/view/utils/constant_styles.dart';
import 'package:store_app/view/utils/custom_input.dart';
import 'package:store_app/view/utils/others_helper.dart';
import 'package:provider/provider.dart';

class AddShippingAddressPage extends StatefulWidget {
  const AddShippingAddressPage({Key? key}) : super(key: key);

  @override
  State<AddShippingAddressPage> createState() => _AddShippingAddressPageState();
}

class _AddShippingAddressPageState extends State<AddShippingAddressPage> {
  TextEditingController shippingNameController = TextEditingController();
  TextEditingController fullNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController zipCodeController = TextEditingController();
  TextEditingController addressController = TextEditingController();

  // String? countryCode;

  late AnimationController localAnimationController;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();

    fullNameController.text =
        Provider.of<ProfileService>(context, listen: false)
                .profileDetails
                ?.userDetails
                .name ??
            '';

    emailController.text = Provider.of<ProfileService>(context, listen: false)
            .profileDetails
            ?.userDetails
            .email ??
        '';

    phoneController.text = Provider.of<ProfileService>(context, listen: false)
            .profileDetails
            ?.userDetails
            .mobile ??
        '';
    // zipCodeController.text = Provider.of<ProfileService>(context, listen: false)
    //         .profileDetails
    //         ?.userDetails
    //         .po ??
    //     '';
    addressController.text = Provider.of<ProfileService>(context, listen: false)
            .profileDetails
            ?.userDetails
            .address ??
        '';
    zipCodeController.text = Provider.of<ProfileService>(context, listen: false)
            .profileDetails
            ?.userDetails
            .postalCode ??
        '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: appbarCommon('', context, () {
        Provider.of<ProfileEditService>(context, listen: false).setDefault();
        Navigator.pop(context);
      }, centerTitle: false),
      body: WillPopScope(
        onWillPop: () {
          return Future.value(true);
        },
        child: Listener(
          onPointerDown: (_) {
            hideKeyboard(context);
          },
          child: SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.symmetric(
                  horizontal: screenPadHorizontal, vertical: 10),
              child: Consumer<TranslateStringService>(
                builder: (context, ln, child) =>
                    Consumer<AddRemoveShippingAddressService>(
                  builder: (context, provider, child) => Form(
                    key: _formKey,
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          //Name ============>
                          // labelCommon(ConstString.shippingName),

                          // CustomInput(
                          //   controller: shippingNameController,
                          //   validation: (value) {
                          //     if (value == null || value.isEmpty) {
                          //       return ln.getString(
                          //           ConstString.plzEnterShippingName);
                          //     }
                          //     return null;
                          //   },
                          //   hintText:
                          //       ln.getString(ConstString.enterShippingName),
                          //   paddingHorizontal: 20,
                          //   textInputAction: TextInputAction.next,
                          // ),

                          //Name ============>
                          labelCommon(ConstString.fullName),

                          CustomInput(
                            controller: fullNameController,
                            validation: (value) {
                              if (value == null || value.isEmpty) {
                                return ln
                                    .getString(ConstString.plzEnterFullName);
                              }
                              return null;
                            },
                            hintText: ln.getString(ConstString.enterFullName),
                            paddingHorizontal: 20,
                            textInputAction: TextInputAction.next,
                          ),

                          labelCommon(ConstString.email),
                          CustomInput(
                            controller: emailController,
                            validation: (value) {
                              if (value == null || value.isEmpty) {
                                return ln.getString(ConstString.plzEnterEmail);
                              }
                              return null;
                            },
                            hintText: ln.getString(ConstString.enterEmail),
                            paddingHorizontal: 20,
                            textInputAction: TextInputAction.next,
                          ),

                          //Phone
                          labelCommon(ConstString.phone),
                          CustomInput(
                            controller: phoneController,
                            validation: (value) {
                              if (value == null || value.isEmpty) {
                                return ln.getString(ConstString.plzEnterPhone);
                              }
                              return null;
                            },
                            hintText:
                                ln.getString(ConstString.enterPhoneNumber),
                            paddingHorizontal: 20,
                            textInputAction: TextInputAction.next,
                            isNumberField: true,
                          ),

                          //City
                          // labelCommon(ConstString.city),
                          // CustomInput(
                          //   controller: cityController,
                          //   validation: (value) {
                          //     if (value == null || value.isEmpty) {
                          //       return ln
                          //           .getString(ConstString.plzEnterYourCity);
                          //     }
                          //     return null;
                          //   },
                          //   hintText: ln.getString(ConstString.enterYourCity),
                          //   paddingHorizontal: 20,
                          //   textInputAction: TextInputAction.next,
                          // ),

                          const CountryStatesDropdowns(),

                          // Zip ======>
                          gapH(18),
                          labelCommon(ConstString.zipCode),
                          CustomInput(
                            controller: zipCodeController,
                            isNumberField: true,
                            validation: (value) {
                              if (value == null || value.isEmpty) {
                                return ln.getString(ConstString.plzEnterZip);
                              }
                              return null;
                            },
                            hintText: ln.getString(ConstString.enterZip),
                            paddingHorizontal: 20,
                            textInputAction: TextInputAction.next,
                          ),

                          // Address ======>
                          labelCommon(ConstString.address),
                          CustomInput(
                            controller: addressController,
                            validation: (value) {
                              if (value == null || value.isEmpty) {
                                return ln
                                    .getString(ConstString.plzEnterAddress);
                              }
                              return null;
                            },
                            hintText: ln.getString(ConstString.enterAddress),
                            paddingHorizontal: 20,
                            textInputAction: TextInputAction.next,
                          ),
                          const SizedBox(
                            height: 8,
                          ),

                          buttonPrimary(ConstString.save, () async {
                            if (provider.isloading == false) {
                              if (_formKey.currentState!.validate()) {
                                var countryProvider =
                                    Provider.of<CountryDropdownService>(context,
                                        listen: false);
                                var stateProvider =
                                    Provider.of<StateDropdownService>(context,
                                        listen: false);

                                if (countryProvider.selectedCountryId ==
                                        defaultId ||
                                    stateProvider.selectedStateId ==
                                        defaultId) {
                                  showToast(
                                      ln.getString(
                                          ConstString.mustSelectCountryState),
                                      Colors.black);
                                  return;
                                }

                                await provider.addAddress(
                                  context,
                                  shippingName:
                                      shippingNameController.text.trim(),
                                  name: fullNameController.text.trim(),
                                  email: emailController.text.trim(),
                                  phone: phoneController.text.trim(),
                                  zip: zipCodeController.text.trim(),
                                  address: addressController.text.trim(),
                                  // city: cityController.text.trim()
                                );
                              }
                            }
                          }, isloading: provider.isloading, borderRadius: 100),

                          gapH(25)
                        ]),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
