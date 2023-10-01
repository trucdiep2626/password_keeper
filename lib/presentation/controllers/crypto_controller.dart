import 'dart:convert';
import 'dart:math' as math;
import 'dart:math';
import 'dart:typed_data';

//import 'package:argon2/argon2.dart' as argon2;
import 'package:dargon2_flutter/dargon2_flutter.dart' as dargon2;
import 'package:get/get.dart';
import 'package:password_keeper/common/config/database/local_key.dart';
import 'package:password_keeper/common/constants/constants.dart';
import 'package:password_keeper/common/constants/enums.dart';
import 'package:password_keeper/common/utils/app_utils.dart';
import 'package:password_keeper/domain/models/argon2_params.dart';
import 'package:password_keeper/domain/models/enc_key_result.dart';
import 'package:password_keeper/domain/models/encrypted_object.dart';
import 'package:password_keeper/domain/models/encrypted_string.dart';
import 'package:password_keeper/domain/models/protected_value.dart';
import 'package:password_keeper/domain/models/symmetric_crypto_key.dart';
import 'package:password_keeper/domain/usecases/account_usecase.dart';
import 'package:password_keeper/domain/usecases/local_usecase.dart';
import 'package:password_keeper/presentation/controllers/mixin/mixin_controller.dart';
import 'package:pointycastle/export.dart';
import 'package:pointycastle/pointycastle.dart';

class CryptoController extends GetxController with MixinController {
  final sha256Digester = SHA256Digest();

  String randomStringCharset = "abcdefghijklmnopqrstuvwxyz1234567890";

  LocalUseCase localUseCase;
  AccountUseCase accountUseCase;

  CryptoController({
    required this.localUseCase,
    required this.accountUseCase,
  }); // private SymmetricCryptoKey _encKey;
  // private SymmetricCryptoKey _legacyEtmKey;
  // private string _keyHash;
  // private byte[] _publicKey;
  // private byte[] _privateKey;
  // private Dictionary<string, SymmetricCryptoKey> _orgKeys;
  // private Task<SymmetricCryptoKey> _getEncKeysTask;
  // private Task<Dictionary<string, SymmetricCryptoKey>> _getOrgKeysTask;

//  SymmetricCryptoKey? _encKey;
  SymmetricCryptoKey? _legacyEtmKey;
  // String? _keyHash;
  // Uint8List? _publicKey;
  // Uint8List? _privateKey;
  // Map<String, SymmetricCryptoKey>? _orgKeys;
  // Future<SymmetricCryptoKey?>? _getEncKeysFunction;
  // Future<Map<String, SymmetricCryptoKey>?>? _getOrgKeysFunction;

  // Future<String> hashString(String text, [String salt = '']) async {
  //   final msgBuffer = utf8.encode(salt + text);
  //   final hash = sha256Digester.process(Uint8List.fromList(msgBuffer));
  //   return base64.encode(hash);
  // }
  //
  // Future<String> hashBytes(Uint8List bytes) async {
  //   final hash = sha256Digester.process(bytes);
  //   return base64.encode(hash);
  // }
  //
  // Future<String> hashStringToHex(String text, [String salt = '']) async {
  //   final msgBuffer = utf8.encode(salt + text);
  //   final hash = sha256Digester.process(Uint8List.fromList(msgBuffer));
  //   return hex.encode(hash);
  // }
  //
  Future<String> stretchByteArray(List<int> byteArray, String salt) async {
    final saltArray = base64.decode(base64.normalize(salt));
    Uint8List derivedKey = Uint8List(32);
    final pbkdf2 = PBKDF2KeyDerivator(HMac(SHA256Digest(), 64));
    pbkdf2.init(Pbkdf2Parameters(saltArray, 500, 32));
    pbkdf2.deriveKey(Uint8List.fromList(byteArray), 0, derivedKey, 0);
    return base64.encode(derivedKey);
  }

  Future<SymmetricCryptoKey> stretchKey(SymmetricCryptoKey key) async {
    final newKey = Uint8List(64);
    final enc = await hkdfExpand(
        prk: key.key!,
        info: Uint8List.fromList(utf8.encode("enc")),
        outputByteSize: 32,
        algorithm: HkdfAlgorithm.sha256);
    newKey.setRange(0, 32, enc);

    final mac = await hkdfExpand(
        prk: key.key!,
        info: Uint8List.fromList(utf8.encode("mac")),
        outputByteSize: 32,
        algorithm: HkdfAlgorithm.sha256);
    newKey.setRange(32, 64, mac);

    return SymmetricCryptoKey(key: newKey);
  }

