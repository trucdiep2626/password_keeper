import 'package:get/get.dart';
import 'package:password_keeper/common/constants/constants.dart';
import 'package:password_keeper/common/constants/enums.dart';
import 'package:password_keeper/domain/models/account.dart';
import 'package:password_keeper/domain/models/storage_options.dart';
import 'package:password_keeper/domain/models/symmetric_crypto_key.dart';
import 'package:password_keeper/presentation/controllers/mixin/mixin_controller.dart';

class StateController extends GetxController with MixinController {
  Future<String?> getEncKeyEncrypted({String? userId}) async {
    var reconciledOptions = reconcileOptions(
      requestedOptions: StorageOptions(userId: userId),
      defaultOptions: await getDefaultStorageOptions(),
    );

    return await getValue(
      Constants.encKeyKey(reconciledOptions.userId ?? ''),
      reconciledOptions,
    );
  }

  StorageOptions reconcileOptions(
      {StorageOptions? requestedOptions,
      required StorageOptions defaultOptions}) {
    if (requestedOptions == null) {
      return defaultOptions;
    }

    return requestedOptions
      ..copyWith(
        storageLocation:
            requestedOptions.storageLocation ?? defaultOptions.storageLocation,
        useSecureStorage: requestedOptions.useSecureStorage ??
            defaultOptions.useSecureStorage,
        userId: requestedOptions.userId ?? defaultOptions.userId,
        email: requestedOptions.email ?? defaultOptions.email,
        skipTokenStorage: requestedOptions.skipTokenStorage ??
            defaultOptions.skipTokenStorage,
      );
  }

  StorageOptions getDefaultStorageOptions() {
    return StorageOptions(
      storageLocation: StorageLocation.both,
    );
    // {
    //   StorageLocation = StorageLocation.Both,
    // UserId = await GetActiveUserIdAsync(),
    // };
  }

  Future getValue(String key, StorageOptions options) async {
    // return await GetStorageService(options).GetAsync<T>(key);
  }

  void getStorageService(StorageOptions options) {
    // return options.UseSecureStorage.GetValueOrDefault(false) ? _secureStorageService : _storageService;
  }

  // State GetStateFromStorageAsync() {
  //   return await _storageService.GetAsync<State>(Constants.StateKey);
  // }

  Future<String> getKeyEncrypted({String? userId}) async {
    var reconciledOptions = reconcileOptions(
      requestedOptions: StorageOptions(userId: userId),
      defaultOptions: await getDefaultSecureStorageOptions(),
    );

    return await getValue(
      Constants.keyKey(reconciledOptions.userId ?? ''),
      reconciledOptions,
    );
  }

  Future<void> setKeyEncrypted(String value, String userId) async {
    var reconciledOptions = reconcileOptions(
      requestedOptions: StorageOptions(userId: userId),
      defaultOptions: await getDefaultSecureStorageOptions(),
    );

    await setValue(
      key: Constants.keyKey(reconciledOptions.userId ?? ''),
      value: value,
      options: reconciledOptions,
    );
  }

  Future<SymmetricCryptoKey?> getKeyDecrypted({String? userId}) async {
    var reconciledOptions = reconcileOptions(
      requestedOptions: StorageOptions(userId: userId),
      defaultOptions: await getDefaultInMemoryOptions(),
    );

    var account = await getAccount(options: reconciledOptions);
    return account?.volatileData?.key;
  }

  Future<void> setKeyDecrypted(SymmetricCryptoKey value,
      {String? userId}) async {
    var reconciledOptions = reconcileOptions(
      requestedOptions: StorageOptions(userId: userId),
      defaultOptions: await getDefaultInMemoryOptions(),
    );

    var account = await getAccount(options: reconciledOptions);
    account?.volatileData?.key = value;
    await saveAccount(account: account, options: reconciledOptions);
  }

  StorageOptions getDefaultSecureStorageOptions() {
    return StorageOptions(
      storageLocation: StorageLocation.disk,
      useSecureStorage: true,
    );
    //   {
    //     StorageLocation = StorageLocation.Disk,
    //   UseSecureStorage = true,
    //   UserId = await GetActiveUserIdAsync(),
    // };
  }

  StorageOptions getDefaultInMemoryOptions() {
    return StorageOptions(
      storageLocation: StorageLocation.memory,
    );
    // {
    //   StorageLocation = StorageLocation.Memory,
    // UserId = await GetActiveUserIdAsync(),
    // };
  }

