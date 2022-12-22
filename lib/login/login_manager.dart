import 'package:grp_6_bicycle/DB/UserDB.dart';
import 'package:grp_6_bicycle/DTO/UserDTO.dart';

class LoginManager {
  static Future<bool> isAnAdminConnected() async {
    UserDTO? user = await UserDB().getConnectedUser();
    if (user == null || user.userType != UserDTO.ADMIN_USER_TYPE) return false;
    return true;
  }
}
