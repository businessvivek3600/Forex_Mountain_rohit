class GenerationalTreeResponse {
  final bool status;
  final int? isLogin;
  final String? message;
  final GenerationalTreeData? data;

  GenerationalTreeResponse({
    required this.status,
    this.isLogin,
    this.message,
    this.data,
  });

  factory GenerationalTreeResponse.fromJson(Map<String, dynamic> json) {
    return GenerationalTreeResponse(
      status: json['status'] ?? false,
      isLogin: json['is_login'],
      message: json['message'],
      data: json['data'] != null ? GenerationalTreeData.fromJson(json['data']) : null,
    );
  }

  Map<String, dynamic> toJson() => {
    'status': status,
    'is_login': isLogin,
    'message': message,
    'data': data?.toJson(),
  };
}

class GenerationalTreeData {
  final Client? client;
  final List<CustomerChild>? customerChild;

  GenerationalTreeData({this.client, this.customerChild});

  factory GenerationalTreeData.fromJson(Map<String, dynamic> json) {
    return GenerationalTreeData(
      client: json['client'] != null ? Client.fromJson(json['client']) : null,
      customerChild: (json['customer_child'] as List<dynamic>?)
          ?.map((e) => CustomerChild.fromJson(e))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() => {
    'client': client?.toJson(),
    'customer_child': customerChild?.map((e) => e.toJson()).toList(),
  };
}

class Client {
  final String? id;
  final String? customerId;
  final String? username;
  final String? directSponserUsername;
  final String? salesActive;
  final String? activeTotalMember;
  final String? totalMember;
  final String? directMember;
  final String? activeDirectMember;
  final String? selfSale;
  final String? teamSale;
  final String? directSale;

  Client({
    this.id,
    this.customerId,
    this.username,
    this.directSponserUsername,
    this.salesActive,
    this.activeTotalMember,
    this.totalMember,
    this.directMember,
    this.activeDirectMember,
    this.selfSale,
    this.teamSale,
    this.directSale,
  });

  factory Client.fromJson(Map<String, dynamic> json) {
    return Client(
      id: json['id'],
      customerId: json['customer_id'],
      username: json['username'],
      directSponserUsername: json['direct_sponser_username'] ?? '',
      salesActive: json['sales_active'],
      activeTotalMember: json['active_total_member'],
      totalMember: json['total_member'],
      directMember: json['direct_member'],
      activeDirectMember: json['active_direct_member'],
      selfSale: json['self_sale'],
      teamSale: json['team_sale'],
      directSale: json['direct_sale'],
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'customer_id': customerId,
    'username': username,
    'direct_sponser_username': directSponserUsername,
    'sales_active': salesActive,
    'active_total_member': activeTotalMember,
    'total_member': totalMember,
    'direct_member': directMember,
    'active_direct_member': activeDirectMember,
    'self_sale': selfSale,
    'team_sale': teamSale,
    'direct_sale': directSale,
  };
}

class CustomerChild {
  final String? id;
  final String? customerId;
  final String? username;
  final String? customerName;
  final String? salesActive;

  CustomerChild({
    this.id,
    this.customerId,
    this.username,
    this.customerName,
    this.salesActive,
  });

  factory CustomerChild.fromJson(Map<String, dynamic> json) {
    return CustomerChild(
      id: json['id'],
      customerId: json['customer_id'],
      username: json['username'],
      customerName: json['customer_name'],
      salesActive: json['sales_active'],
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'customer_id': customerId,
    'username': username,
    'customer_name': customerName,
    'sales_active': salesActive,
  };
}
