import 'package:flutter/material.dart';
import 'package:store_app/services/common_service.dart';
import 'package:store_app/services/dropdown_services/priority_and_department_dropdown_service.dart';
import 'package:store_app/services/ticket_services/create_ticket_service.dart';
import 'package:store_app/services/translate_string_service.dart';
import 'package:store_app/view/utils/const_strings.dart';
import 'package:store_app/view/utils/textarea_field.dart';
import 'package:store_app/view/utils/common_helper.dart';
import 'package:store_app/view/utils/constant_colors.dart';
import 'package:store_app/view/utils/constant_styles.dart';
import 'package:store_app/view/utils/custom_input.dart';
import 'package:store_app/view/utils/others_helper.dart';
import 'package:store_app/view/widgets/custom_dropdown.dart';
import 'package:provider/provider.dart';

class CreateTicketPage extends StatefulWidget {
  const CreateTicketPage({Key? key}) : super(key: key);

  @override
  _CreateTicketPageState createState() => _CreateTicketPageState();
}

class _CreateTicketPageState extends State<CreateTicketPage> {
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();

    Provider.of<PriorityAndDepartmentDropdownService>(context, listen: false)
        .fetchDepartment(context);
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
                  Consumer<PriorityAndDepartmentDropdownService>(
                builder: (context, pProvider, child) =>
                    Consumer<CreateTicketService>(
                  builder: (context, provider, child) => Form(
                    key: _formKey,
                    child: Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: screenPadHorizontal, vertical: 20),
                      child: Column(children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            //Priority dropdown ======>
                            CustomDropDown(
                              items: pProvider.priorityDropdownList,
                              labelText: ln.getString(ConstString.priority),
                              value: pProvider.selectedPriority,
                              onChange: (v) {
                                pProvider.setPriorityValue(v);

                                // setting the id of selected value
                                pProvider.setSelectedPriorityId(
                                    pProvider.priorityDropdownIndexList[
                                        pProvider.priorityDropdownList
                                            .indexOf(v!)]);
                              },
                            ),

                            gapH(20),

                            //Department dropdown ======>
                            pProvider.departmentDropdownList.isNotEmpty
                                ? CustomDropDown(
                                    items: pProvider.departmentDropdownList,
                                    labelText:
                                        ln.getString(ConstString.department),
                                    value: pProvider.selectedDepartment,
                                    onChange: (v) {
                                      pProvider.setDepartmentValue(v);

                                      // setting the id of selected value
                                      pProvider.setSelectedDepartmentId(
                                          pProvider.departmentDropdownIndexList[
                                              pProvider.departmentDropdownList
                                                  .indexOf(v!)]);
                                    },
                                  )
                                : Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [showLoading(primaryColor)],
                                  ),

                            gapH(20),

                            //================>
                            labelCommon(ConstString.title),

                            CustomInput(
                              controller: titleController,
                              borderRadius: 8,
                              validation: (value) {
                                if (value == null || value.isEmpty) {
                                  return ln.getString(
                                      ConstString.plzEnterTicketTitle);
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
          ),
        ));
  }
}
