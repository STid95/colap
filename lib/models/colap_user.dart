class ColapUser {
  String uid;
  String? email;
  String? name;
  List<String> lists;
  ColapUser(
      {required this.uid,
      required this.email,
      this.name,
      this.lists = const []});
}
