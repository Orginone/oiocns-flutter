enum StandardSize {
  small(size: 10),
  medium(size: 20),
  large(size: 30);

  const StandardSize({required this.size});

  final double size;
}
