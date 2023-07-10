
import 'package:password_keeper/common/config/network/app_network.dart';
import 'package:password_keeper/data/api_constans.dart';
import 'package:password_keeper/domain/models/base_response.dart';

class WeatherRepository {
  Future<Map<String, dynamic>> getCovid19Summary() async {
    var baseRes = await ApiClient().request(path: ApiConstants.getCovid19Summary);
    return baseRes.data as Map<String, dynamic>;
  }
}