class Student {
  // fields
  String name;
  int id;
  List<double> grades;

  // constructor
  Student(this.name, this.id, this.grades);

  // calculate GPA
  double calculateGPA() {
    double total = 0;

    for (double grade in grades) {
      total += grade;
    }

    return total / grades.length;
  }
}

void main() {
  // Create a student
  Student student = Student(
    "Malcolm",
    123,
    [90, 85, 95, 88]
  );

  // Display information
  print("Student Name: ${student.name}");
  print("Student ID: ${student.id}");
  print("GPA: ${student.calculateGPA()}");
}