class RoomModel {
  String? roomId;
  String title;
  String description;
  String? carId;
  String? image;

  RoomModel(
      { this.roomId,
      required this.title,
      required this.description,
        this.image,
       this.carId});

  factory RoomModel.fromFireStore(Map<String, dynamic> json) {
    return RoomModel(
        roomId: json["roomId"],
        title: json["title"],
        image:json["image"],
        description: json["description"],
        carId: json["carId"]);
  }

  Map<String, dynamic> toFireStore() {
    return {
      "roomId": roomId,
      "image":image,
      "title": title,
      "description": description,
      "carId": carId,
    };
  }
}
