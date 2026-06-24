class AppUrls {
  AppUrls._();

  // Base API Urls (Mocked in services)
  static const String baseApiUrl = 'https://api.gymfitnessclub.com/v1';
  static const String loginEndpoint = '$baseApiUrl/auth/login';
  static const String registerEndpoint = '$baseApiUrl/auth/register';
  static const String userProfileEndpoint = '$baseApiUrl/user/profile';
  static const String workoutPlansEndpoint = '$baseApiUrl/workouts/plans';
  static const String dietPlansEndpoint = '$baseApiUrl/diet/plans';
  static const String weightProgressEndpoint = '$baseApiUrl/user/progress';

  // Legal / WebView Links
  static const String termsAndConditions = 'https://gymfitnessclub.com/terms-and-conditions';
  static const String privacyPolicy = 'https://gymfitnessclub.com/privacy-policy';
  static const String helpSupport = 'https://gymfitnessclub.com/help-support';

  // Image assets (Hosted online for high quality rendering)
  static const String welcomeBgImage = 'https://images.unsplash.com/photo-1517838277536-f5f99be501cd?q=80&w=1000&auto=format&fit=crop'; // Premium workout image
  static const String profileAvatar = 'https://images.unsplash.com/photo-1534528741775-53994a69daeb?q=80&w=300&auto=format&fit=crop'; // High quality profile photo
  static const String trainerAvatar = 'https://images.unsplash.com/photo-1568602471122-7832951cc4c5?q=80&w=300&auto=format&fit=crop';
  
  // Transformation Images
  static const String beforePhoto = 'https://images.unsplash.com/photo-1571019613454-1cb2f99b2d8b?q=80&w=300&auto=format&fit=crop';
  static const String afterPhoto = 'https://images.unsplash.com/photo-1517838277536-f5f99be501cd?q=80&w=300&auto=format&fit=crop';

  // Workout / Exercise Images
  static const String benchPressImage = 'https://images.unsplash.com/photo-1571019614242-c5c5dee9f50b?q=80&w=300&auto=format&fit=crop';
  static const String inclineDumbbellPressImage = 'https://images.unsplash.com/photo-1581009146145-b5ef050c2e1e?q=80&w=300&auto=format&fit=crop';
  static const String chestFlyImage = 'https://images.unsplash.com/photo-1541534741688-6078c6bfb5c5?q=80&w=300&auto=format&fit=crop';
  static const String pushUpsImage = 'https://images.unsplash.com/photo-1598971639058-fab3c3109a00?q=80&w=300&auto=format&fit=crop';

  // Diet / Meal Images
  static const String oatmealImage = 'https://images.unsplash.com/photo-1517686469429-8bdb88b9f907?q=80&w=300&auto=format&fit=crop';
  static const String proteinShakeImage = 'https://images.unsplash.com/photo-1553530666-ba11a7da3888?q=80&w=300&auto=format&fit=crop';
  static const String chickenRiceImage = 'https://images.unsplash.com/photo-1546069901-ba9599a7e63c?q=80&w=300&auto=format&fit=crop';
  static const String boiledEggsImage = 'https://images.unsplash.com/photo-1587486913049-53fc88980cfc?q=80&w=300&auto=format&fit=crop';
  static const String saladPaneerImage = 'https://images.unsplash.com/photo-1540420773420-3366772f4999?q=80&w=300&auto=format&fit=crop';
}
