class Mo {
  String id;
  Mo({required this.id});

  @override
  Map<String, dynamic> toJson() => {
        'id': id,
      };
}