  Future<Uint8List> hkdfExpand(
      {required Uint8List prk,
      required Uint8List info,
      required int outputByteSize,
      required HkdfAlgorithm algorithm}) async {
    var hashLen = algorithm == HkdfAlgorithm.sha256 ? 32 : 64;

    var maxOutputByteSize = 255 * hashLen;
    if (outputByteSize > maxOutputByteSize) {
      throw ArgumentError(
          "${(outputByteSize)} is too large. Max is $maxOutputByteSize, received $outputByteSize");
    }
    if (prk.length < hashLen) {
      throw ArgumentError(
          "${(prk)} length is too small. Must be at least $hashLen for $algorithm");
    }

    var cryptoHashAlgorithm = hkdfAlgorithmToCryptoHashAlgorithm(algorithm);
    var previousT = Uint8List(0);
    var runningOkmLength = 0;
    final n = (outputByteSize / hashLen).ceil();
    final okm = Uint8List(n * hashLen);
    for (var i = 0; i < n; i++) {
      // var t = byte[previousT.Length + info.Length + 1];
      // previousT.CopyTo(t, 0);
      // info.CopyTo(t, previousT.Length);
      // t[t.Length - 1] = (byte)(i + 1);
      // previousT = await HmacAsync(t, prk, cryptoHashAlgorithm);
      // previousT.CopyTo(okm, runningOkmLength);
      // runningOkmLength = previousT.Length;
      final t = Uint8List.fromList([...previousT, ...info, i + 1]);
      t.setAll(0, [...previousT, ...info]);
      t[t.length - 1] = (i + 1);
      previousT = hmac(value: t, key: prk, algorithm: cryptoHashAlgorithm);
      okm.setAll(runningOkmLength, previousT);
      runningOkmLength = previousT.length;
      if (runningOkmLength >= outputByteSize) {
        break;
      }
    }
    return okm.sublist(0, outputByteSize);
  }

  CryptoHashAlgorithm hkdfAlgorithmToCryptoHashAlgorithm(
      HkdfAlgorithm? hkdfAlgorithm) {
    switch (hkdfAlgorithm) {
      case HkdfAlgorithm.sha256:
        return CryptoHashAlgorithm.sha256;
      case HkdfAlgorithm.sha512:
        return CryptoHashAlgorithm.sha512;
      default:
        throw ArgumentError("Invalid hkdf algorithm type, $hkdfAlgorithm");
    }
  }

  //
  // Future<String> derivePassKey(String email, List<int> hashedMasterKey) async {
  //   final emailHash = sha256Digester
  //       .process(Uint8List.fromList(utf8.encode(EMAIL_AUTH_SALT + email)));
  //   final passHash = sha256Digester.process(Uint8List.fromList(
  //       [...hex.decode(PASS_AUTH_SALT), ...hashedMasterKey]));
  //   return stretchByteArray([...emailHash, ...passHash], STRETCH_SALT);
  // }

  Future<SymmetricCryptoKey> makeMasterKey(
      {required String password,
      required String salt,
      Argon2Params? argon2Param}) async {
    Uint8List? key;
    // if (kdfConfig.Type == null || kdfConfig.Type == KdfType.PBKDF2_SHA256)
    // {
    //   var iterations = kdfConfig.Iterations.GetValueOrDefault(5000);
    //   if (iterations < 5000)
    //   {
    //     throw new Exception("PBKDF2 iteration minimum is 5000.");
    //   }
    //   key = await _cryptoFunctionService.Pbkdf2Async(password, salt,
    //       CryptoHashAlgorithm.Sha256, iterations);
    // }
    // else
    //   if (kdfConfig.Type == KdfType.Argon2id)
    {
      var iterations = argon2Param?.iterations ?? Constants.argon2Iterations;
      var memory = (argon2Param?.memory ?? Constants.argon2MemoryInMB) * 1024;
      var parallelism = argon2Param?.parallelism ?? Constants.argon2Parallelism;

      if (iterations < 2) {
        throw Exception("Argon2 iterations minimum is 2");
      }

      if (memory < 16 * 1024) {
        throw Exception("Argon2 memory minimum is 16 MB");
      } else if (memory > 1024 * 1024) {
        throw Exception("Argon2 memory maximum is 1024 MB");
      }

      if (parallelism < 1) {
        throw Exception("Argon2 parallelism minimum is 1");
      }

      var saltHash = ProtectedValue.fromString(salt).hash;

      //  log('Salt: ${saltHash.toHexString()}');

      key = await argon2FromStringPwd(
        password: password,
        salt: saltHash,
        iterations: iterations,
        parallelism: parallelism,
        memory: memory,
      );
      // }
      // else
      // {
      //   throw new Exception("Unknown kdf.");
      // }
      return SymmetricCryptoKey(key: key);
    }
  }

  Future<EncKeyResult?> makeEncKey(SymmetricCryptoKey key) async {
    var theKey = await getKeyForEncryption(key: key);
    var encKey = randomBytes(64);
    return await buildEncKey(key: theKey, encKey: encKey);
  }

  List<int> hash({required String value}) {
    return ProtectedValue.fromString(value).hash;
  }

  Future<EncKeyResult?> buildEncKey(
      {SymmetricCryptoKey? key, Uint8List? encKey}) async {
    if (key == null || encKey == null) {
      return null;
    }

    EncryptedString? encKeyEnc;
    if (key.key?.length == 32) {
      var newKey = await stretchKey(key);
      encKeyEnc = await encrypt(plainValue: encKey, key: newKey);
    } else if (key.key?.length == 64) {
      encKeyEnc = await encrypt(plainValue: encKey, key: key);
    } else {
      throw Exception("Invalid key size.");
    }

    return EncKeyResult(
        key: SymmetricCryptoKey(key: encKey), encKey: encKeyEnc);
  }

