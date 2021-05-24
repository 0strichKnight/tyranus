enum ApplicationLoginState {
  loggedOut,
  loggedIn,
}

class Thing {
  Thing({required this.id, required this.name, required this.count});

  final String id;
  final String name;
  int count;
}
