import 'package:password_keeper/domain/models/keys_request.dart';

class RegisterRequest {
  String name;
  String email;
  String masterPasswordHash;
  String masterPasswordHint;
  String key;
  KeysRequest keys;
  String token;
  //Guid? organizationUserId ;
  //KdfType? kdf ;
  int? kdfIterations;
  int? kdfMemory;
  int? kdfParallelism;
  String captchaResponse;

  RegisterRequest(
      this.name,
      this.email,
      this.masterPasswordHash,
      this.masterPasswordHint,
      this.key,
      this.keys,
      this.token,
      this.kdfIterations,
      this.kdfMemory,
      this.kdfParallelism,
      this.captchaResponse);
}
