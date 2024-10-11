import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:store_app/services/profile_edit_service.dart';
import 'package:store_app/services/profile_service.dart';
import 'package:store_app/view/utils/common_helper.dart';
import 'package:store_app/view/utils/config.dart';
import 'package:store_app/view/utils/constant_colors.dart';
import 'package:store_app/view/utils/others_helper.dart';
import 'package:provider/provider.dart';

class ProfileImagePick extends StatefulWidget {
  const ProfileImagePick({Key? key}) : super(key: key);

  @override
  State<ProfileImagePick> createState() => _ProfileImagePickState();
}

class _ProfileImagePickState extends State<ProfileImagePick> {
  XFile? pickedImage;

  @override
  Widget build(BuildContext context) {
    return Consumer<ProfileEditService>(
      builder: (context, provider, child) => Consumer<ProfileService>(
        builder: (context, profileProvider, child) =>
            profileProvider.profileDetails != null
                ? Column(
                    children: [
                      //pick profile image
                      InkWell(
                        splashColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                        onTap: () async {
                          pickedImage = await provider.pickImage();
                          setState(() {});
                        },
                        child: Stack(
                          children: [
                            const SizedBox(
                              width: 95,
                              height: 95,
                            ),
                            Container(
                              width: 85,
                              height: 85,
                              alignment: Alignment.center,
                              child: ClipRRect(
                                  borderRadius: BorderRadius.circular(500),
                                  child: pickedImage == null
                                      ? profileProvider
                                                  .profileDetails
                                                  ?.userDetails
                                                  .profileImageUrl !=
                                              null
                                          ? profileImage(
                                              profileProvider
                                                      .profileDetails
                                                      ?.userDetails
                                                      .profileImageUrl ??
                                                  placeHolderUrl,
                                              85,
                                              85)
                                          : Image.asset(
                                              'assets/images/avatar.png',
                                              height: 85,
                                              width: 85,
                                              fit: BoxFit.cover,
                                            )
                                      : Image.file(
                                          File(pickedImage!.path),
                                          height: 85,
                                          width: 85,
                                          fit: BoxFit.cover,
                                        )),
                            ),
                            Positioned(
                              bottom: 9,
                              right: 10,
                              child: Container(
                                alignment: Alignment.center,
                                padding: const EdgeInsets.all(4),
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.white,
                                ),
                                child: const ClipRRect(
                                    child: Icon(
                                  Icons.camera,
                                  color: greyPrimary,
                                )),
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
                  )
                : Container(
                    alignment: Alignment.center,
                    height: MediaQuery.of(context).size.height - 150,
                    child: showLoading(primaryColor),
                  ),
      ),
    );
  }
}
