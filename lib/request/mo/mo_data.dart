class Mo {
  String id;
  Mo({required this.id});

  Map<String, dynamic> toJson() => {
        'id': id,
      };
}
