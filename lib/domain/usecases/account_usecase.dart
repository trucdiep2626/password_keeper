

import 'package:password_keeper/data/local_repository.dart';
import 'package:password_keeper/data/remote/account_repository.dart';

class AccountUseCase {
  final AccountRepository accountRepo;
  final LocalRepository localRepo;

  AccountUseCase({required this.accountRepo, required this.localRepo});

  // Future<String?> login({
  //   required String username,
  //   required String password,
  // }) async {
  //   return await accountRepo.login(username: username, password: password);
  // }
  //
  // Future<void> saveToken(String token) async {
  //   await localRepo.saveToken(token);
  // }
  //
  // String? getToken() {
  //   return localRepo.getToken();
  // }
  //
  // Future<void> saveCustomerInformation(CustomerModel customerModel) async {
  //   await localRepo.saveCustomerInformation(customerModel);
  // }
  //
  // CustomerModel? getCustomerInformationLocal() {
  //   return localRepo.getCustomerInformation();
  // }
  //
  // Future<CustomerModel?> getCustomerInformation() async {
  //   String? token = getToken();
  //
  //   return token == null ? null : await accountRepo.getCustomerInfor(token);
  // }
  //
  // Future<void> saveEmail(String email) async {
  //   await localRepo.saveEmail(email);
  // }
  //
  // Future<void> savePass(String password) async {
  //   await localRepo.savePass(password);
  // }
  //
  // Future<String?> getSecureData(String key) async {
  //   return await localRepo.getSecureData(key);
  // }
  //
  // Future<bool> register({
  //   required String username,
  //   required String password,
  //   required String firstName,
  //   required String lastName,
  // }) async {
  //   return await accountRepo.register(
  //     username: username,
  //     password: password,
  //     firstName: firstName,
  //     lastName: lastName,
  //   );
  // }
  //
  // Future<void> logout() async {
  //   return await localRepo.logout();
  // }
  //
  // Future<CustomerModel?> updateCustomer(
  //     {required CustomerModel customer}) async {
  //   return await accountRepo.updateCustomer(customer: customer);
  // }
  //
  // Future<bool> changePassword({
  //   required String currentPassword,
  //   required String newPassword,
  // }) async {
  //   String? token = getToken();
  //
  //   return token == null
  //       ? false
  //       : await accountRepo.changePassword(
  //           token: token,
  //           currentPassword: currentPassword,
  //           newPassword: newPassword);
  // }


}
