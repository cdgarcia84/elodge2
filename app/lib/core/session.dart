class UserSession {
  const UserSession({
    required this.userId,
    required this.username,
    required this.displayName,
    required this.rolGestion,
    required this.legajo,
  });

  final String userId;
  final String username;
  final String displayName;
  final String rolGestion;
  final String? legajo;
}

class AppUser {
  const AppUser({
    required this.id,
    required this.username,
    required this.displayName,
    required this.rolGestion,
    required this.legajo,
    required this.password,
  });

  final String id;
  final String username;
  final String displayName;
  final String rolGestion;
  final String? legajo;
  final String password;

  UserSession toSession() => UserSession(
        userId: id,
        username: username,
        displayName: displayName,
        rolGestion: rolGestion,
        legajo: legajo,
      );
}

class MockUsers {
  static const List<AppUser> users = [
    AppUser(
      id: 'u1',
      username: 'vm',
      displayName: 'Venerable Maestro',
      rolGestion: 'VM',
      legajo: '95.278',
      password: 'demo',
    ),
    AppUser(
      id: 'u2',
      username: 'secretario',
      displayName: 'Secretario',
      rolGestion: 'Secretario',
      legajo: '92.911',
      password: 'demo',
    ),
    AppUser(
      id: 'u3',
      username: 'tesorero',
      displayName: 'Tesorero',
      rolGestion: 'Tesorero',
      legajo: '17.238',
      password: 'demo',
    ),
    AppUser(
      id: 'u4',
      username: 'hh',
      displayName: 'Hermano',
      rolGestion: 'HH',
      legajo: '108.629',
      password: 'demo',
    ),
  ];
}
