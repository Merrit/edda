extension CapExtension on String {
  // helloWorld = 'hello world'.inCaps; // 'Hello world'
  String get inCaps => '${this[0].toUpperCase()}${this.substring(1)}';
  // helloWorld = 'hello world'.allInCaps; // 'HELLO WORLD'
  String get allInCaps => this.toUpperCase();
}
