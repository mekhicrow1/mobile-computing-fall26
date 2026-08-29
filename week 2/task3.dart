class Student {
  // Fields
  String name;
  int id;
  List<double> grades;

  // Constructor
  Student(this.name, this.id, this.grades);

  // Calculate and return the average GPA
  double calculateGPA() {
    double total = 0;

    for (double grade in grades) {
      total += grade;
    }

    return total / grades.length;
  }
}

void main() {
  var students = [
    Student('Sahar', 1, [3.8, 4.0, 3.6]),
    Student('Mekhi', 2, [3.2, 3.5, 3.9]),
  ];

  for (var s in students) {
    print('${s.name}: ${s.calculateGPA()}');
  }
}