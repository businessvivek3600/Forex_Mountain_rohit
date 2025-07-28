class TicketListResponse {
  final bool status;
  final int? isLogin;
  final String? message;
  final List<TicketStatus>? statusList;
  final List<Department>? departments;
  final dynamic ticketStatus; // Adjust type if needed
  final List<Ticket>? ticketList;
  final int? statusId;
  final int? page;
  final int? total;
  final int? perPage;

  TicketListResponse({
    required this.status,
    this.isLogin,
    this.message,
    this.statusList,
    this.departments,
    this.ticketStatus,
    this.ticketList,
    this.statusId,
    this.page,
    this.total,
    this.perPage,
  });

  factory TicketListResponse.fromJson(Map<String, dynamic> json) {
    return TicketListResponse(
      status: json['status'] ?? false,
      isLogin: json['is_login'],
      message: json['message'],
      statusList: (json['status_list'] as List?)
          ?.map((e) => TicketStatus.fromJson(e))
          .toList(),
      departments: (json['departments'] as List?)
          ?.map((e) => Department.fromJson(e))
          .toList(),
      ticketStatus: json['ticket_status'],
      ticketList: (json['ticket_list'] as List?)
          ?.map((e) => Ticket.fromJson(e))
          .toList(),
      statusId: json['status_id'],
      page: json['page'],
      total: json['total'],
      perPage: json['per_page'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'is_login': isLogin,
      'message': message,
      'status_list': statusList?.map((e) => e.toJson()).toList(),
      'departments': departments?.map((e) => e.toJson()).toList(),
      'ticket_status': ticketStatus,
      'ticket_list': ticketList?.map((e) => e.toJson()).toList(),
      'status_id': statusId,
      'page': page,
      'total': total,
      'per_page': perPage,
    };
  }
}
class TicketStatus {
  final String? ticketStatusId;
  final String? name;
  final String? isDefault;
  final String? statusColor;
  final String? statusOrder;
  final int? total;

  TicketStatus({
    this.ticketStatusId,
    this.name,
    this.isDefault,
    this.statusColor,
    this.statusOrder,
    this.total,
  });

  factory TicketStatus.fromJson(Map<String, dynamic> json) {
    return TicketStatus(
      ticketStatusId: json['ticketstatusid'],
      name: json['name'],
      isDefault: json['isdefault'],
      statusColor: json['statuscolor'],
      statusOrder: json['statusorder'],
      total: json['total'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'ticketstatusid': ticketStatusId,
      'name': name,
      'isdefault': isDefault,
      'statuscolor': statusColor,
      'statusorder': statusOrder,
      'total': total,
    };
  }
}
class Department {
  final String? departmentId;
  final String? name;
  final String? imapUsername;
  final String? email;
  final String? emailFromHeader;
  final String? host;
  final String? password;
  final String? encryption;
  final String? deleteAfterImport;
  final String? calendarId;
  final String? hideFromClient;

  Department({
    this.departmentId,
    this.name,
    this.imapUsername,
    this.email,
    this.emailFromHeader,
    this.host,
    this.password,
    this.encryption,
    this.deleteAfterImport,
    this.calendarId,
    this.hideFromClient,
  });

  factory Department.fromJson(Map<String, dynamic> json) {
    return Department(
      departmentId: json['departmentid'],
      name: json['name'],
      imapUsername: json['imap_username'],
      email: json['email'],
      emailFromHeader: json['email_from_header'],
      host: json['host'],
      password: json['password'],
      encryption: json['encryption'],
      deleteAfterImport: json['delete_after_import'],
      calendarId: json['calendar_id'],
      hideFromClient: json['hidefromclient'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'departmentid': departmentId,
      'name': name,
      'imap_username': imapUsername,
      'email': email,
      'email_from_header': emailFromHeader,
      'host': host,
      'password': password,
      'encryption': encryption,
      'delete_after_import': deleteAfterImport,
      'calendar_id': calendarId,
      'hidefromclient': hideFromClient,
    };
  }
}
class Ticket {
  final String? ticketId;
  final String? adminReplying;
  final String? userId;
  final String? contactId;
  final String? email;
  final String? name;
  final String? department;
  final String? priority;
  final String? status;
  final String? service;
  final String? ticketKey;
  final String? subject;
  final String? message;
  final String? admin;
  final String? date;
  final String? projectId;
  final String? lastReply;
  final String? clientRead;
  final String? adminRead;
  final String? ip;
  final String? assigned;

  Ticket({
    this.ticketId,
    this.adminReplying,
    this.userId,
    this.contactId,
    this.email,
    this.name,
    this.department,
    this.priority,
    this.status,
    this.service,
    this.ticketKey,
    this.subject,
    this.message,
    this.admin,
    this.date,
    this.projectId,
    this.lastReply,
    this.clientRead,
    this.adminRead,
    this.ip,
    this.assigned,
  });

  factory Ticket.fromJson(Map<String, dynamic> json) {
    return Ticket(
      ticketId: json['ticketid'],
      adminReplying: json['adminreplying'],
      userId: json['userid'],
      contactId: json['contactid'],
      email: json['email'],
      name: json['name'],
      department: json['department'],
      priority: json['priority'],
      status: json['status'],
      service: json['service'],
      ticketKey: json['ticketkey'],
      subject: json['subject'],
      message: json['message'],
      admin: json['admin'],
      date: json['date'],
      projectId: json['project_id'],
      lastReply: json['lastreply'],
      clientRead: json['clientread'],
      adminRead: json['adminread'],
      ip: json['ip'],
      assigned: json['assigned'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'ticketid': ticketId,
      'adminreplying': adminReplying,
      'userid': userId,
      'contactid': contactId,
      'email': email,
      'name': name,
      'department': department,
      'priority': priority,
      'status': status,
      'service': service,
      'ticketkey': ticketKey,
      'subject': subject,
      'message': message,
      'admin': admin,
      'date': date,
      'project_id': projectId,
      'lastreply': lastReply,
      'clientread': clientRead,
      'adminread': adminRead,
      'ip': ip,
      'assigned': assigned,
    };
  }
}