  Future<EncryptedString?> encryptString(
      {String? plainValue, SymmetricCryptoKey? key}) async {
    if (plainValue == null) {
      return null;
    }
    return await encrypt(
        plainValue: Uint8List.fromList(utf8.encode(plainValue)), key: key);
  }

  Future<EncryptedString?> encrypt(
      {Uint8List? plainValue, SymmetricCryptoKey? key}) async {
    if (plainValue == null) {
      return null;
    }

    var encObj = await aesEncryptWithRandomIv(data: plainValue, key: key);
    var iv = base64Encode(encObj.iv?.toList() ?? []);
    var data = base64Encode(encObj.data?.toList() ?? []);
    var mac =
        encObj.mac != null ? base64Encode(encObj.mac?.toList() ?? []) : null;

    return EncryptedString(
        encryptionType: encObj.key?.encType, data: data, iv: iv, mac: mac);
  }

  //  Task<byte[]> HashAsync(byte[] value, CryptoHashAlgorithm algorithm)
  // {
  // var provider = HashAlgorithmProvider.OpenAlgorithm(ToHashAlgorithm(algorithm));
  // return Task.FromResult(provider.HashData(value));
  // }
  //
  //  Task<byte[]> HmacAsync(byte[] value, byte[] key, CryptoHashAlgorithm algorithm)
  // {
  // var provider = MacAlgorithmProvider.OpenAlgorithm(ToMacAlgorithm(algorithm));
  // var hasher = provider.CreateHash(key);
  // hasher.Append(value);
  // return Task.FromResult(hasher.GetValueAndReset());
  // }

  Future<String> hashPassword(
      {required String password,
      SymmetricCryptoKey? key,
      HashPurpose hashPurpose = HashPurpose.serverAuthorization}) async {
    key ??= await getMasterKey();
    if (key == null) {
      throw Exception("Invalid parameters.");
    }
    var iterations = hashPurpose == HashPurpose.localAuthorization ? 2 : 1;
    //  var hash = argon2FromStringSalt(password: key.key!, salt: password, iterations: iterations, memory: memory, parallelism: parallelism)

    var hash = pbkdf2FromStringSalt(
      password: key.key!,
      salt: password,
      algorithm: CryptoHashAlgorithm.sha256,
      iterations: iterations,
    );
    //pbkdf2(key.key, password, CryptoHashAlgorithm.Sha256, iterations);
    return base64Encode(hash);
  }

  Uint8List pbkdf2FromString({
    required String password,
    required String salt,
    required CryptoHashAlgorithm algorithm,
    required int iterations,
  }) {
    password = normalizePassword(password);
    return pbkdf2(
      password: Uint8List.fromList(password.codeUnits),
      salt: Uint8List.fromList(salt.codeUnits),
      algorithm: algorithm,
      iterations: iterations,
    );
  }

  Uint8List pbkdf2FromStringSalt({
    required Uint8List password,
    required String salt,
    required CryptoHashAlgorithm algorithm,
    required int iterations,
  }) {
    return pbkdf2(
      password: password,
      salt: Uint8List.fromList(salt.codeUnits),
      algorithm: algorithm,
      iterations: iterations,
    );
  }

  Uint8List pbkdf2FromStringPassword({
    required String password,
    required Uint8List salt,
    required CryptoHashAlgorithm algorithm,
    required int iterations,
  }) {
    password = normalizePassword(password);
    return pbkdf2(
        password: Uint8List.fromList(password.codeUnits),
        salt: salt,
        algorithm: algorithm,
        iterations: iterations);
  }

  Uint8List pbkdf2({
    required Uint8List password,
    required Uint8List salt,
    required CryptoHashAlgorithm algorithm,
    required int iterations,
  }) {
    if (algorithm != CryptoHashAlgorithm.sha256 &&
        algorithm != CryptoHashAlgorithm.sha512) {
      throw ArgumentError("Unsupported PBKDF2 algorithm.");
    }
    // return Task.FromResult(
    //     _cryptoPrimitiveService.Pbkdf2(password, salt, algorithm, iterations));

    //  final saltArray = base64.decode(base64.normalize(salt));
    int keySize = 256;
    var digest;
    if (algorithm == CryptoHashAlgorithm.sha256) {
      keySize = 256;
      digest = SHA256Digest();
    } else if (algorithm == CryptoHashAlgorithm.sha512) {
      keySize = 512;
      digest = SHA512Digest();
    }

    var parameters = Pbkdf2Parameters(salt, iterations, keySize);

    Uint8List result = Uint8List(keySize);
    final pbkdf2 = PBKDF2KeyDerivator(HMac(digest, keySize));
    pbkdf2.init(parameters);
    pbkdf2.deriveKey(password, 0, result, 0);

    var resultHex = uint8ListToHexString(result);

    logger('Result: $resultHex');

    return result;
  }

  Future<Uint8List> argon2FromString({
    required String password,
    required String salt,
    required int iterations,
    required int memory,
    required int parallelism,
  }) {
    final convertedPassword = normalizePassword(password);
    return argon2FromByte(
      password: Uint8List.fromList(convertedPassword.codeUnits),
      salt: Uint8List.fromList(salt.codeUnits),
      iterations: iterations,
      memory: memory,
      parallelism: parallelism,
    );
  }

