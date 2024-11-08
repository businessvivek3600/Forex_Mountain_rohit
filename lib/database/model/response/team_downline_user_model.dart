class TeamDownlineUser {
  String? username;
  String? referral;
  int? newLevel;
  int? downline;
  int? nodeVal;
  String? status;
  String? nameWithUsername;
  String? activeDate;
  String? expireDate;
  String? totalMember;
  String? activeMember;
  bool expanded = false;
  List<TeamDownlineUser>? team;

  TeamDownlineUser({
    this.username,
    this.referral,
    this.newLevel,
    this.downline,
    this.nodeVal,
    this.status,
    this.nameWithUsername,
    this.activeDate,
    this.expireDate,
    this.totalMember,
    this.activeMember,
    this.expanded = false,
    this.team,
  });

  TeamDownlineUser.fromJson(Map<String, dynamic> json) {
    username = json['username'];
    referral = json['referral'];
    newLevel = json['new_level'];
    nodeVal = json['nodeVal'];
    status = json['status']?.toString(); // Convert to String
    downline = json['downline'];
    nameWithUsername = json['name_with_username'];
    activeDate = json['active_date'];
    expireDate = json['expire_date'];
    totalMember = json['total_member']?.toString(); // Convert to String
    activeMember = json['active_member']?.toString(); // Convert to String
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['username'] = username;
    data['referral'] = referral;
    data['new_level'] = newLevel;
    data['nodeVal'] = nodeVal;
    data['downline'] = downline;
    data['status'] = status;
    data['name_with_username'] = nameWithUsername;
    data['active_date'] = activeDate;
    data['expire_date'] = expireDate;
    data['total_member'] = totalMember;
    data['active_member'] = activeMember;
    return data;
  }
}