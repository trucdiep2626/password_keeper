// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
// import 'package:mockito/mockito.dart';
// import 'package:password_keeper/common/config/app_config.dart';
// import 'package:password_keeper/common/constants/constants.dart';
// import 'package:password_keeper/common/constants/enums.dart';
// import 'package:password_keeper/data/password_repository.dart';
// import 'package:password_keeper/domain/models/account.dart';
// import 'package:password_keeper/domain/models/generated_password_item.dart';
// import 'package:password_keeper/domain/models/logged_in_device.dart';
// import 'package:password_keeper/domain/models/password_generation_option.dart';
// import 'package:password_keeper/domain/models/password_model.dart';
// import 'package:test/test.dart';
//
// class MockFirebaseFirestore extends Mock implements FirebaseFirestore {}
//
// class MockAccount extends Mock implements Account {}
//
// class MockUserCredential extends Mock implements UserCredential {}
//
// class MockQuerySnapshot extends Mock implements QuerySnapshot {}
//
// class FakeAuthCredential implements AuthCredential {
//   @override
//   dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
// }
//
// const _email = 'yuiran.yr@gmail.com';
// const _uid = 'mock_uid';
// const _displayName = 'Truc Diep';
// const _password = '1234567';
// const _masterPasswordHint = 'masterPasswordHint';
// final _mockUser = MockUser(
//   uid: _uid,
//   email: _email,
//   displayName: _displayName,
// );
//
// final _mockOption = PasswordGenerationOptions();
//
// final _mockGeneratedPassword = GeneratedPasswordItem(
//   password: 'password',
//   createdAt: DateTime.now().millisecondsSinceEpoch,
//   id: '1',
// );
//
// final _mockDevice = LoggedInDevice(
//   deviceId: '123',
//   showChangedMasterPassword: false,
// );
//
// final _mockPassword = PasswordItem(
//   id: '1',
//   password: '123',
//   passwordStrengthLevel: PasswordStrengthLevel.strong,
//   createdAt: DateTime.now().millisecondsSinceEpoch,
//   updatedAt: DateTime.now().millisecondsSinceEpoch,
//   recentUsedAt: DateTime.now().millisecondsSinceEpoch,
//   signInLocation: 'google',
//   androidPackageName: 'google',
// );
//
// final _mockAccount = Account(
//   id: _uid,
//   userId: _uid,
//   email: _email,
//   hashedMasterPassword: 'hashedMasterPassword',
//   masterPasswordHint: _masterPasswordHint,
//   key: 'key',
//   kdfIterations: 1000,
//   kdfMemory: 1000,
//   kdfParallelism: 1000,
//   timeoutSetting: 1000,
//   name: _displayName,
//   allowScreenCapture: true,
// );
//
// final _mockPasswordHintEmail = {
//   "to": _email,
//   "message": {
//     "subject": Constants.masterPasswordHintMailTitle,
//     "html": Constants.masterPasswordHintMailTemplate(
//         masterPwd: _masterPasswordHint),
//   },
// };
//
// final _mockSendChangedMasterPasswordNotice = {
//   "to": _email,
//   "message": {
//     "subject": Constants.changedMasterPasswordMailTitle,
//     "html": Constants.changedMasterPasswordMailTemplate(
//       account: _email,
//       updatedAt: '11/11/2011',
//       name: _displayName,
//       device: 'phone',
//     ),
//   },
// };
//
// Future<void> setDummyFirestore(FirebaseFirestore firestore) async {
//   //set up password generation option
//   await firestore
//       .collection(AppConfig.userCollection)
//       .doc(_uid)
//       .collection(AppConfig.passwordGenerationOptionCollection)
//       .doc(AppConfig.passwordGenerationOptionCollection)
//       .set(_mockOption.toJson());
//
//   //set up generated password
//   await firestore
//       .collection(AppConfig.userCollection)
//       .doc(_uid)
//       .collection(AppConfig.generatedPasswordsCollection)
//       .doc(_mockGeneratedPassword.id)
//       .set(_mockGeneratedPassword.toJson());
//
//   //set up password item
//   await firestore
//       .collection(AppConfig.userCollection)
//       .doc(_uid)
//       .collection(AppConfig.passwordsCollection)
//       .doc(_mockPassword.id)
//       .set(_mockPassword.toJson());
//
//   //set up device
//   await firestore
//       .collection(AppConfig.userCollection)
//       .doc(_uid)
//       .collection(AppConfig.devicesCollection)
//       .doc(_mockDevice.deviceId)
//       .set(_mockDevice.toJson());
// }
//
// void main() {
//   final mockFirebaseFirestore = FakeFirebaseFirestore();
//
//   final passwordRepository = PasswordRepository(
//     db: mockFirebaseFirestore,
//   );
//
//   setUp(() async {
//     await setDummyFirestore(mockFirebaseFirestore);
//   });
//
//   group('PasswordRepository', () {
//     group('Password Generation Option', () {
//       test('Get password generation option', () async {
//         final result =
//             await passwordRepository.getPasswordGenerationOption(userId: _uid);
//
//         expect(result, isInstanceOf<PasswordGenerationOptions>());
//       });
//
//       test('Updates password generation option', () async {
//         await passwordRepository.setPasswordGenerationOption(
//             userId: _uid, option: _mockOption);
//         final result =
//             await passwordRepository.getPasswordGenerationOption(userId: _uid);
//         expect(result, isInstanceOf<PasswordGenerationOptions>());
//       });
//     });
//
//     group('Generated Password', () {
//       test('Add Generated Password', () async {
//         final doc = await passwordRepository.addGeneratedPassword(
//             userId: _uid, passwordItem: _mockGeneratedPassword);
//
//         final result =
//             await passwordRepository.getGeneratedPasswordHistory(userId: _uid);
//
//         expect(result.where((element) => element.id == doc.id).length, 1);
//       });
//
//       test('getGeneratedPasswordHistoryLength', () async {
//         final result = await passwordRepository
//             .getGeneratedPasswordHistoryLength(userId: _uid);
//         expect(result, 2);
//       });
//
//       test('deleteOldestGeneratedHistory', () async {
//         final result =
//             await passwordRepository.deleteOldestGeneratedHistory(userId: _uid);
//         expect(result, true);
//       });
//
//       test('getLatestGeneratedHistory', () async {
//         final result =
//             await passwordRepository.getLatestGeneratedHistory(userId: _uid);
//         expect(result, isA<GeneratedPasswordItem>());
//       });
//
//       test('getGeneratedPasswordHistory', () async {
//         final doc = await passwordRepository.addGeneratedPassword(
//             userId: _uid,
//             passwordItem: _mockGeneratedPassword.copyWith(
//                 createdAt: DateTime.now().millisecondsSinceEpoch + 1000));
//
//         final resultWithPageSize = await passwordRepository
//             .getGeneratedPasswordHistory(userId: _uid, pageSize: 1);
//         expect(resultWithPageSize.length, 1);
//
//         final result = await passwordRepository.getGeneratedPasswordHistory(
//           userId: _uid,
//         );
//         expect(result.length, 3);
//
//         final lastItem =
//             await passwordRepository.getLatestGeneratedHistory(userId: _uid);
//
//         final resultWithStartAfter =
//             await passwordRepository.getGeneratedPasswordHistory(
//           userId: _uid,
//           lastItem: lastItem,
//           pageSize: 1,
//         );
//         expect(resultWithStartAfter.length, 0);
//       });
//
//       // test('updateGeneratedPasswordList', () async {
//       //   await passwordRepository.updateGeneratedPasswordList(
//       //       userId: _uid,
//       //       passwords: [_mockGeneratedPassword.copyWith(password: '12345')]);
//       //   final result =
//       //       await passwordRepository.getGeneratedPasswordHistory(userId: _uid);
//       //   expect(result.first.password, '12345');
//       // });
//     });
//
//     group('Password', () {
//       test('Add Password', () async {
//         final doc = await passwordRepository.addPasswordItem(
//             userId: _uid, passwordItem: _mockPassword);
//
//         final result = await passwordRepository.getPasswordList(userId: _uid);
//
//         expect(result.where((element) => element.id == doc.id).length, 1);
//       });
//
//       test('getPasswordList', () async {
//         final doc = await passwordRepository.addPasswordItem(
//             userId: _uid,
//             passwordItem: _mockPassword.copyWith(
//                 createdAt: DateTime.now().millisecondsSinceEpoch + 1000));
//
//         final resultWithPageSize =
//             await passwordRepository.getPasswordList(userId: _uid, pageSize: 1);
//         expect(resultWithPageSize.length, 1);
//
//         final result = await passwordRepository.getPasswordList(
//           userId: _uid,
//         );
//         expect(result.length, 3);
//
//         final resultWithStartAfter = await passwordRepository.getPasswordList(
//           userId: _uid,
//           lastItem: result.first,
//           pageSize: 1,
//         );
//         expect(resultWithStartAfter.length, 1);
//       });
//
//       // test('updatePasswordList', () async {
//       //   await passwordRepository.updatePasswordList(
//       //       userId: _uid,
//       //       passwords: [_mockPassword.copyWith(password: '12345')]);
//       //   final result = await passwordRepository.getPasswordList(userId: _uid);
//       //   expect(result.first.password, '12345');
//       // });
//
//       test('getPasswordListLength', () async {
//         final result =
//             await passwordRepository.getPasswordListLength(userId: _uid);
//         expect(result, 3);
//       });
//
//       test('deletePassword', () async {
//         final result = await passwordRepository.deletePassword(
//             userId: _uid, itemId: _mockPassword.id ?? '');
//         expect(result, true);
//       });
//
//       test('getPasswordListByName', () async {
//         final resultBySignInLocation =
//             await passwordRepository.getPasswordListByName(
//                 userId: _uid, name: _mockPassword.signInLocation ?? '');
//         expect(resultBySignInLocation.length, 3);
//
//         final resultByAndroidPackageName =
//             await passwordRepository.getPasswordListByName(
//                 userId: _uid, name: _mockPassword.androidPackageName ?? '');
//         expect(resultByAndroidPackageName.length, 3);
//       });
//
//       test('editPasswordItem', () async {
//         await passwordRepository.editPasswordItem(
//             userId: _uid,
//             passwordItem: _mockPassword.copyWith(password: '12345'));
//         final result = await passwordRepository.getPasswordList(userId: _uid);
//         expect(
//             result
//                 .where((element) => (element.password ?? '') == '12345')
//                 .length,
//             1);
//       });
//
//       test('updateRecentUsedPassword', () async {
//         final recentUsedAt = DateTime.now().millisecondsSinceEpoch + 9999;
//         await passwordRepository.updateRecentUsedPassword(
//             userId: _uid,
//             password: _mockPassword.copyWith(recentUsedAt: recentUsedAt));
//         final result = await passwordRepository.getPasswordList(userId: _uid);
//         expect(
//             result
//                 .where((element) => (element.recentUsedAt ?? 0) == recentUsedAt)
//                 .length,
//             1);
//       });
//
//       test('getRecentUsedList', () async {
//         final result = await passwordRepository.getRecentUsedList(
//           userId: _uid,
//         );
//         expect(result.length, 3);
//       });
//     });
//
//     group('Logged in device', () {
//       test('addLoggedInDevice', () async {
//         final doc = await passwordRepository.addLoggedInDevice(
//           userId: _uid,
//           loggedInDevice: _mockDevice,
//         );
//
//         final result = await passwordRepository.getLoggedInDevice(
//           userId: _uid,
//           deviceId: _mockDevice.deviceId ?? '',
//         );
//
//         expect(result, isA<LoggedInDevice>());
//       });
//
//       test('updateAllLoggedDevice', () async {
//         await passwordRepository.updateAllLoggedDevice(userId: _uid);
//         final result = await passwordRepository.getLoggedInDevice(
//             userId: _uid, deviceId: _mockDevice.deviceId ?? '');
//         expect(result?.showChangedMasterPassword, true);
//       });
//
//       test('deleteLoggedInDevice', () async {
//         await passwordRepository.deleteLoggedInDevice(
//             userId: _uid, deviceId: _mockDevice.deviceId ?? '');
//         final result = await passwordRepository.getLoggedInDevice(
//           userId: _uid,
//           deviceId: _mockDevice.deviceId ?? '',
//         );
//
//         expect(result, null);
//       });
//
//       test('updateLoggedInDevice', () async {
//         await passwordRepository.updateLoggedInDevice(
//           userId: _uid,
//           loggedInDevice:
//               _mockDevice.copyWith(showChangedMasterPassword: false),
//         );
//         final result = await passwordRepository.getLoggedInDevice(
//             userId: _uid, deviceId: _mockDevice.deviceId ?? '');
//         expect(result?.showChangedMasterPassword, false);
//       });
//     });
//   });
// }
//
// // group('Password Repository', () {
// //   test('createUser', () async {
// //     final doc1 = await accountRepository.createUser(_mockAccount);
// //
// //     final result =
// //         await accountRepository.getProfile(userId: _mockAccount.userId ?? '');
// //     expect(result?.name, _mockAccount.name);
// //   });
// //
// //   test('Updates profile', () async {
// //     await accountRepository.editProfile(_mockAccount.copyWith(name: "Diep"));
// //
// //     final result =
// //         await accountRepository.getProfile(userId: _mockAccount.userId ?? '');
// //     expect(result?.name, equals("Diep"));
// //   });
// //
// //   test('Get profile', () async {
// //     setDummyFirestore(mockFirebaseFirestore);
// //
// //     final result =
// //         await accountRepository.getProfile(userId: _mockAccount.userId ?? '');
// //
// //     expect(result, isInstanceOf<Account>());
// //   });
// //
// //   group('allow screen capture', () {
// //     test('Get allow screen capture', () async {
// //       final result = await accountRepository.getAllowScreenCapture(
// //           usedId: _mockAccount.userId ?? '');
// //
// //       expect(result, true);
// //     });
// //
// //     test('Updates allow screen capture', () async {
// //       // setDummyFirestore(mockFirebaseFirestore);
// //       await accountRepository.updateAllowScreenCapture(
// //           userId: _uid, value: true);
// //
// //       final result = await accountRepository.getProfile(
// //           userId: _mockAccount.userId ?? '');
// //       expect(result?.allowScreenCapture, true);
// //     });
// //   });
// //
// //   group('timeout setting', () {
// //     test('Get timeout setting', () async {
// //       final result = await accountRepository.getTimeoutSetting(
// //           usedId: _mockAccount.userId ?? '');
// //
// //       expect(result, _mockAccount.timeoutSetting);
// //     });
// //
// //     test('Updates timeout setting', () async {
// //       await accountRepository.updateTimeoutSetting(
// //           userId: _uid, timeout: 100);
// //
// //       final result = await accountRepository.getProfile(
// //           userId: _mockAccount.userId ?? '');
// //       expect(result?.timeoutSetting, 100);
// //     });
// //   });
// //
// //   test('Get master password hint', () async {
// //     final result = await accountRepository.getPasswordHint(
// //         userId: _mockAccount.userId ?? '');
// //
// //     expect(result, _mockAccount.masterPasswordHint);
// //   });
// //
// //   test('send Master Password Hint', () async {
// //     final doc =
// //         await accountRepository.sendPasswordHint(email: _email, userId: _uid);
// //
// //     final result = await accountRepository.db
// //         .collection(AppConfig.mailCollection)
// //         .doc(doc.id)
// //         .get();
// //     expect(result.data(), _mockPasswordHintEmail);
// //   });
// //
// //   test('send Changed Master Password Notice', () async {
// //     final doc = await accountRepository.sendChangedMasterPasswordNotice(
// //       account: _email,
// //       device: 'phone',
// //       name: _displayName,
// //       updatedAt: '11/11/2011',
// //     );
// //
// //     final result = await accountRepository.db
// //         .collection(AppConfig.mailCollection)
// //         .doc(doc.id)
// //         .get();
// //     expect(result.data(), _mockSendChangedMasterPasswordNotice);
// //   });
// // });
// //}