  Future<Uint8List> argon2FromStringSalt({
    required Uint8List password,
    required String salt,
    required int iterations,
    required int memory,
    required int parallelism,
  }) {
    return argon2FromByte(
      password: password,
      salt: Uint8List.fromList(salt.codeUnits),
      iterations: iterations,
      memory: memory,
      parallelism: parallelism,
    );
  }

  Future<Uint8List> argon2FromStringPwd({
    required String password,
    required Uint8List salt,
    required int iterations,
    required int memory,
    required int parallelism,
  }) async {
    final convertedPassword = normalizePassword(password);
    return await argon2FromByte(
      password: Uint8List.fromList(convertedPassword.codeUnits),
      salt: salt,
      iterations: iterations,
      memory: memory,
      parallelism: parallelism,
    );
  }

  Future<Uint8List> argon2FromByte({
    required Uint8List password,
    required Uint8List salt,
    required int iterations,
    required int memory,
    required int parallelism,
  }) async {
    int keySize = 32;
    //   var password = 'password';
    //use Salt(List<int> bytes) for a salt from an Integer list
    // var s = Salt.newSalt();
    //Hash with pre-set params (iterations: 32, memory: 256, parallelism: 2,
    //length: 32, type: Argon2Type.i, version: Argon2Version.V13)
    var result = await dargon2.argon2.hashPasswordBytes(password,
        salt: dargon2.Salt(salt),
        iterations: iterations,
        memory: memory,
        parallelism: parallelism,
        length: keySize,
        version: dargon2.Argon2Version.V13);

    //Raw hash values available as int list, base 64 string, and hex string
    //  var bytesRaw = result.rawBytes;
    // var base64Hash = result.base64String;
    //  var hexHash = result.encodedBytes;
    //Encoded hash values available as int list and encoded string
    var bytesEncoded = result.encodedBytes; // type: List<int>
    logger('Raw Encoded Bytes Array: $bytesEncoded');
    var stringEncoded = result.encodedString; // type: String
    logger('Encoded UTF-8 String: $stringEncoded');
    //size = 32
    // var parameters = argon2.Argon2Parameters(Argon2Parameters.ARGON2_i, salt,
    //     //    version: Argon2Parameters.ARGON2_i,
    //     iterations: 3,
    //     lanes: 4,
    //     memory: 64);
    // //922bf05a64fc0c3d3be8589a126551768628568c4f61038e59f8d13daf547ef2
    // logger('Parameters: $parameters');
    // //
    // var argon2BG = argon2.Argon2BytesGenerator();
    //
    // argon2BG.init(parameters);
    //
    // var passwordBytes = parameters.converter.convert('Abc@12345');
    //
    // logger('Generating key from password...');
    //
    // var result = Uint8List(32);
    // argon2BG.generateBytes(password, result, 0, result.length);
    //
    // var resultHex = result.toHexString();
    //
    // logger('Result: $resultHex');

    // var parameters = Argon2Parameters(
    //   Argon2Parameters.ARGON2_i,
    //   salt,
    //   desiredKeyLength: keySize,
    //   version: Argon2Parameters.ARGON2_i,
    //   iterations: 3,
    //   lanes: 4,
    //   memory: 64,
    //   // iterations: iterations,
    //   // // lanes: parallelism,
    //   // memory: memory,
    // );
    //
    // log('Parameters: $parameters');
    //
    // var argon2 = Argon2BytesGenerator();
    //
    // argon2.init(parameters);
    //
    // //  var passwordBytes = parameters.converter.convert(password);
    //
    // log('Generating key from password...');
    //
    // var result = Uint8List(keySize);
    // argon2.deriveKey(password, 0, result, result.length);
    //
    // var resultHex = uint8ListToHexString(Uint8List.fromList(result.rawBytes));
    //
    logger('Result: ${result.hexString}');

    return Uint8List.fromList(result.rawBytes);
  }

  Future<SymmetricCryptoKey?> getEncKey({SymmetricCryptoKey? key}) async {
    // if (_encKey != null) {
    //   return _encKey;
    // }
    // if (_getEncKeysFunction != null) {
    //   return _getEncKeysFunction;
    // }
    // Future<SymmetricCryptoKey?> doTask() async {
    //   try {
    var encKey = await getEncKeyEncrypted();
    if (encKey == null) {
      return null;
    }

    key ??= await getMasterKey();
    if (key == null) {
      return null;
    }

    Uint8List? decEncKey;
    var encKeyCipher = EncryptedString.fromString(encryptedString: encKey);
    if (encKeyCipher.encryptionType == EncryptionType.aesCbc256B64) {
      decEncKey = await decryptToBytes(encString: encKeyCipher, key: key);
    } else if (encKeyCipher.encryptionType ==
        EncryptionType.aesCbc256HmacSha256B64) {
      var newKey = await stretchKey(key);
      decEncKey = await decryptToBytes(encString: encKeyCipher, key: newKey);
    } else {
      throw Exception("Unsupported encKey type.");
    }

    if (decEncKey == null) {
      return null;
    }
    return SymmetricCryptoKey(key: decEncKey);
    //  return _encKey;
    //   }
    //finally {
    //      _getEncKeysFunction = null;
    //  }
    // }
    //
    // _getEncKeysFunction = doTask();
    // return _getEncKeysFunction;
  }

