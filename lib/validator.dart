class Validators {
  static String? username(String? value) =>
      (value == null || value.trim().isEmpty) ? 'Username is required'
      : (value.length < 3) ? 'Username must be at least 3 characters' : null;

  static String? bio(String? value) =>
      (value != null && value.length > 150) ? 'Bio can’t be more than 150 characters' : null;


  static String? email(String? value) {
    final pattern = r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$';
    return (value == null || value.trim().isEmpty)
        ? 'Email is required'
        : (!RegExp(pattern).hasMatch(value)) ? 'Enter a valid email' : null;
  }

  static String? password(String? value) =>
      (value == null || value.trim().isEmpty) ? 'Password is required'
      : (value.length < 6) ? 'Password must be at least 6 characters' : null;
}
