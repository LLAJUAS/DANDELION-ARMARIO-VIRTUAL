import 'package:flutter/material.dart';

class ArmarioTheme {
  static const Color primaryColor = Color(0xFFD94A64);
  static const Color secondaryColor = Color(0xFFF28729);
  static const Color backgroundColor = Color(0xFFF5F5F5); // Colors.grey[100]
  static const Color cardColor = Colors.white;
  static const Color textPrimary = Colors.black87;
  static const Color textSecondary = Colors.black54;
  static const Color dividerColor = Color(0xFFE0E0E0); // Colors.grey[300]

  static LinearGradient headerGradient = const LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color.fromARGB(186, 217, 74, 100),
      Color.fromARGB(164, 242, 135, 41),
    ],
  );

  static BoxDecoration headerDecoration = BoxDecoration(
    gradient: headerGradient,
    borderRadius: const BorderRadius.only(
      bottomLeft: Radius.circular(20),
      bottomRight: Radius.circular(20),
    ),
  );

  static BoxDecoration statsContainerDecoration = const BoxDecoration(
    color: cardColor,
    borderRadius: BorderRadius.only(
      bottomLeft: Radius.circular(20),
      bottomRight: Radius.circular(20),
    ),
  );

  static const TextStyle profileNameTextStyle = TextStyle(
    fontSize: 22,
    fontWeight: FontWeight.bold,
  );

  static const TextStyle profileUsernameTextStyle = TextStyle(
    fontSize: 16,
    color: textSecondary,
  );

  static BoxDecoration iconButtonDecoration = BoxDecoration(
    color: cardColor,
    shape: BoxShape.circle,
  );

  static TextStyle statCountTextStyle = const TextStyle(
    fontWeight: FontWeight.bold,
    fontSize: 18,
  );

  static TextStyle statLabelTextStyle = const TextStyle(
    fontSize: 14,
    color: textPrimary,
  );

  static BoxDecoration filterCategoryDecoration(bool isSelected) => BoxDecoration(
    shape: BoxShape.circle,
    border: Border.all(
      color: isSelected ? Colors.green : Colors.transparent,
      width: 2,
    ),
  );

  static BoxDecoration clothingItemDecoration = BoxDecoration(
    color: cardColor,
    borderRadius: BorderRadius.circular(12),
  );

  static BoxDecoration clothingActionDecoration = const BoxDecoration(
    color: Colors.white54,
    shape: BoxShape.circle,
  );

  static BottomNavigationBarThemeData bottomNavigationBarTheme = const BottomNavigationBarThemeData(
    type: BottomNavigationBarType.fixed,
    selectedItemColor: Colors.blue,
    unselectedItemColor: Colors.grey,
  );
}