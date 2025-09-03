class Seat {
  final String id;
  final int row;
  final int col;
  final bool isReserved;

  const Seat({
    required this.id,
    required this.row,
    required this.col,
    required this.isReserved,
  });

  Seat copyWith({bool? isReserved}) =>
      Seat(id: id, row: row, col: col, isReserved: isReserved ?? this.isReserved);
}
