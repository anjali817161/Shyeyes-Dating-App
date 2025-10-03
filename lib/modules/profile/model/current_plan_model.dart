class ActivePlanModel {
  bool? success;
  String? message;
  Plan? plan;

  ActivePlanModel({this.success, this.message, this.plan});

  factory ActivePlanModel.fromJson(Map<String, dynamic> json) {
    return ActivePlanModel(
      success: json['success'],
      message: json['message'],
      plan: json['plans'] != null ? Plan.fromJson(json['plans']) : null,
    );
  }
}

class Plan {
  User? user;
  String? subscriptionId;
  String? planType;
  int? price;
  int? durationDays;
  bool? isActive;
  DateTime? startDate;
  DateTime? endDate;
  Limits? limits;
  Usage? usage;

  Plan({
    this.user,
    this.subscriptionId,
    this.planType,
    this.price,
    this.durationDays,
    this.isActive,
    this.startDate,
    this.endDate,
    this.limits,
    this.usage,
  });

  factory Plan.fromJson(Map<String, dynamic> json) {
    return Plan(
      user: json['userId'] != null ? User.fromJson(json['userId']) : null,
      subscriptionId: json['subscriptionId'],
      planType: json['planType'],
      price: json['price'],
      durationDays: json['durationDays'],
      isActive: json['isActive'],
      startDate:
          json['startDate'] != null ? DateTime.parse(json['startDate']) : null,
      endDate: json['endDate'] != null ? DateTime.parse(json['endDate']) : null,
      limits: json['limits'] != null ? Limits.fromJson(json['limits']) : null,
      usage: json['usage'] != null ? Usage.fromJson(json['usage']) : null,
    );
  }
}

class User {
  String? id;
  String? email;
  String? profilePic;
  Name? name;

  User({this.id, this.email, this.profilePic, this.name});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['_id'],
      email: json['email'],
      profilePic: json['profilePic'],
      name: json['Name'] != null ? Name.fromJson(json['Name']) : null,
    );
  }
}

class Name {
  String? firstName;
  String? lastName;

  Name({this.firstName, this.lastName});

  factory Name.fromJson(Map<String, dynamic> json) {
    return Name(
      firstName: json['firstName'],
      lastName: json['lastName'],
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

class Usage {
  UsageDetail? audio;
  UsageDetail? video;
  UsageDetail? messages;

  Usage({this.audio, this.video, this.messages});

  factory Usage.fromJson(Map<String, dynamic> json) {
    return Usage(
      audio: json['audio'] != null ? UsageDetail.fromJson(json['audio']) : null,
      video: json['video'] != null ? UsageDetail.fromJson(json['video']) : null,
      messages:
          json['messages'] != null ? UsageDetail.fromJson(json['messages']) : null,
    );
  }
}

class UsageDetail {
  int? used;
  int? remaining;

  UsageDetail({this.used, this.remaining});

  factory UsageDetail.fromJson(Map<String, dynamic> json) {
    return UsageDetail(
      used: json['used'],
      remaining: json['remaining'],
    );
  }
}