  Future<SymmetricCryptoKey?> getMasterKey() async {
    var inMemoryKey = await getMasterKeyDecrypted();
    if (inMemoryKey != null) {
      return inMemoryKey;
    }
    var key = await getMasterKeyEncrypted();
    if (key != null) {
      inMemoryKey = SymmetricCryptoKey(key: base64Decode(key));
      await setMasterKeyDecrypted(
        inMemoryKey,
      );
    }
    return inMemoryKey;
  }

  Future<Uint8List?> decryptToBytes(
      {EncryptedString? encString, SymmetricCryptoKey? key}) async {
    var iv = base64Decode(encString?.iv ?? '');
    var data = base64Decode(encString?.data ?? '');
    var mac = !isNullOrWhiteSpace(encString?.mac ?? '')
        ? base64Decode(encString?.mac ?? '')
        : null;
    return await aesDecryptToBytes(
        encType: encString?.encryptionType,
        data: data,
        iv: iv,
        mac: mac,
        key: key);
  }

  Future<String?> decryptToUtf8(
      {EncryptedString? encString, SymmetricCryptoKey? key}) async {
    if (encString == null) {
      return null;
    }

    return await aesDecryptToUtf8(
        encType: encString.encryptionType,
        data: encString.data,
        iv: encString.iv,
        mac: encString.mac,
        key: key);
  }

  Future<String?> aesDecryptToUtf8({
    EncryptionType? encType,
    String? data,
    String? iv,
    String? mac,
    SymmetricCryptoKey? key,
  }) async {
    var keyForEnc = await getKeyForEncryption(key: key);
    var theKey = resolveLegacyKey(encType: encType, key: keyForEnc);

    if (theKey?.macKey != null && mac == null) {
      // Mac required.
      return null;
    }
    if (theKey?.encType != encType) {
      // encType unavailable.
      return null;
    }

    // Convert data, IV, and MAC from base64 to bytes
    var encKey = theKey?.encKey;
    var dataBytes = base64.decode(data ?? '');
    var ivBytes = base64.decode(iv ?? '');
    var macBytes = mac != null ? base64.decode(mac) : null;

    // var macDataBytes = new byte[ivBytes.Length + dataBytes.Length];
    // Buffer.BlockCopy(ivBytes, 0, macDataBytes, 0, ivBytes.Length);
    // Buffer.BlockCopy(dataBytes, 0, macDataBytes, ivBytes.Length, dataBytes.Length);

    // if (theKey.macKey != null)
    // {
    //   macKey = theKey.MacKey;
    // }
    // byte[] macBytes = null;
    // if (mac != null)
    // {
    //   macBytes = Convert.FromBase64String(mac);
    // }

    // Compute MAC if needed
    if (theKey?.macKey != null && macBytes != null) {
      var macDataBytes = Uint8List.fromList([...ivBytes, ...dataBytes]);
      var computedMac = hmac(
          value: macDataBytes,
          key: theKey!.macKey!,
          algorithm: CryptoHashAlgorithm.sha256);
      if (!compare(macBytes, computedMac)) {
        // Mac failed
        return null;
      }
    }

    var decryptedBytes = aesDecrypt(data: dataBytes, iv: ivBytes, key: encKey!);
    return utf8.decode(decryptedBytes);
  }

  Future<Uint8List?> aesDecryptToBytes({
    EncryptionType? encType,
    Uint8List? data,
    Uint8List? iv,
    Uint8List? mac,
    SymmetricCryptoKey? key,
  }) async {
    var keyForEnc = await getKeyForEncryption(key: key);
    var theKey = resolveLegacyKey(encType: encType, key: keyForEnc);
    if (theKey?.macKey != null && mac == null) {
      // Mac required.
      return null;
    }
    if (theKey?.encType != encType) {
      // encType unavailable.
      return null;
    }

    // Compute mac
    if (theKey?.macKey != null && mac != null) {
      // var macData = new byte[iv.Length + data.Length];
      // Buffer.BlockCopy(iv, 0, macData, 0, iv.Length);
      // Buffer.BlockCopy(data, 0, macData, iv.Length, data.Length);
      var macData = Uint8List(iv!.length + data!.length);
      macData.setAll(0, iv);
      macData.setAll(iv.length, data);

      var computedMac = hmac(
          value: macData,
          key: theKey!.macKey!,
          algorithm: CryptoHashAlgorithm.sha256);
      // if (computedMac == null) {
      //   return null;
      // }
      var macsMatch = compare(mac, computedMac);
      if (!macsMatch) {
        // Mac failed
        return null;
      }
    }

    return aesDecrypt(data: data!, iv: iv!, key: theKey!.encKey!);
  }

  Future<SymmetricCryptoKey?> getKeyForEncryption(
      {SymmetricCryptoKey? key}) async {
    if (key != null) {
      return key;
    }
    var encKey = await getEncKey();
    if (encKey != null) {
      return encKey;
    }
    return await getMasterKey();
  }

