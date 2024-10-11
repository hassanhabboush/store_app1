import 'package:flutter/material.dart';
import 'package:store_app/services/translate_string_service.dart';
import 'package:store_app/services/dropdown_services/priority_and_department_dropdown_service.dart';
import 'package:store_app/services/dropdown_services/ticket_status_dropdown_service.dart';
import 'package:store_app/services/ticket_services/change_priority_service.dart';
import 'package:store_app/services/ticket_services/change_ticket_status_service.dart';
import 'package:store_app/view/utils/common_helper.dart';
import 'package:store_app/view/utils/const_strings.dart';
import 'package:store_app/view/utils/constant_styles.dart';
import 'package:store_app/view/widgets/custom_dropdown.dart';
import 'package:provider/provider.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class SupportTicketHelper {
  //
  changePriorityPopup(BuildContext context, ticketId) {
    return Alert(
        context: context,
        style: AlertStyle(
            alertElevation: 0,
            overlayColor: Colors.black.withOpacity(.6),
            alertPadding: const EdgeInsets.all(25),
            isButtonVisible: false,
            alertBorder: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
              side: const BorderSide(
                color: Colors.transparent,
              ),
            ),
            titleStyle: const TextStyle(),
            animationType: AnimationType.grow,
            animationDuration: const Duration(milliseconds: 500)),
        content: Container(
          margin: const EdgeInsets.only(top: 22),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(7),
            boxShadow: [
              BoxShadow(
                  color: Colors.black.withOpacity(0.01),
                  spreadRadius: -2,
                  blurRadius: 13,
                  offset: const Offset(0, 13)),
            ],
          ),
          child: Consumer<TranslateStringService>(
            builder: (context, ln, child) =>
                Consumer<PriorityAndDepartmentDropdownService>(
              builder: (context, pProvider, child) =>
                  Consumer<ChangePriorityService>(
                builder: (context, cProvider, child) => Column(
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
                                pProvider.priorityDropdownList.indexOf(v!)]);
                      },
                    ),

                    gapH(25),
                    Row(
                      children: [
                        Expanded(
                            child: borderButtonPrimary(
                                ln.getString(ConstString.cancel), () {
                          Navigator.pop(context);
                        })),
                        const SizedBox(
                          width: 16,
                        ),
                        Expanded(
                            child: buttonPrimary(ln.getString(ConstString.save),
                                () {
                          if (cProvider.isloading) return;

                          cProvider.changePriority(context, id: ticketId);
                        }, isloading: cProvider.isloading)),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
        )).show();
  }

  //
  changeStatusPopup(BuildContext context, ticketId) {
    return Alert(
        context: context,
        style: AlertStyle(
            alertElevation: 0,
            overlayColor: Colors.black.withOpacity(.6),
            alertPadding: const EdgeInsets.all(25),
            isButtonVisible: false,
            alertBorder: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
              side: const BorderSide(
                color: Colors.transparent,
              ),
            ),
            titleStyle: const TextStyle(),
            animationType: AnimationType.grow,
            animationDuration: const Duration(milliseconds: 500)),
        content: Container(
          margin: const EdgeInsets.only(top: 22),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(7),
            boxShadow: [
              BoxShadow(
                  color: Colors.black.withOpacity(0.01),
                  spreadRadius: -2,
                  blurRadius: 13,
                  offset: const Offset(0, 13)),
            ],
          ),
          child: Consumer<TranslateStringService>(
            builder: (context, ln, child) =>
                Consumer<TicketStatusDropdownService>(
              builder: (context, pProvider, child) =>
                  Consumer<ChangeTicketStatusService>(
                builder: (context, cProvider, child) => Column(
                  children: [
                    //status dropdown ======>
                    CustomDropDown(
                      items: pProvider.statusDropdownList,
                      labelText: ln.getString(ConstString.status),
                      value: pProvider.selectedstatus,
                      onChange: (v) {
                        pProvider.setstatusValue(v);

                        // setting the id of selected value
                        pProvider.setSelectedstatusId(
                            pProvider.statusDropdownIndexList[
                                pProvider.statusDropdownList.indexOf(v!)]);
                      },
                    ),

                    gapH(25),
                    Row(
                      children: [
                        Expanded(
                            child: borderButtonPrimary(
                                ln.getString(ConstString.cancel), () {
                          Navigator.pop(context);
                        })),
                        const SizedBox(
                          width: 16,
                        ),
                        Expanded(
                            child: buttonPrimary(ln.getString(ConstString.save),
                                () {
                          if (cProvider.isloading) return;
                          cProvider.changeStatus(context, id: ticketId);
                        }, isloading: cProvider.isloading)),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
        )).show();
  }
}
