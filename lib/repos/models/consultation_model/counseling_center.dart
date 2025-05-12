import 'consultant.dart';
import 'province.dart';

class CounselingCenter {
  final int? id;
  final String? name;
  final String? address;
  final Province? province;
  final City? city;
  final String? latitude;
  final String? longitude;
  final String? phone;
  final String? openingTime;
  final String? closingTime;
  final bool? isActive;
  final List<Consultant>? consultants;

  CounselingCenter({
    this.id,
    this.name,
    this.address,
    this.province,
    this.city,
    this.latitude,
    this.longitude,
    this.phone,
    this.openingTime,
    this.closingTime,
    this.isActive,
    this.consultants,
  });

  factory CounselingCenter.fromJson(Map<String, dynamic> json) {
    return CounselingCenter(
      id: json['id'] as int?,
      name: json['name'] as String?,
      address: json['address'] as String?,
      province: json['province'] != null ? Province.fromJson(json['province']) : null,
      city: json['city'] != null ? City.fromJson(json['city']) : null,
      latitude: json['latitude'] as String?,
      longitude: json['longitude'] as String?,
      phone: json['phone'] as String?,
      openingTime: json['opening_time'] as String?,
      closingTime: json['closing_time'] as String?,
      isActive: json['is_active'] as bool?,
      consultants: (json['consultants'] as List<dynamic>?)
          ?.map((e) => Consultant.fromJson(e))
          .toList(),
    );
  }
}
