// ignore_for_file: prefer_typing_uninitialized_variables

import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:image_picker/image_picker.dart';
import 'package:store_app/services/refund_ticket_service/refund_ticket_messages_service.dart';
import 'package:store_app/services/translate_string_service.dart';
import 'package:store_app/view/support_ticket/components/image_big_preview.dart';
import 'package:store_app/view/utils/config.dart';
import 'package:store_app/view/utils/const_strings.dart';
import 'package:store_app/view/utils/constant_colors.dart';
import 'package:store_app/view/utils/others_helper.dart';
import 'package:store_app/view/utils/responsive.dart';
import 'package:provider/provider.dart';

class RefundTicketChatPage extends StatefulWidget {
  const RefundTicketChatPage({
    Key? key,
    required this.title,
    required this.ticketId,
  }) : super(key: key);

  final String title;
  final ticketId;

  @override
  State<RefundTicketChatPage> createState() => _RefundTicketChatPageState();
}

class _RefundTicketChatPageState extends State<RefundTicketChatPage> {
  bool firstTimeLoading = true;

  TextEditingController sendMessageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  void _scrollDown() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent + 150,
        duration: const Duration(milliseconds: 500),
        curve: Curves.fastOutSlowIn,
      );
    }
  }

  XFile? pickedFile;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        systemOverlayStyle: SystemUiOverlayStyle.dark,
        elevation: 0,
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        flexibleSpace: SafeArea(
          child: Container(
            padding: const EdgeInsets.only(right: 16, left: 8),
            child: Row(
              children: <Widget>[
                IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: const Icon(
                    Icons.arrow_back_ios,
                    color: greyParagraph,
                  ),
                ),
                const SizedBox(
                  width: 14,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        widget.title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(
                        height: 4,
                      ),
                      Text(
                        "#${widget.ticketId}",
                        style:
                            const TextStyle(color: primaryColor, fontSize: 13),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      body: Listener(
        onPointerDown: (_) {
          FocusScopeNode currentFocus = FocusScope.of(context);
          if (!currentFocus.hasPrimaryFocus) {
            currentFocus.focusedChild?.unfocus();
          }
        },
        child: Consumer<TranslateStringService>(
          builder: (context, ln, child) =>
              Consumer<RefundTicketMessagesService>(
                  builder: (context, provider, child) {
            if (provider.messagesList.isNotEmpty &&
                provider.sendLoading == false) {
              Future.delayed(const Duration(milliseconds: 500), () {
                _scrollDown();
              });
            }
            return Stack(
              children: <Widget>[
                provider.isloading == false
                    ? Container(
                        margin: const EdgeInsets.only(bottom: 60),
                        child: ListView.builder(
                          controller: _scrollController,
                          itemCount: provider.messagesList.length,
                          shrinkWrap: true,
                          padding: const EdgeInsets.only(
                            top: 10,
                            bottom: 10,
                          ),
                          itemBuilder: (context, index) {
                            return Row(
                              mainAxisAlignment: provider.messagesList[index]
                                          ['type'] ==
                                      "admin"
                                  ? MainAxisAlignment.start
                                  : MainAxisAlignment.end,
                              children: [
                                Expanded(
                                  child: Container(
                                    padding: EdgeInsets.only(
                                        left: provider.messagesList[index]
                                                    ['type'] ==
                                                "admin"
                                            ? 10
                                            : 160,
                                        right: provider.messagesList[index]
                                                    ['type'] ==
                                                "admin"
                                            ? 160
                                            : 10,
                                        top: 10,
                                        bottom: 10),
                                    child: Align(
                                      alignment: (provider.messagesList[index]
                                                  ['type'] ==
                                              "admin"
                                          ? Alignment.topLeft
                                          : Alignment.topRight),
                                      child: Column(
                                        crossAxisAlignment:
                                            (provider.messagesList[index]
                                                        ['type'] ==
                                                    "admin"
                                                ? CrossAxisAlignment.start
                                                : CrossAxisAlignment.end),
                                        children: [
                                          //the message ==========>
                                          Container(
                                            alignment: Alignment.centerRight,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                              color:
                                                  (provider.messagesList[index]
                                                              ['type'] ==
                                                          "admin"
                                                      ? Colors.grey.shade200
                                                      : primaryColor),
                                            ),
                                            padding: const EdgeInsets.all(16),
                                            child: HtmlWidget(
                                                '${provider.messagesList[index]['message']}',
                                                textStyle: TextStyle(
                                                  fontSize: 15,
                                                  color: (provider.messagesList[
                                                              index]['type'] ==
                                                          "admin"
                                                      ? Colors.grey[800]
                                                      : Colors.white),
                                                )),
                                          ),

                                          //Attachment =============>
                                          provider.messagesList[index]
                                                      ['attachment'] !=
                                                  null
                                              ? Container(
                                                  margin: const EdgeInsets.only(
                                                      top: 11),
                                                  child: provider.messagesList[
                                                                  index]
                                                              ['imagePicked'] ==
                                                          false
                                                      ? InkWell(
                                                          onTap: () {
                                                            Navigator.push(
                                                              context,
                                                              MaterialPageRoute<
                                                                  void>(
                                                                builder: (BuildContext
                                                                        context) =>
                                                                    ImageBigPreviewPage(
                                                                  networkImgLink:
                                                                      provider.messagesList[
                                                                              index]
                                                                          [
                                                                          'attachment'],
                                                                ),
                                                              ),
                                                            );
                                                          },
                                                          child:
                                                              CachedNetworkImage(
                                                            imageUrl: provider
                                                                            .messagesList[
                                                                        index][
                                                                    'attachment'] ??
                                                                placeHolderUrl,
                                                            placeholder:
                                                                (context, url) {
                                                              return Image.asset(
                                                                  'assets/images/placeholder.png');
                                                            },
                                                            height: 150,
                                                            width: getScreenWidth(
                                                                        context) /
                                                                    2 -
                                                                50,
                                                            fit:
                                                                BoxFit.fitWidth,
                                                          ),
                                                        )
                                                      : InkWell(
                                                          onTap: () {
                                                            Navigator.push(
                                                              context,
                                                              MaterialPageRoute<
                                                                  void>(
                                                                builder: (BuildContext
                                                                        context) =>
                                                                    ImageBigPreviewPage(
                                                                  assetImgLink:
                                                                      provider.messagesList[
                                                                              index]
                                                                          [
                                                                          'attachment'],
                                                                ),
                                                              ),
                                                            );
                                                          },
                                                          child: Image.file(
                                                            File(provider
                                                                        .messagesList[
                                                                    index]
                                                                ['attachment']),
                                                            height: 150,
                                                            width: getScreenWidth(
                                                                        context) /
                                                                    2 -
                                                                50,
                                                            fit: BoxFit.cover,
                                                          ),
                                                        ),
                                                )
                                              : Container()
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            );
                          },
                        ),
                      )
                    : showLoading(primaryColor),

                //write message section======>
                Align(
                  alignment: Alignment.bottomLeft,
                  child: Container(
                    padding: const EdgeInsets.only(
                        left: 20, bottom: 10, top: 10, right: 10),
                    height: 60,
                    width: double.infinity,
                    color: Colors.white,
                    child: Row(
                      children: <Widget>[
                        pickedFile != null
                            ? Container(
                                height: 40,
                                width: 40,
                                decoration: BoxDecoration(
                                    color: primaryColor,
                                    borderRadius: BorderRadius.circular(10)),
                                child: const Icon(
                                  Icons.file_copy,
                                  color: Colors.white,
                                  size: 18,
                                ))
                            : Container(),
                        const SizedBox(
                          width: 13,
                        ),
                        Expanded(
                          child: TextField(
                            controller: sendMessageController,
                            decoration: InputDecoration(
                                hintText:
                                    ln.getString(ConstString.writeMessage) +
                                        "...",
                                hintStyle:
                                    const TextStyle(color: Colors.black54),
                                border: InputBorder.none),
                          ),
                        ),
                        const SizedBox(
                          width: 15,
                        ),
                        //pick image =====>
                        IconButton(
                            onPressed: () async {
                              pickedFile = await provider.pickImage();
                              setState(() {});
                            },
                            icon: const Icon(Icons.attachment)),

                        //send message button
                        const SizedBox(
                          width: 13,
                        ),
                        FloatingActionButton(
                          onPressed: () async {
                            if (sendMessageController.text.isNotEmpty) {
                              //hide keyboard
                              FocusScope.of(context).unfocus();
                              //send message
                              provider.sendMessage(
                                  ticketId: widget.ticketId,
                                  message: sendMessageController.text,
                                  filePath: pickedFile?.path,
                                  context: context);

                              //clear input field
                              sendMessageController.clear();
                              //clear image
                              setState(() {
                                pickedFile = null;
                              });
                            } else {
                              showToast(
                                  ln.getString(
                                      ConstString.plzWriteMessageFirst),
                                  Colors.black);
                            }
                          },
                          backgroundColor: primaryColor,
                          elevation: 0,
                          child: provider.sendLoading == false
                              ? const Icon(
                                  Icons.send,
                                  color: Colors.white,
                                  size: 18,
                                )
                              : const SizedBox(
                                  height: 14,
                                  width: 14,
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 1.5,
                                  ),
                                ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          }),
        ),
      ),
    );
  }
}
