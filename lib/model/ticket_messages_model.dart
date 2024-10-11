// To parse this JSON data, do
//
//     final ticketMessagesModel = ticketMessagesModelFromJson(jsonString);

import 'dart:convert';

TicketMessagesModel ticketMessagesModelFromJson(String str) =>
    TicketMessagesModel.fromJson(json.decode(str));

String ticketMessagesModelToJson(TicketMessagesModel data) =>
    json.encode(data.toJson());

class TicketMessagesModel {
  TicketMessagesModel({
    required this.ticketDetails,
    required this.allMessages,
  });

  TicketDetails ticketDetails;
  List<AllMessage> allMessages;

  factory TicketMessagesModel.fromJson(Map<String, dynamic> json) =>
      TicketMessagesModel(
        ticketDetails: TicketDetails.fromJson(json["ticket_details"]),
        allMessages: List<AllMessage>.from(
            json["all_messages"].map((x) => AllMessage.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "ticket_details": ticketDetails.toJson(),
        "all_messages": List<dynamic>.from(allMessages.map((x) => x.toJson())),
      };
}

class AllMessage {
  AllMessage({
    this.id,
    this.message,
    this.notify,
    this.attachment,
    this.type,
    this.userId,
    this.supportTicketId,
    this.createdAt,
    this.updatedAt,
  });

  int? id;
  String? message;
  String? notify;
  dynamic attachment;
  String? type;
  int? userId;
  int? supportTicketId;
  DateTime? createdAt;
  DateTime? updatedAt;

  factory AllMessage.fromJson(Map<String, dynamic> json) => AllMessage(
        id: json["id"],
        message: json["message"],
        notify: json["notify"],
        attachment: json["attachment"],
        type: json["type"],
        userId: json["user_id"],
        supportTicketId: json["support_ticket_id"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "message": message,
        "notify": notify,
        "attachment": attachment,
        "type": type,
        "user_id": userId,
        "support_ticket_id": supportTicketId,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
      };
}

class TicketDetails {
  TicketDetails({
    this.id,
    this.title,
    this.via,
    this.operatingSystem,
    this.userAgent,
    this.description,
    this.subject,
    this.status,
    this.priority,
    this.departmentId,
    this.userId,
    this.adminId,
    this.createdAt,
    this.updatedAt,
  });

  int? id;
  String? title;
  String? via;
  dynamic operatingSystem;
  String? userAgent;
  String? description;
  String? subject;
  String? status;
  String? priority;
  dynamic departmentId;
  int? userId;
  dynamic adminId;
  DateTime? createdAt;
  DateTime? updatedAt;

  factory TicketDetails.fromJson(Map<String, dynamic> json) => TicketDetails(
        id: json["id"],
        title: json["title"],
        via: json["via"],
        operatingSystem: json["operating_system"],
        userAgent: json["user_agent"],
        description: json["description"],
        subject: json["subject"],
        status: json["status"],
        priority: json["priority"],
        departmentId: json["department_id"],
        userId: json["user_id"],
        adminId: json["admin_id"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "via": via,
        "operating_system": operatingSystem,
        "user_agent": userAgent,
        "description": description,
        "subject": subject,
        "status": status,
        "priority": priority,
        "department_id": departmentId,
        "user_id": userId,
        "admin_id": adminId,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
      };
}
