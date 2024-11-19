class Person {
  String name;
  String phoneNumber;
  String imageUrl;

  // Constructor
  Person({required this.name, required this.phoneNumber, required this.imageUrl});

  // Named constructor for JSON parsing
  Person.fromJson(Map<String, dynamic> json)
      : name = "${json["name"]["title"]} ${json["name"]["first"]} ${json["name"]["last"]}",
        phoneNumber = json["phone"] ?? '',
        imageUrl = json["picture"]["thumbnail"] ?? '';
}
