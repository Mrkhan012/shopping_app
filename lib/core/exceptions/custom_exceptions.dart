class CustomException implements Exception {
  final String message;

  CustomException(this.message);

  @override
  String toString() => 'CustomException: $message';

  // Common named constructors for specific cases
  factory CustomException.network() =>
      CustomException('Network error. Please check your internet connection.');

  factory CustomException.unauthorized() =>
      CustomException('Unauthorized request. Please login again.');

  factory CustomException.notFound() =>
      CustomException('Requested resource not found.');

  factory CustomException.serverError() =>
      CustomException('Internal server error. Please try again later.');

  factory CustomException.timeout() =>
      CustomException('The request timed out. Please try again.');

  factory CustomException.invalidInput(String field) =>
      CustomException('Invalid input in $field.');

  factory CustomException.unknown() =>
      CustomException('An unknown error occurred.');
}