  SymmetricCryptoKey? resolveLegacyKey({
    EncryptionType? encType,
    SymmetricCryptoKey? key,
  }) {
    if (encType == EncryptionType.aesCbc128HmacSha256B64 &&
        key?.encType == EncryptionType.aesCbc256B64) {
      // Old encrypt-then-mac scheme, make a new key
      _legacyEtmKey ??= SymmetricCryptoKey(
          key: key?.key, encType: EncryptionType.aesCbc128HmacSha256B64);
      return _legacyEtmKey;
    }
    return key;
  }

  // Future<SymmetricCryptoKey?> getOrgKeyFromString({String? orgId}) async {
  //   if (isNullOrWhiteSpace(orgId)) {
  //     return null;
  //   }
  //   var orgKeys = await getOrgKeys();
  //   if (orgKeys == null || !orgKeys.containsKey(orgId)) {
  //     return null;
  //   }
  //   return orgKeys[orgId];
  // }

  // Future<Map<String, SymmetricCryptoKey>?>? getOrgKeys() {
  //   if (_orgKeys != null && (_orgKeys?.isNotEmpty ?? false)) {
  //     return Future.value(UnmodifiableMapView(_orgKeys!));
  //   }
  //   if (_getOrgKeysFunction != null
  //       //  && !_getOrgKeysFunction.isCompleted && !_getOrgKeysFunction.IsFaulted
  //       ) {
  //     return _getOrgKeysFunction;
  //   }
  //   Future<Map<String, SymmetricCryptoKey>?>? doTask() async {
  //     try {
  //      // var encOrgKeys = await _stateController.getOrgKeysEncrypted();
  //       // if (encOrgKeys == null) {
  //       //   return null;
  //       // }  //check
  //       var orgKeys = new Map<String, SymmetricCryptoKey>();
  //       var setKey = false;
  //       for (var org in encOrgKeys.entries) {
  //         var decValue = await rsaDecryptFromString(encValue: org.value);
  //         orgKeys.addAll({org.key: SymmetricCryptoKey(key: decValue)});
  //         setKey = true;
  //       }
  //
  //       if (setKey) {
  //         _orgKeys = orgKeys;
  //       }
  //       return _orgKeys;
  //     } finally {
  //       _getOrgKeysFunction = null;
  //     }
  //   }
  //
  //   _getOrgKeysFunction = doTask();
  //   return _getOrgKeysFunction;
  // }

  Future<Uint8List> rsaDecrypt({
    required Uint8List data,
    required Uint8List privateKey,
    CryptoHashAlgorithm? algorithm,
  }) async {
    AsymmetricKeyPair<RSAPublicKey, RSAPrivateKey> keyPair =
        parsePrivateKey(privateKey);
    RSAPrivateKey rsaPrivateKey = keyPair.privateKey;

    final rsaEngine = RSAEngine();
    rsaEngine.init(false, PrivateKeyParameter<RSAPrivateKey>(rsaPrivateKey));

    return rsaEngine.process(Uint8List.fromList(data));
  }

  AsymmetricKeyPair<RSAPublicKey, RSAPrivateKey> parsePrivateKey(
      Uint8List privateKeyData) {
    final reader = ASN1Parser(privateKeyData);
    final topLevelSeq = reader.nextObject() as ASN1Sequence;
    final rsaSeq = topLevelSeq.elements![2] as ASN1Sequence;

    final modulus = rsaSeq.elements![1] as ASN1Integer;
    final publicExponent = rsaSeq.elements![2] as ASN1Integer;
    final privateExponent = rsaSeq.elements![3] as ASN1Integer;
    final prime1 = rsaSeq.elements![4] as ASN1Integer;
    final prime2 = rsaSeq.elements![5] as ASN1Integer;
    // final exponent1 = rsaSeq.elements![6] as ASN1Integer;
    // final exponent2 = rsaSeq.elements![7] as ASN1Integer;
    // final coefficient = rsaSeq.elements![8] as ASN1Integer;

    final RSAPrivateKey rsaPrivateKey = RSAPrivateKey(
      modulus.integer!,
      privateExponent.integer!,
      prime1.integer!,
      prime2.integer!,
    );

    final RSAPublicKey rsaPublicKey = RSAPublicKey(
      modulus.integer!,
      publicExponent.integer!,
    );

    return AsymmetricKeyPair<RSAPublicKey, RSAPrivateKey>(
        rsaPublicKey, rsaPrivateKey);
  }

