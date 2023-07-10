class Covid19SummaryGlobalModel {
  int? newConfirmed;
  int? totalConfirmed;
  int? newDeaths;
  int? totalDeaths;
  int? newRecovered;
  int? totalRecovered;
  String? date;

  Covid19SummaryGlobalModel(
      {this.newConfirmed,
      this.totalConfirmed,
      this.newDeaths,
      this.totalDeaths,
      this.newRecovered,
      this.totalRecovered,
      this.date});

  factory Covid19SummaryGlobalModel.fromJson(Map<String, dynamic> json) => Covid19SummaryGlobalModel(
      newConfirmed: json['NewConfirmed'],
    totalConfirmed: json['TotalConfirmed'],
    newDeaths: json['NewDeaths'],
    totalDeaths: json['TotalDeaths'],
    newRecovered: json['NewRecovered'],
    totalRecovered: json['TotalRecovered'],
    date: json['Date'],
  );

  Map<String, dynamic> toJson() => {
    'NewConfirmed': newConfirmed,
    'TotalConfirmed': totalConfirmed,
    'NewDeaths': newDeaths,
    'TotalDeaths': totalDeaths,
    'NewRecovered': newRecovered,
    'TotalRecovered': totalRecovered,
    'Date': date,
  };
}