import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:store_app/services/translate_string_service.dart';
import 'package:store_app/services/write_review_service.dart';
import 'package:store_app/view/utils/const_strings.dart';
import 'package:store_app/view/utils/others_helper.dart';
import 'package:store_app/view/utils/textarea_field.dart';
import 'package:store_app/view/utils/common_helper.dart';
import 'package:store_app/view/utils/constant_colors.dart';
import 'package:store_app/view/utils/constant_styles.dart';
import 'package:provider/provider.dart';

class WriteReviewPage extends StatefulWidget {
  const WriteReviewPage({
    Key? key,
    required this.productId,
  }) : super(key: key);

  final productId;
  @override
  State<WriteReviewPage> createState() => _WriteReviewPageState();
}

class _WriteReviewPageState extends State<WriteReviewPage> {
  double rating = 1;
  TextEditingController reviewController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: appbarCommon(ConstString.writeReview, context, () {
        Navigator.pop(context);
      }),
      body: SingleChildScrollView(
        child: Consumer<TranslateStringService>(
          builder: (context, ln, child) => Container(
            padding: EdgeInsets.symmetric(horizontal: screenPadHorizontal),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const SizedBox(
                height: 15,
              ),
              RatingBar.builder(
                initialRating: 1,
                minRating: 1,
                direction: Axis.horizontal,
                allowHalfRating: false,
                itemCount: 5,
                itemPadding: const EdgeInsets.symmetric(horizontal: 3.0),
                itemSize: 32,
                unratedColor: greyFive,
                itemBuilder: (context, _) => const Icon(
                  Icons.star_rounded,
                  color: Colors.amber,
                ),
                onRatingUpdate: (value) {
                  rating = value;
                  print(rating);
                },
              ),
              gapH(20),
              Text(
                ln.getString(ConstString.howWasProduct) + '?',
                style: const TextStyle(
                    color: greyFour, fontSize: 15, fontWeight: FontWeight.w600),
              ),
              const SizedBox(
                height: 14,
              ),
              TextareaField(
                notesController: reviewController,
                hintText: ln.getString(ConstString.writeReview),
              ),
              gapH(20),
              Consumer<WriteReviewService>(
                builder: (context, lfProvider, child) =>
                    buttonPrimary(ConstString.postReview, () {
                  if (reviewController.text.isEmpty) {
                    showSnackBar(
                        context, 'Please write something first', Colors.red);
                    return;
                  }
                  if (lfProvider.isloading == false) {
                    lfProvider.leaveFeedback(context,
                        comment: reviewController.text,
                        productId: widget.productId,
                        rating: rating);
                  }
                }, isloading: lfProvider.isloading),
              )
            ]),
          ),
        ),
      ),
    );
  }
}