  // Future<Uint8List> rsaDecryptFromString(
  //     {required String encValue, Uint8List? privateKey}) async {
  //   var headerPieces = encValue.split('.');
  //   EncryptionType? encType;
  //   List<String>? encPieces;
  //
  //   if (headerPieces.length == 1) {
  //     encType = EncryptionType.rsa2048OaepSha256B64;
  //     encPieces = [headerPieces[0]];
  //   } else if (headerPieces.length == 2 &&
  //       EncryptionType.values[int.tryParse(headerPieces[0]) ?? 0] !=
  //           null) //check
  //   {
  //     encType = EncryptionType.values[int.tryParse(headerPieces[0]) ?? 0];
  //     encPieces = headerPieces[1].split('|');
  //   }
  //
  //   if (encType == null) {
  //     throw Exception("encType unavailable.");
  //   }
  //   if (encPieces == null || encPieces.length == 0) {
  //     throw new Exception("encPieces unavailable.");
  //   }
  //
  //   var data = base64.decode(encPieces[0]);
  //
  //   if (privateKey == null) {
  //     privateKey = await getPrivateKey();
  //   }
  //
  //   if (privateKey == null) {
  //     throw new Exception("No private key.");
  //   }
  //
  //   var alg = CryptoHashAlgorithm.sha1;
  //   switch (encType) {
  //     case EncryptionType.rsa2048OaepSha256B64:
  //     case EncryptionType.rsa2048OaepSha256HmacSha256B64:
  //       alg = CryptoHashAlgorithm.sha256;
  //       break;
  //     case EncryptionType.rsa2048OaepSha1B64:
  //     case EncryptionType.rsa2048OaepSha1HmacSha256B64:
  //       break;
  //     default:
  //       throw new Exception("encType unavailable.");
  //   }
  //
  //   return rsaDecrypt(
  //     data: data,
  //     privateKey: privateKey,
  //     algorithm: alg,
  //   );
  // }
  //
  // Future<Uint8List?> getPrivateKey() async {
  //   if (_privateKey != null) {
  //     return _privateKey;
  //   }
  //   var encPrivateKey = await _stateController.getPrivateKeyEncrypted();
  //   if (encPrivateKey == null) {
  //     return null;
  //   }
  //   _privateKey = await decryptToBytes(
  //     encString: EncryptedString(data: encPrivateKey),
  //   );
  //   return _privateKey;
  // }

  Uint8List hmac(
      {required Uint8List value,
      required Uint8List key,
      CryptoHashAlgorithm? algorithm}) {
    // var provider = MacAlgorithmProvider.OpenAlgorithm(ToMacAlgorithm(algorithm));
    // var hasher = provider.CreateHash(key);
    // hasher.Append(value);
    // return Task.FromResult(hasher.GetValueAndReset());

    var hmac = HMac(SHA256Digest(), 64)..init(KeyParameter(key));

    // hmac.update(value, 0, value.length);
    // var output = Uint8List(hmac.macSize);
    // hmac.doFinal(output, output.length);
    return hmac.process(value);
  }

  bool compare(Uint8List a, Uint8List b) {
    var hmacProvider = HMac(SHA256Digest(), 64);
    hmacProvider.init(KeyParameter(randomBytes(32)));

    hmacProvider.update(a, 0, a.length);
    var mac1 = Uint8List(hmacProvider.macSize);
    hmacProvider.doFinal(mac1, 0);

    hmacProvider.update(b, 0, b.length);
    var mac2 = Uint8List(hmacProvider.macSize);
    hmacProvider.doFinal(mac2, 0);

    return constantTimeBytesEqual(mac1, mac2);
  }

  Uint8List aesEncrypt({
    required Uint8List data,
    required Uint8List iv,
    required Uint8List key,
  }) {
    // var provider = SymmetricKeyAlgorithmProvider.OpenAlgorithm(SymmetricAlgorithm.AesCbcPkcs7);
    // var cryptoKey = provider.CreateSymmetricKey(key);
    // return Task.FromResult(CryptographicEngine.Encrypt(cryptoKey, data, iv));

    // var paddedCipher = PaddedBlockCipherImpl(PKCS7Padding(),CBCBlockCipher(AESFastEngine()));
    // paddedCipher.init(true, ParametersWithIV(KeyParameter(key), iv));
    // return paddedCipher.process(data);

    // final padding = PKCS7Padding();
    // final cbcBlockCipher = CBCBlockCipher(AESEngine());
    final parameters = ParametersWithIV<KeyParameter>(KeyParameter(key), iv);
    final cbcParameters = PaddedBlockCipherParameters(parameters, null);

    final cipher = PaddedBlockCipher("AES/CBC/PKCS7")
      ..init(true, cbcParameters);

    return cipher.process(data);
  }

  // public Task<Uint8List> AesDecryptAsync(Uint8List data, Uint8List iv, Uint8List key)
  // {
  // var provider = SymmetricKeyAlgorithmProvider.OpenAlgorithm(SymmetricAlgorithm.AesCbcPkcs7);
  // var cryptoKey = provider.CreateSymmetricKey(key);
  // return Task.FromResult(CryptographicEngine.Decrypt(cryptoKey, data, iv));
  // }
  Uint8List aesDecrypt(
      {required Uint8List data,
      required Uint8List iv,
      required Uint8List key}) {
    //  final padding = PKCS7Padding();
    // final cbcBlockCipher = CBCBlockCipher(AESEngine());
    final parameters = ParametersWithIV<KeyParameter>(KeyParameter(key), iv);
    final cbcParameters = PaddedBlockCipherParameters(parameters, null);

    final cipher = PaddedBlockCipher("AES/CBC/PKCS7")
      ..init(false, cbcParameters);

    return cipher.process(data);
  }

