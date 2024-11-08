class PadomerData {
  String id;
  String date;
  String customerId;
  String username;
  String count;
  String createdAt;
  String updatedAt;

  PadomerData({
    required this.id,
    required this.date,
    required this.customerId,
    required this.username,
    required this.count,
    required this.createdAt,
    required this.updatedAt,
  });

  factory PadomerData.fromJson(Map<String, dynamic> json) {
    return PadomerData(
      id: json['id'],
      date: json['date'],
      customerId: json['customer_id'],
      username: json['username'],
      count: json['count'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }

  // Method to convert the instance to a JSON object
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'date': date,
      'customer_id': customerId,
      'username': username,
      'count': count,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }
}

// Wrapper class to handle the list of PadomerData
class PadomerDataResponse {
  List<PadomerData> padomerData;

  PadomerDataResponse({required this.padomerData});

  factory PadomerDataResponse.fromJson(Map<String, dynamic> json) {
    var list = json['padomerData'] as List;
    List<PadomerData> padomerDataList = list.map((i) => PadomerData.fromJson(i)).toList();
    return PadomerDataResponse(padomerData: padomerDataList);
  }

  Map<String, dynamic> toJson() {
    return {
      'padomerData': padomerData.map((data) => data.toJson()).toList(),
    };
  }
}
