class Student {
  String name;
  String barcode;
  String college;

  Student(this.name, this.barcode, this.college);

  // getters
  String get getName => name;
  String get getBarcode => barcode;
  String get getCollege => college;

  // setters
  set setName(String newName) {
    this.name = newName;
  }

  set setBarcode(String newBarcode) {
    this.barcode = newBarcode;
  }

  set setCollege(String newCollege) {
    this.college = newCollege;
  }

	// Extract an object from a Map object
	Student.fromMapObject(Map<String, dynamic> map) {
		name = map['name'];
    barcode = map['barcode'];
    college = map['college'];
	}
}
