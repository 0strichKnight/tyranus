enum ApplicationLoginState {
  loggedOut,
  loggedIn,
}

class Thing {
  Thing({required this.name, required this.count});

  final String name;
  final int count;
}
