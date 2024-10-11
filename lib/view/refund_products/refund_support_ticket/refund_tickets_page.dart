// ignore_for_file: use_build_context_synchronously

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:store_app/services/refund_ticket_service/refund_ticket_service.dart';
import 'package:store_app/services/translate_string_service.dart';
import 'package:store_app/view/refund_products/refund_support_ticket/create_refund_ticket_page.dart';
import 'package:store_app/view/utils/common_helper.dart';
import 'package:store_app/view/utils/const_strings.dart';
import 'package:store_app/view/utils/constant_colors.dart';
import 'package:store_app/view/utils/constant_styles.dart';
import 'package:store_app/view/utils/responsive.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class RefundTicketsPage extends StatefulWidget {
  const RefundTicketsPage({Key? key}) : super(key: key);

  @override
  _RefundTicketsPageState createState() => _RefundTicketsPageState();
}

class _RefundTicketsPageState extends State<RefundTicketsPage> {
  @override
  void initState() {
    super.initState();
  }

  final RefreshController refreshController =
      RefreshController(initialRefresh: true);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          systemOverlayStyle: SystemUiOverlayStyle.dark,
          iconTheme: const IconThemeData(color: greyPrimary),
          title: Consumer<TranslateStringService>(
            builder: (context, ln, child) => Text(
              ln.getString(ConstString.refundTickets),
              style: const TextStyle(
                  color: greyPrimary,
                  fontSize: 16,
                  fontWeight: FontWeight.w600),
            ),
          ),
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child: const Icon(
              Icons.arrow_back_ios,
              size: 18,
            ),
          ),
          actions: [
            Consumer<TranslateStringService>(
              builder: (context, ln, child) => Container(
                width: getScreenWidth(context) / 4,
                padding: const EdgeInsets.symmetric(
                  vertical: 9,
                ),
                margin: const EdgeInsets.symmetric(horizontal: 25),
                child: InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute<void>(
                        builder: (BuildContext context) =>
                            const CreateRefundTicketPage(),
                      ),
                    );
                  },
                  child: Container(
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          color: primaryColor,
                          borderRadius: BorderRadius.circular(8)),
                      child: AutoSizeText(
                        ln.getString(ConstString.create),
                        maxLines: 1,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 13,
                        ),
                      )),
                ),
              ),
            )
          ],
        ),
        body: SmartRefresher(
          controller: refreshController,
          enablePullUp: true,
          enablePullDown: context.watch<RefundTicketService>().currentPage > 1
              ? false
              : true,
          onRefresh: () async {
            final result =
                await Provider.of<RefundTicketService>(context, listen: false)
                    .fetchTicketList(context);
            if (result) {
              refreshController.refreshCompleted();
            } else {
              refreshController.refreshFailed();
            }
          },
          onLoading: () async {
            final result =
                await Provider.of<RefundTicketService>(context, listen: false)
                    .fetchTicketList(context);
            if (result) {
              debugPrint('loadcomplete ran');
              //loadcomplete function loads the data again
              refreshController.loadComplete();
            } else {
              debugPrint('no more data');
              refreshController.loadNoData();

              Future.delayed(const Duration(seconds: 1), () {
                //it will reset footer no data state to idle and will let us load again
                refreshController.resetNoData();
              });
            }
          },
          child: SingleChildScrollView(
            child: Consumer<RefundTicketService>(
                builder: (context, provider, child) => provider
                        .ticketList.isNotEmpty
                    ? Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: screenPadHorizontal),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            for (int i = 0; i < provider.ticketList.length; i++)
                              InkWell(
                                onTap: () {
                                  provider.goToMessagePage(
                                    context,
                                    provider.ticketList[i]['subject'],
                                    provider.ticketList[i]['id'],
                                  );
                                },
                                child: Container(
                                  alignment: Alignment.center,
                                  margin: const EdgeInsets.only(
                                    top: 20,
                                    bottom: 3,
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 15, vertical: 15),
                                  decoration: BoxDecoration(
                                      border: Border.all(color: borderColor),
                                      borderRadius: BorderRadius.circular(5)),
                                  child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            AutoSizeText(
                                              '#${provider.ticketList[i]['id']}',
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              style: const TextStyle(
                                                color: primaryColor,
                                              ),
                                            ),
                                          ],
                                        ),

                                        //Ticket title
                                        const SizedBox(
                                          height: 7,
                                        ),
                                        titleCommon(
                                            provider.ticketList[i]['subject']),

                                        //Divider
                                        Container(
                                          margin: const EdgeInsets.only(
                                              top: 17, bottom: 12),
                                          child: dividerCommon(),
                                        ),
                                        //Capsules
                                        Row(
                                          children: [
                                            capsule(provider.ticketList[i]
                                                    ['status']
                                                .toString())
                                          ],
                                        )
                                      ]),
                                ),
                              )
                          ],
                        ),
                      )
                    : nothingfound(context, ConstString.noTicketFound)),
          ),
        ));
  }

  // List popupMenuTexts = ['Chat', 'Change priority', 'Change status'];

  // popupMenuActions(int i, provider, {required ticketId}) {
  //   if (i == 0) {
  //     provider.goToMessagePage(context, provider.ticketList[i]['subject'],
  //         provider.ticketList[i]['id']);
  //   } else if (i == 1) {
  //     SupportTicketHelper().changePriorityPopup(context, ticketId);
  //   } else if (i == 2) {
  //     SupportTicketHelper().changeStatusPopup(context, ticketId);
  //   }
  // }
}
