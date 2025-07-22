class MyKycData {
  final String? username;
  final List<String>? docTypeSel;
  final String? kycdetailId;
  final String? remarks;
  final String? uploadFirstProof;
  final String? uploadSecondProof;
  final String? docType;
  final String? docNumber;
  final String? countryCode;
  final String? countrySortname;
  final int? kycStatus;

  MyKycData({
    this.username,
    this.docTypeSel,
    this.kycdetailId,
    this.remarks,
    this.uploadFirstProof,
    this.uploadSecondProof,
    this.docType,
    this.docNumber,
    this.countryCode,
    this.countrySortname,
    this.kycStatus,
  });

  factory MyKycData.fromJson(Map<String, dynamic> json) {
    return MyKycData(
      username: json['username'],
      docTypeSel: List<String>.from(json['doc_type_sel'] ?? []),
      kycdetailId: json['kycdetail_id'],
      remarks: json['remarks'],
      uploadFirstProof: json['upload_first_proof'],
      uploadSecondProof: json['upload_second_proof'],
      docType: json['doc_type'],
      docNumber: json['doc_number'],
      countryCode: json['country_code'],
      countrySortname: json['country_sortname'],
      kycStatus: json['kyc_status'] != null ? int.tryParse(json['kyc_status'].toString()) : null,
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'doc_type_sel': docTypeSel,
      'kycdetail_id': kycdetailId,
      'remarks': remarks,
      'upload_first_proof': uploadFirstProof,
      'upload_second_proof': uploadSecondProof,
      'doc_type': docType,
      'doc_number': docNumber,
      'country_code': countryCode,
      'country_sortname': countrySortname,
      'kyc_status': kycStatus,
    };
  }
}
