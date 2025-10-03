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
      messagesPerDay: json['messagesPerDay'],
      videoTimeSeconds: json['videoTimeSeconds'],
      audioTimeSeconds: json['audioTimeSeconds'],
      matchesAllowed: json['matchesAllowed'],
    );
  }
}
