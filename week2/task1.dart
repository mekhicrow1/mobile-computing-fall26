double average(List<int> values) {
  int total = 0;

  for (int value in values) {
    total += value;
  }

  return total / values.length;
}

void main() {
  print(average([10, 20, 30])); // 20.0
}