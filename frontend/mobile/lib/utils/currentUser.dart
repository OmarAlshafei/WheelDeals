
bool loggedIn = false;
bool verified = false;
String userId = '';
String firstName = '';
String lastName = '';
String userName = '';
String password = '';
String email = '-';
List<String> favCars = <String>[];
String token = '';

void clear() {
  userId = '';
  firstName = '';
  lastName = '';
  userName = '';
  password = '';
  email = '';
  loggedIn = false;
}