  Future setValue({String? key, dynamic value, StorageOptions? options}) async {
    if (value == null) {
      //  await getStorageService(options).RemoveAsync(key);
      return;
    }
    //  await getStorageService(options).SaveAsync(key, value);
  }

  Future<Account?> getAccount({StorageOptions? options}) async {
    await checkState();

    if (options?.userId == null) {
      return null;
    }

    // // Memory
    // if (_state?.Accounts?.ContainsKey(options.UserId) ?? false)
    // {
    //   if (_state.Accounts[options.UserId].VolatileData == null)
    //   {
    //     _state.Accounts[options.UserId].VolatileData = new Account.AccountVolatileData();
    //   }
    //   return _state.Accounts[options.UserId];
    // }
    //
    // // Storage
    // var state = await GetStateFromStorageAsync();
    // if (state?.Accounts?.ContainsKey(options.UserId) ?? false)
    // {
    //   state.Accounts[options.UserId].VolatileData = new Account.AccountVolatileData();
    //   return state.Accounts[options.UserId];
    // }

    return null;
  }

  Future saveAccount({Account? account, StorageOptions? options}) async {
    if (account?.profile?.userId == null) {
      throw new Exception("account?.Profile?.UserId cannot be null");
    }

    await checkState();

    // Memory
    if (useMemory(options: options)) {
      // if (_state.Accounts == null)
      // {
      // _state.Accounts = new Dictionary<string, Account>();
      // }
      // _state.Accounts[account.Profile.UserId] = account;
    }

    // Storage
    if (useDisk(options: options)) {
      // var state = await getStateFromStorageAsync() ?? new State();
      // if (state.Accounts == null)
      // {
      // state.Accounts = new Dictionary<string, Account>();
      // }
      //
      // // Use Account copy constructor to clone with keys excluded (for storage)
      // state.Accounts[account.Profile.UserId] = new Account(account);
      //
      // // If we have a vault timeout and the action is log out, don't store token
      // if (options?.SkipTokenStorage.GetValueOrDefault() ?? false)
      // {
      // state.Accounts[account.Profile.UserId].Tokens.AccessToken = null;
      // state.Accounts[account.Profile.UserId].Tokens.RefreshToken = null;
      // }
      //
      // await SaveStateToStorageAsync(state);
    }
  }

  Future<Map<String, String>> getOrgKeysEncrypted({String? userId}) async {
    {
      var reconciledOptions = await reconcileOptions(
        requestedOptions: StorageOptions(userId: userId),
        defaultOptions: await getDefaultStorageOptions(),
      );

      return await getValue(
        Constants.encOrgKeysKey(reconciledOptions.userId ?? ''),
        reconciledOptions,
      );
    }
  }

  Future<void> setOrgKeysEncrypted(
      {Map<String, String>? value, String? userId}) async {
    var reconciledOptions = await reconcileOptions(
      requestedOptions: StorageOptions(userId: userId),
      defaultOptions: await getDefaultStorageOptions(),
    );
    await setValue(
        key: Constants.encOrgKeysKey(reconciledOptions.userId ?? ''),
        value: value,
        options: reconciledOptions);
  }

  Future<String> getPrivateKeyEncrypted({String? userId}) async {
    var reconciledOptions = await reconcileOptions(
      requestedOptions: StorageOptions(userId: userId),
      defaultOptions: await getDefaultStorageOptions(),
    );
    return await getValue(
        Constants.encPrivateKeyKey(reconciledOptions.userId ?? ''),
        reconciledOptions);
  }

  Future setPrivateKeyEncrypted({required String value, String? userId}) async {
    var reconciledOptions = await reconcileOptions(
      requestedOptions: StorageOptions(userId: userId),
      defaultOptions: await getDefaultStorageOptions(),
    );
    await setValue(
        key: Constants.encPrivateKeyKey(reconciledOptions.userId ?? ''),
        value: value,
        options: reconciledOptions);
  }

  Future checkState() async {
    // if (!_migrationChecked)
    // {
    //   var migrationService = ServiceContainer.Resolve<IStateMigrationService>();
    //   await migrationService.MigrateIfNeededAsync();
    //   _migrationChecked = true;
    // }
    //
    // if (_state == null)
    // {
    //   _state = await GetStateFromStorageAsync() ?? new State();
    // }
  }

  bool useMemory({StorageOptions? options}) {
    return options?.storageLocation == StorageLocation.memory ||
        options?.storageLocation == StorageLocation.both;
  }

  bool useDisk({StorageOptions? options}) {
    return options?.storageLocation == StorageLocation.disk ||
        options?.storageLocation == StorageLocation.both;
  }
}
