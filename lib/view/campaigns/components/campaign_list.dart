import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:store_app/services/campaign_service.dart';
import 'package:store_app/services/rtl_service.dart';
import 'package:store_app/view/campaigns/campaign_products_by_category.dart';
import 'package:store_app/view/home/components/section_title.dart';
import 'package:store_app/view/campaigns/components/campaign_timer.dart';
import 'package:store_app/view/utils/config.dart';
import 'package:store_app/view/utils/const_strings.dart';
import 'package:store_app/view/utils/constant_colors.dart';
import 'package:store_app/view/utils/constant_styles.dart';
import 'package:provider/provider.dart';

class CampaignList extends StatefulWidget {
  const CampaignList({
    Key? key,
  }) : super(key: key);

  @override
  State<CampaignList> createState() => _CampaignListState();
}

class _CampaignListState extends State<CampaignList> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<CampaignService>(
      builder: (context, p, child) => p.campaignList.isNotEmpty
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SectionTitle(
                  title: ConstString.saleCampaign,
                  hasSeeAllBtn: false,
                ),
                gapH(15),
                Container(
                  margin: const EdgeInsets.only(top: 5),
                  height: 280,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    shrinkWrap: true,
                    clipBehavior: Clip.none,
                    children: [
                      for (int i = 0; i < p.campaignList.length; i++)
                        InkWell(
                          onTap: (() {
                            Provider.of<CampaignService>(context, listen: false)
                                .fetchCampaignProducts(
                                    context, p.campaignList[i].id);

                            Navigator.push(
                              context,
                              MaterialPageRoute<void>(
                                builder: (BuildContext context) =>
                                    CampaignProductByCategory(
                                  endDate: p.campaignList[i].endDate,
                                ),
                              ),
                            );
                          }),
                          child: Consumer<RtlService>(
                            builder: (context, rtlP, child) => Container(
                              alignment: Alignment.center,
                              width: 300,
                              margin: EdgeInsets.only(
                                right: rtlP.rtl == false ? 20 : 0,
                                left: rtlP.rtl == false ? 0 : 20,
                              ),
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(9)),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Stack(
                                    children: [
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(10),
                                        child: CachedNetworkImage(
                                          height: 140,
                                          width: double.infinity,
                                          imageUrl: p.campaignList[i].image ??
                                              placeHolderUrl,
                                          placeholder: (context, url) => Icon(
                                            Icons.image_outlined,
                                            size: 45,
                                            color: Colors.grey.withOpacity(.4),
                                          ),
                                          errorWidget: (context, url, error) =>
                                              const Icon(Icons.error),
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      gapH(10),
                                      //Title
                                      Text(
                                        '${p.campaignList[i].title}',
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                            color: blackCustomColor,
                                            fontSize: 14,
                                            height: 1.3,
                                            fontWeight: FontWeight.w600),
                                      ),

                                      gapH(15),

                                      CampaignTimer(
                                        remainingTime: DateTime.parse(
                                            "${p.campaignList[i].endDate}"),
                                      )
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        )
                    ],
                  ),
                ),
              ],
            )
          : Container(),
    );
  }
}
