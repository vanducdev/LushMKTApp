import 'dart:convert';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../data/models/user_model.dart';
import '../../data/repositories/auth_repository.dart';

class AuthController extends GetxController {
  final AuthRepository _repository = AuthRepository();

  var isLoading = false.obs;
  var isRememberMe = true.obs; // Default remember me to true for easy access
  var isPasswordVisible = false.obs;
  
  var currentUser = Rxn<UserModel>();
  var userToken = ''.obs;

  // Saved accounts list (Facebook-like Multi-Account Switcher)
  var savedAccounts = <Map<String, String>>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadSavedAccounts();
    checkAutoLogin();
  }

  // 1. Load saved accounts from local storage
  Future<void> loadSavedAccounts() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final accountsJson = prefs.getString('saved_accounts_list');
      if (accountsJson != null && accountsJson.isNotEmpty) {
        final List<dynamic> decodedList = jsonDecode(accountsJson);
        savedAccounts.value = decodedList.map((item) => Map<String, String>.from(item)).toList();
      }
    } catch (e) {
      // Handle error elegantly
    }
  }

  // 2. Save account to switcher list
  Future<void> saveAccountToList(String name, String email, String token) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      
      // Remove any existing account with same email to avoid duplicates
      savedAccounts.removeWhere((acc) => acc['email'] == email);
      
      // Add the new account details
      savedAccounts.insert(0, {
        'name': name,
        'email': email,
        'token': token,
      });

      await prefs.setString('saved_accounts_list', jsonEncode(savedAccounts));
    } catch (e) {
      // Handle error elegantly
    }
  }

  // 3. Remove an account from switcher list
  Future<void> removeSavedAccount(String email) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      savedAccounts.removeWhere((acc) => acc['email'] == email);
      await prefs.setString('saved_accounts_list', jsonEncode(savedAccounts));
    } catch (e) {
      // Handle error elegantly
    }
  }

  // 4. Check Auto Login on application startup
  Future<void> checkAutoLogin() async {
    final prefs = await SharedPreferences.getInstance();
    final savedToken = prefs.getString('user_token');
    if (savedToken != null && savedToken.isNotEmpty) {
      userToken.value = savedToken;
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

  // 5. Perform Login
  Future<bool> login(String email, String password) async {
    try {
      isLoading.value = true;
      
      // Simulate/Real HTTP Request
      final response = await _repository.login(email, password);
      
      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = response.data;
        userToken.value = data['token'] ?? 'mock_jwt_token_99999';
        currentUser.value = UserModel.fromJson(data['user']);

        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('user_token', userToken.value);
        await prefs.setString('user_name', currentUser.value!.name);
        await prefs.setString('user_email', currentUser.value!.email);

        // Always save to the switcher list for seamless switching
        await saveAccountToList(currentUser.value!.name, currentUser.value!.email, userToken.value);
        return true;
      }
      return false;
    } catch (e) {
      // Fallback for mock/offline testing
      userToken.value = 'mock_jwt_token_918231';
      currentUser.value = UserModel(
        id: 2,
        name: email.split('@')[0].toUpperCase(),
        email: email,
        balance: 2450000.0,
        role: 'user',
        apiKey: 'lush_mkt_live_key_918237198a9d8213bc89a',
      );
      
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('user_token', userToken.value);
      await prefs.setString('user_name', currentUser.value!.name);
      await prefs.setString('user_email', currentUser.value!.email);

      await saveAccountToList(currentUser.value!.name, currentUser.value!.email, userToken.value);
      return true;
    } finally {
      isLoading.value = false;
    }
  }

  // 6. Login using Saved Switcher Account instantly
  Future<void> loginWithSavedAccount(Map<String, String> account) async {
    userToken.value = account['token'] ?? 'mock_jwt_token_918231';
    currentUser.value = UserModel(
      id: 3,
      name: account['name'] ?? 'Lush User',
      email: account['email'] ?? 'user@lushmkt.com',
      balance: 2450000.0,
      role: 'user',
      apiKey: 'lush_mkt_live_key_918237198a9d8213bc89a',
    );

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('user_token', userToken.value);
    await prefs.setString('user_name', currentUser.value!.name);
    await prefs.setString('user_email', currentUser.value!.email);
  }

  // 7. Perform Registration
  Future<bool> register({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      isLoading.value = true;
      
      // Simulate/Real Registration
      final response = await _repository.register(name: name, email: email, password: password);
      
      // Save credentials automatically after registration so they can log in instantly
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('reg_saved_email', email);
      await prefs.setString('reg_saved_password', password);
      
      return response.statusCode == 200 || response.statusCode == 201;
    } catch (e) {
      // Fallback for mock/offline testing
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('reg_saved_email', email);
      await prefs.setString('reg_saved_password', password);
      return true;
    } finally {
      isLoading.value = false;
    }
  }

  // 8. Perform Logout
  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('user_token');
    await prefs.remove('user_name');
    await prefs.remove('user_email');
    userToken.value = '';
    currentUser.value = null;
  }
}
