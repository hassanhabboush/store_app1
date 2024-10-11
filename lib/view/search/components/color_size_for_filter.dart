import 'package:flutter/material.dart';
import 'package:store_app/services/filter_color_size_service.dart';
import 'package:store_app/view/utils/common_helper.dart';
import 'package:store_app/view/utils/constant_colors.dart';
import 'package:store_app/view/utils/constant_styles.dart';
import 'package:provider/provider.dart';

class ColorAndSizeForFilter extends StatefulWidget {
  const ColorAndSizeForFilter({Key? key}) : super(key: key);

  @override
  State<ColorAndSizeForFilter> createState() => _ColorAndSizeForFilterState();
}

class _ColorAndSizeForFilterState extends State<ColorAndSizeForFilter> {
  @override
  Widget build(BuildContext context) {
    Provider.of<FilterColorSizeService>(context, listen: false)
        .fetchColorSize(context);

    return Consumer<FilterColorSizeService>(
      builder: (context, p, child) => p.colorSize != null
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                //Size ================>

                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 18,
                    ),
                    paragraphCommon('Size:'),
                    const SizedBox(
                      height: 12,
                    ),
                    Container(
                      decoration: BoxDecoration(
                          color: const Color(0xffF2F4F7),
                          borderRadius: BorderRadius.circular(30)),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 6, vertical: 2),
                      child: Row(
                        children: [
                          for (int i = 0;
                              i < p.colorSize['all_sizes'].length;
                              i++)
                            Row(
                              children: [
                                InkWell(
                                  highlightColor: Colors.transparent,
                                  splashColor: Colors.transparent,
                                  onTap: () {
                                    p.setSizeIndex(i);

                                    p.setSelectedSizeCode(
                                        p.colorSize['all_sizes'][i]
                                            ['size_code']);
                                  },
                                  child: Container(
                                    // margin: EdgeInsets.only(
                                    //     right:
                                    //         i != p.colorSize['all_sizes'].length - 1
                                    //             ? 12
                                    //             : 0),
                                    alignment: Alignment.center,
                                    padding: const EdgeInsets.all(12),
                                    decoration: BoxDecoration(
                                        color: p.selectedSizeIndex == i
                                            ? primaryColor
                                            : Colors.white,
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                            color: p.selectedSizeIndex == i
                                                ? Colors.transparent
                                                : greyFive)),
                                    child: Text(
                                      "${p.colorSize['all_sizes'][i]['size_code']}",
                                      style: TextStyle(
                                          color: p.selectedSizeIndex == i
                                              ? Colors.white
                                              : greyParagraph,
                                          fontSize: 13,
                                          fontWeight: FontWeight.w600),
                                    ),
                                  ),
                                ),
                                gapW(12),
                              ],
                            )
                        ],
                      ),
                    ),
                  ],
                ),
                //color ============>
                gapH(15),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    paragraphCommon('Color:'),
                    gapH(12),
                  ],
                ),

                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 6, vertical: 6),
                  decoration: BoxDecoration(
                      color: const Color(0xffF2F4F7),
                      borderRadius: BorderRadius.circular(30)),
                  child: Row(
                    children: [
                      for (int i = 0; i < p.colorSize['all_colors'].length; i++)
                        Row(
                          children: [
                            InkWell(
                              highlightColor: Colors.transparent,
                              splashColor: Colors.transparent,
                              onTap: () {
                                p.setColorIndex(i);
                                p.setSelectedColorName(
                                    p.colorSize['all_colors'][i]['name']);
                              },
                              child: Container(
                                // margin: EdgeInsets.only(
                                //     right: i != p.colorSize['all_colors'].length - 1
                                //         ? 10
                                //         : 0),
                                height: 35,
                                width: 35,
                                decoration: BoxDecoration(
                                    color: Color(int.parse(p
                                        .colorSize['all_colors'][i]
                                            ['color_code']
                                        .replaceAll('#', '0xff'))),
                                    shape: BoxShape.circle),
                                child: p.selectedColorIndex == i
                                    ? const Icon(
                                        Icons.check,
                                        color: Colors.white,
                                        size: 20,
                                      )
                                    : Container(),
                              ),
                            ),
                            gapW(10),
                          ],
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
