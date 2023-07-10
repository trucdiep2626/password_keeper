import 'package:password_keeper/data/remote/weather_repository.dart';
import 'package:password_keeper/domain/models/covid19_summary_response.dart';

class WeatherUseCase {
  final WeatherRepository weatherRepo;

  WeatherUseCase({required this.weatherRepo});
  
  Future<Covid19SummaryGlobalModel> getCovid19SummaryGlobal() async {
    Map<String, dynamic> response = await weatherRepo.getCovid19Summary();
    return Covid19SummaryGlobalModel.fromJson(response['Global']);
  }

}