
import 'Cars.dart';

bool loggedIn = false;
bool verified = false;
String userId = '';
String firstName = '';
String lastName = '';
String userName = '';
String password = '';
String email = '-';
List<Car> favCars = <Car>[];
String token = '';

void clear() {
  userId = '';
  firstName = '';
  lastName = '';
  userName = '';
  password = '';
  email = '';
  loggedIn = false;
  favCars = [];
  appCars.searchedMake = "";
  appCars.searchedModel = "";
}



