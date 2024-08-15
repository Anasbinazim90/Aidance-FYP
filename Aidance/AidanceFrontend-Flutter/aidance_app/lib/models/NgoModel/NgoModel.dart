class NgoModel {
  final String name;
  final String email;
  final String? contactNumber;
  final String? address;
  final String? registrationNumber;
  final String? missionAndObjectives;

  NgoModel({
    required this.name,
    required this.email,
    this.contactNumber,
    this.address,
    this.registrationNumber,
    this.missionAndObjectives,
  });
}
