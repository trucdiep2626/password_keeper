// import 'package:get/get.dart';
// import 'package:password_keeper/common/constants/constants.dart';
// import 'package:password_keeper/common/constants/enums.dart';
// import 'package:password_keeper/domain/models/storage_options.dart';
// import 'package:password_keeper/domain/models/symmetric_crypto_key.dart';
// import 'package:password_keeper/domain/usecases/account_usecase.dart';
// import 'package:password_keeper/domain/usecases/local_usecase.dart';
// import 'package:password_keeper/presentation/controllers/mixin/mixin_controller.dart';
//
// class StateController extends GetxController with MixinController {
//   AccountUseCase accountUseCase;
//   LocalUseCase localUseCase;
//
//   StateController({
//     required this.accountUseCase,
//     required this.localUseCase,
//   });
//
//
//
//   // StorageOptions getDefaultSecureStorageOptions() {
//   //   return StorageOptions(
//   //     storageLocation: StorageLocation.disk,
//   //     useSecureStorage: true,
//   //   );
//   //   //   {
//   //   //     StorageLocation = StorageLocation.Disk,
//   //   //   UseSecureStorage = true,
//   //   //   UserId = await GetActiveUserIdAsync(),
//   //   // };
//   // }
//
//   // StorageOptions getDefaultInMemoryOptions() {
//   //   return StorageOptions(
//   //     storageLocation: StorageLocation.memory,
//   //   );
//   //   // {
//   //   //   StorageLocation = StorageLocation.Memory,
//   //   // UserId = await GetActiveUserIdAsync(),
//   //   // };
//   // }
//
//   Future setValue({String? key, dynamic value, StorageOptions? options}) async {
//     if (value == null) {
//       //  await getStorageService(options).RemoveAsync(key);
//       return;
//     }
//     //  await getStorageService(options).SaveAsync(key, value);
//   }
//
//   // Future<Map<String, String>> getOrgKeysEncrypted({String? userId}) async {
//   //   {
//   //     return await localUseCase.getLocalValue(
//   //       key: Constants.encOrgKeysKey(userId ?? ''),
//   //     );
//   //   }
//   // }
//   //
//   // Future<void> setOrgKeysEncrypted(
//   //     {Map<String, String>? value, String? userId}) async {
//   //   await localUseCase.setLocalValue(
//   //     key: Constants.encOrgKeysKey(userId ?? ''),
//   //     value: value,
//   //   );
//   // }
//   //
//   // Future<String> getPrivateKeyEncrypted({String? userId}) async {
//   //   return await localUseCase.getLocalValue(
//   //     key: Constants.encPrivateKeyKey(userId ?? ''),
//   //   );
//   // }
//   //
//   // Future setPrivateKeyEncrypted({required String value, String? userId}) async {
//   //   await localUseCase.setLocalValue(
//   //     key: Constants.encPrivateKeyKey(userId ?? ''),
//   //     value: value,
//   //   );
//   // }
//
//   // Future<UserKey> getUserKeyAsync({String userId}) async {
//   //   var options = await getAccountAsync(reconcileOptions(
//   //       StorageOptions(userId: userId),
//   //       await getDefaultInMemoryOptionsAsync()));
//   //   return options?.volatileData?.userKey;
//   // }
//   //
//   // Future<void> setUserKeyAsync(UserKey value, {String userId}) async {
//   //   var reconciledOptions = reconcileOptions(
//   //       StorageOptions(userId: userId), await getDefaultInMemoryOptionsAsync());
//   //   var account = await getAccountAsync(reconciledOptions);
//   //   account.volatileData.userKey = value;
//   //   await saveAccountAsync(account, reconciledOptions);
//   // }
//
//   // Future checkState() async {
//   //   // if (!_migrationChecked)
//   //   // {
//   //   //   var migrationService = ServiceContainer.Resolve<IStateMigrationService>();
//   //   //   await migrationService.MigrateIfNeededAsync();
//   //   //   _migrationChecked = true;
//   //   // }
//   //   //
//   //   // if (_state == null)
//   //   // {
//   //   //   _state = await GetStateFromStorageAsync() ?? new State();
//   //   // }
//   // }
//   //
//   // bool useMemory({StorageOptions? options}) {
//   //   return options?.storageLocation == StorageLocation.memory ||
//   //       options?.storageLocation == StorageLocation.both;
//   // }
//   //
//   // bool useDisk({StorageOptions? options}) {
//   //   return options?.storageLocation == StorageLocation.disk ||
//   //       options?.storageLocation == StorageLocation.both;
//   // }
// }
