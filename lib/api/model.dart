class UserModel {
  final String id;
  final String firstName;
  final String lastName;
  final String email;
  final int mobileNumber;
  final String token;
  final String role;

  UserModel(
      {required this.id,
      required this.firstName,
      required this.lastName,
      required this.email,
      required this.mobileNumber,
      required this.token,
      required this.role});
}

class ContributorModel {
  final data;

  ContributorModel({
    required this.data,
  });
}

class ContributionModel {
  final  data;

  ContributionModel({
    required this.data,
  });
}