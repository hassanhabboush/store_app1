import 'package:flutter/material.dart';
import 'package:store_app/services/common_service.dart';
import 'package:store_app/services/refund_ticket_service/create_refund_ticket_service.dart';
import 'package:store_app/services/translate_string_service.dart';
import 'package:store_app/view/utils/const_strings.dart';
import 'package:store_app/view/utils/textarea_field.dart';
import 'package:store_app/view/utils/common_helper.dart';
import 'package:store_app/view/utils/constant_styles.dart';
import 'package:store_app/view/utils/custom_input.dart';
import 'package:provider/provider.dart';

class CreateRefundTicketPage extends StatefulWidget {
  const CreateRefundTicketPage({Key? key}) : super(key: key);

  @override
  _CreateRefundTicketPageState createState() => _CreateRefundTicketPageState();
}

class _CreateRefundTicketPageState extends State<CreateRefundTicketPage> {
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
  }

  TextEditingController descController = TextEditingController();
  TextEditingController titleController = TextEditingController();
  TextEditingController subjectController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: appbarCommon(ConstString.createTicket, context, () {
          Navigator.pop(context);
        }),
        body: Listener(
          onPointerDown: (_) {
            hideKeyboard(context);
          },
          child: SingleChildScrollView(
            child: Consumer<TranslateStringService>(
              builder: (context, ln, child) =>
                  Consumer<CreateRefundTicketService>(
                builder: (context, provider, child) => Form(
                  key: _formKey,
                  child: Container(
                    padding: EdgeInsets.symmetric(
                        horizontal: screenPadHorizontal, vertical: 20),
                    child: Column(children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          //================>
                          labelCommon(ConstString.title),

                          CustomInput(
                            controller: titleController,
                            borderRadius: 8,
                            validation: (value) {
                              if (value == null || value.isEmpty) {
                                return ln
                                    .getString(ConstString.plzEnterTicketTitle);
                              }
                              return null;
                            },
                            hintText: ln.getString(ConstString.ticketTitle),
                            // icon: 'assets/icons/user.png',
                            paddingHorizontal: 18,
                            textInputAction: TextInputAction.next,
                          ),

                          //================>
                          labelCommon(ConstString.subject),
                          CustomInput(
                            controller: subjectController,
                            borderRadius: 8,
                            validation: (value) {
                              if (value == null || value.isEmpty) {
                                return ln.getString(
                                    ConstString.plzEnterTicketSubject);
                              }
                              return null;
                            },
                            hintText: ln.getString(ConstString.subject),
                            // icon: 'assets/icons/user.png',
                            paddingHorizontal: 18,
                            textInputAction: TextInputAction.next,
                          ),

                          gapH(5),

                          labelCommon(ConstString.desc),
                          TextareaField(
                            hintText:
                                ln.getString(ConstString.describeYourProb),
                            notesController: descController,
                          ),

                          //Save button =========>

                          const SizedBox(
                            height: 30,
                          ),
                          buttonPrimary(ConstString.createTicket, () {
                            if (_formKey.currentState!.validate()) {
                              if (provider.isLoading == false) {
                                provider.createTicket(
                                  titleController.text,
                                  subjectController.text,
                                  descController.text,
                                  context,
                                );
                              }
                            }
                          }, isloading: provider.isLoading)
                        ],
                      ),
                    ]),
                  ),
                ),
              ),
            ),
          ),
        ));
  }
}
