import 'package:pocketbase/pocketbase.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PocketBaseService {
  static const String baseUrl = 'http://127.0.0.1:8090';
  late final PocketBase pb;
  
  PocketBaseService() {
    pb = PocketBase(baseUrl);
    _loadAuth();
  }

  Future<void> _loadAuth() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('pb_auth_token');
    final model = prefs.getString('pb_auth_model');
    
    if (token != null && model != null) {
      pb.authStore.save(token, null);
    }
  }

  Future<void> saveAuth() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('pb_auth_token', pb.authStore.token);
    if (pb.authStore.model != null) {
      await prefs.setString('pb_auth_model', pb.authStore.model.toString());
    }
  }

  Future<void> clearAuth() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('pb_auth_token');
    await prefs.remove('pb_auth_model');
    pb.authStore.clear();
  }

  bool get isAuthenticated => pb.authStore.isValid;
  
  RecordModel? get currentUser => pb.authStore.model;
  
  String? get userRole {
    final user = currentUser;
    if (user == null) return null;
    return user.data['role'] as String?;
  }
  
  bool get isAdmin => userRole == 'administrador';
}