// { "id": 12, "name": "John Doe", "membership_status": "invited" }
class UserInvitesList {

  factory UserInvitesList.fromJson(Map<String, dynamic> json) => UserInvitesList(
    id: json['id'],
    name: json['name'],
    membershipStatus: json['membership_status'],
  );

  UserInvitesList({required this.id, required this.name, required this.membershipStatus});
  final int id;
  final String name;
  final String membershipStatus;
}