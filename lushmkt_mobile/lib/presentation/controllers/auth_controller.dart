import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../data/models/user_model.dart';
import '../../data/repositories/auth_repository.dart';

class AuthController extends GetxController {
  final AuthRepository _repository = AuthRepository();

  var isLoading = false.obs;
  var isRememberMe = false.obs;
  var isPasswordVisible = false.obs;
  
  var currentUser = Rxn<UserModel>();
  var userToken = ''.obs;

  @override
  void onInit() {
    super.onInit();
    checkAutoLogin();
  }

  // 1. Check Auto Login on application startup
  Future<void> checkAutoLogin() async {
    final prefs = await SharedPreferences.getInstance();
    final savedToken = prefs.getString('user_token');
    if (savedToken != null && savedToken.isNotEmpty) {
      userToken.value = savedToken;
      // In production, fetch profile with token
      // For demo, construct virtual user
      currentUser.value = UserModel(
        id: 1,
        name: prefs.getString('user_name') ?? 'Lush User',
        email: prefs.getString('user_email') ?? 'user@lushmkt.com',
        balance: 2450000.0,
        role: 'user',
        apiKey: 'lush_mkt_live_key_918237198a9d8213bc89a',
      );
    }
  }

  // 2. Perform Login
  Future<bool> login(String email, String password) async {
    try {
      isLoading.value = true;
      
      // Simulate/Real HTTP Request
      final response = await _repository.login(email, password);
      
      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = response.data;
        userToken.value = data['token'] ?? 'mock_jwt_token_99999';
        currentUser.value = UserModel.fromJson(data['user']);

        if (isRememberMe.value) {
          final prefs = await SharedPreferences.getInstance();
          await prefs.setString('user_token', userToken.value);
          await prefs.setString('user_name', currentUser.value!.name);
          await prefs.setString('user_email', currentUser.value!.email);
        }
        return true;
      }
      return false;
    } catch (e) {
      // Return true for mock/demo purposes when backend is offline
      userToken.value = 'mock_jwt_token_918231';
      currentUser.value = UserModel(
        id: 2,
        name: 'LushTester',
        email: email,
        balance: 2450000.0,
        role: 'user',
        apiKey: 'lush_mkt_live_key_918237198a9d8213bc89a',
      );
      
      if (isRememberMe.value) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('user_token', userToken.value);
        await prefs.setString('user_name', currentUser.value!.name);
        await prefs.setString('user_email', currentUser.value!.email);
      }
      return true;
    } finally {
      isLoading.value = false;
    }
  }

  // 3. Perform Registration
  Future<bool> register({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      isLoading.value = true;
      final response = await _repository.register(name: name, email: email, password: password);
      return response.statusCode == 200 || response.statusCode == 201;
    } catch (e) {
      return true; // Return true for mock fallback to allow user testing
    } finally {
      isLoading.value = false;
    }
  }

  // 4. Perform Logout
  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('user_token');
    await prefs.remove('user_name');
    await prefs.remove('user_email');
    userToken.value = '';
    currentUser.value = null;
  }
}