  Future<EncryptedObject> aesEncryptWithRandomIv(
      {required Uint8List data, SymmetricCryptoKey? key}) async {
    var obj = EncryptedObject(
        key: await getKeyForEncryption(key: key), iv: randomBytes(16));

    obj.data = aesEncrypt(data: data, iv: obj.iv!, key: obj.key!.encKey!);
    if (obj.key?.macKey != null) {
      var macData = Uint8List((obj.iv?.length ?? 0) + (obj.data?.length ?? 0));
      macData.setRange(0, obj.iv?.length ?? 0, obj.iv ?? []);
      macData.setRange(obj.iv?.length ?? 0, macData.length, obj.data ?? []);
      obj.mac = hmac(
          value: macData,
          key: obj.key!.macKey!,
          algorithm: CryptoHashAlgorithm.sha256);
    }
    return obj;
  }

  // Helper function to generate random bytes
  Uint8List randomBytes(int length) {
    final random = math.Random.secure();
    final List<int> values =
        List<int>.generate(length, (_) => random.nextInt(256));
    return Uint8List.fromList(values);
  }

// Helper function for constant-time byte comparison
  bool constantTimeBytesEqual(Uint8List a, Uint8List b) {
    if (a.length != b.length) {
      return false;
    }

    var result = 0;
    for (var i = 0; i < a.length; i++) {
      result |= a[i] ^ b[i];
    }

    return result == 0;
  }

  String uint8ListToHexString(Uint8List bytes) {
    return bytes.map((byte) => byte.toRadixString(16).padLeft(2, '0')).join();
  }

  // Some users like to copy/paste passwords from external files. Sometimes this can lead to two different
  // values on mobiles apps vs the web. For example, on Android an EditText will accept a new line character
  // (\n), whereas whenever you paste a new line character on the web in a HTML input box it is converted
  // to a space ( ). Normalize those values so that they are the same on all platforms.
  String normalizePassword(String password) {
    return password
        .replaceAll("\r\n", " ") // Windows-style new line => space
        .replaceAll("\n", " ") // New line => space
        .replaceAll(" ", " "); // No-break space (00A0) => space
  }

  Future<int> randomNumber() async {
    final rng = Random.secure();
    final uint8List = Uint8List(4); // 4 bytes for a 32-bit integer
    for (var i = 0; i < 4; i++) {
      uint8List[i] = rng.nextInt(256);
    }
    return ByteData.sublistView(uint8List).getInt32(0);
  }

  Future<int> randomNumberAsyncWithRange(int min, int max) async {
    max = max + 1;

    final diff = max - min;
    final upperBound = (4294967295 / diff).floor() * diff;
    int ui;
    do {
      ui = await randomNumber();
    } while (ui >= upperBound);
    return min + (ui % diff);
  }

  Future<String?> getEncKeyEncrypted() async {
    return await localUseCase.getSecureData(
      key: LocalStorageKey.encKeyKey,
    );
  }

  Future<void> setEncKeyEncrypted(String value) async {
    await localUseCase.saveSecureData(
      key: LocalStorageKey.encKeyKey,
      value: value,
    );
  }

  Future<String?> getMasterKeyEncrypted() async {
    return await localUseCase.getSecureData(
      key: LocalStorageKey.masterKeyEncryptedKey,
    );
  }

  Future<void> setMasterKeyEncrypted(String value) async {
    await localUseCase.saveSecureData(
      key: LocalStorageKey.masterKeyEncryptedKey,
      value: value,
    );
  }

  Future<SymmetricCryptoKey?> getMasterKeyDecrypted() async {
    final masterKeyDecrypted = await localUseCase.getSecureData(
        key: LocalStorageKey.masterKeyDecryptedKey);
    if (isNullEmpty(masterKeyDecrypted)) {
      return null;
    }

    return masterKeyDecrypted == null
        ? null
        : SymmetricCryptoKey.fromJson(jsonDecode(masterKeyDecrypted));
  }

  Future<void> setMasterKeyDecrypted(
    SymmetricCryptoKey value,
  ) async {
    return await localUseCase.saveSecureData(
        key: LocalStorageKey.masterKeyDecryptedKey,
        value: jsonEncode(value.toJson()));
  }

  Future<String?> getHashedMasterKey() async {
    return await localUseCase.getSecureData(
      key: LocalStorageKey.hashedMaterKeyKey,
    );
  }

  Future<void> setHashedMasterKey(String value) async {
    await localUseCase.saveSecureData(
      key: LocalStorageKey.hashedMaterKeyKey,
      value: value,
    );
  }

  Future<bool> compareKeyHash({
    String? masterPassword,
    SymmetricCryptoKey? key,
  }) async {
    var storedHashedMasterKey = await getHashedMasterKey();

    if (!isNullEmpty(storedHashedMasterKey) && !isNullEmpty(masterPassword)) {
      var hashedMasterKey =
          await hashPassword(password: masterPassword!, key: key);
      if (!isNullEmpty(hashedMasterKey) &&
          storedHashedMasterKey == hashedMasterKey) {
        return true;
      }
    }
    return false;
  }

  Future<bool> hasMasterKey() async {
    var key = await getMasterKey();
    return key != null;
  }

  Future<bool> hasEncKey() async {
    var encKey = await getEncKeyEncrypted();
    return encKey != null;
  }

  Future<void> setMasterKey(SymmetricCryptoKey key) async {
    await setMasterKeyDecrypted(key);
    await setMasterKeyEncrypted(key.keyB64 ?? '');
  }
}
