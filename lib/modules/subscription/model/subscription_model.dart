class PlanModel {
  bool? success;
  List<Plan>? plans;

  PlanModel({this.success, this.plans});

  factory PlanModel.fromJson(Map<String, dynamic> json) {
    return PlanModel(
      success: json['success'],
      plans: json['plans'] != null
          ? List<Plan>.from(json['plans'].map((x) => Plan.fromJson(x)))
          : [],
    );
  }
}

class Plan {
  String? id;
  String? planType;
  int? price;
  int? durationDays;
  bool? isActive;
  Limits? limits;

  Plan({
    this.id,
    this.planType,
    this.price,
    this.durationDays,
    this.isActive,
    this.limits,
  });

  factory Plan.fromJson(Map<String, dynamic> json) {
    return Plan(
      id: json['_id'],
      planType: json['planType'],
      price: json['price'],
      durationDays: json['durationDays'],
      isActive: json['isActive'],
      limits: json['limits'] != null ? Limits.fromJson(json['limits']) : null,
    );
  }
}

class Limits {
  int? messagesPerDay;
  int? videoTimeSeconds;
  int? audioTimeSeconds;
  int? matchesAllowed;

  Limits({
    this.messagesPerDay,
    this.videoTimeSeconds,
    this.audioTimeSeconds,
    this.matchesAllowed,
  });

  factory Limits.fromJson(Map<String, dynamic> json) {
    return Limits(
      messagesPerDay: int.tryParse(json['totalMessagesAllowed'].toString()),
      videoTimeSeconds: int.tryParse(json['totalVideoTimeSeconds'].toString()),
      audioTimeSeconds: int.tryParse(json['totalAudioTimeSeconds'].toString()),
      matchesAllowed: int.tryParse(json['matchesAllowed'].toString()),
    );
  }
}

class SubscriptionModel {
  String? id;
  String? planId;
  String? planType;
  int? paidAmount;
  String? startDate;
  String? endDate;
  int? messagesAllowed;
  int? messagesUsedTotal;
  int? audioTimeAllowed;
  int? audioTimeUsedTotal;
  int? videoTimeAllowed;
  int? videoTimeUsedTotal;

  SubscriptionModel({
    this.id,
    this.planId,
    this.planType,
    this.paidAmount,
    this.startDate,
    this.endDate,
    this.messagesAllowed,
    this.messagesUsedTotal,
    this.audioTimeAllowed,
    this.audioTimeUsedTotal,
    this.videoTimeAllowed,
    this.videoTimeUsedTotal,
  });

  factory SubscriptionModel.fromJson(Map<String, dynamic> json) {
    return SubscriptionModel(
      id: json['_id'],
      planId: json['planId'],
      planType: json['planType'],
      paidAmount: json['paidAmount'],
      startDate: json['startDate'],
      endDate: json['endDate'],
      messagesAllowed: json['messagesAllowed'],
      messagesUsedTotal: json['messagesUsedTotal'],
      audioTimeAllowed: json['audioTimeAllowed'],
      audioTimeUsedTotal: json['audioTimeUsedTotal'],
      videoTimeAllowed: json['videoTimeAllowed'],
      videoTimeUsedTotal: json['videoTimeUsedTotal'],
    );
  }
}
