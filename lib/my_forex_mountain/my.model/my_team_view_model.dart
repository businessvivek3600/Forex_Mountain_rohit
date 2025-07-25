class MyTeamMember {
  final String? id;
  final String? username;
  final String? customerName;
  final String? directSponserUsername;
  final String? customerEmail;
  final String? countryText;
  final String? createdAt;
  final String? salesActive;
  final String? salesActiveDate;
  final String? customerId;

  MyTeamMember({
    this.id,
    this.username,
    this.customerName,
    this.directSponserUsername,
    this.customerEmail,
    this.countryText,
    this.createdAt,
    this.salesActive,
    this.salesActiveDate,
    this.customerId,
  });

  factory MyTeamMember.fromJson(Map<String, dynamic> json) {
    return MyTeamMember(
      id: json['id'],
      username: json['username'],
      customerName: json['customer_name'],
      directSponserUsername: json['direct_sponser_username'],
      customerEmail: json['customer_email'],
      countryText: json['country_text'],
      createdAt: json['created_at'],
      salesActive: json['sales_active'],
      salesActiveDate: json['sales_active_date'],
      customerId: json['customer_id'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'customer_name': customerName,
      'direct_sponser_username': directSponserUsername,
      'customer_email': customerEmail,
      'country_text': countryText,
      'created_at': createdAt,
      'sales_active': salesActive,
      'sales_active_date': salesActiveDate,
      'customer_id': customerId,
    };
  }
}
