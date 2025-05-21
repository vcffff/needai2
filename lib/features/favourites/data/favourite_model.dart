class Favourite {
  final String title;
  final int hours;

  Favourite({required this.title, required this.hours});

  Map<String, dynamic> toJson() => {'title': title, 'hours': hours};

  factory Favourite.fromJson(Map<String, dynamic> json) =>
      Favourite(title: json['title'], hours: json['hours']);
}


