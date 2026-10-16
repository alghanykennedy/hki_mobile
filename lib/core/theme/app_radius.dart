import 'package:flutter/material.dart';

class AppRadius {
  AppRadius._();

  // TODO: verify against Figma
  static const double sm = 4.0;
  static const double md = 8.0;      // Standard input border radius
  static const double lg = 12.0;
  static const double xl = 16.0;
  static const double sheet = 28.0;   // Top sheet rounded corners
  static const double pill = 100.0;   // Fully rounded buttons

  static const BorderRadius roundedSm = BorderRadius.all(Radius.circular(sm));
  static const BorderRadius roundedMd = BorderRadius.all(Radius.circular(md));
  static const BorderRadius roundedLg = BorderRadius.all(Radius.circular(lg));
  static const BorderRadius roundedXl = BorderRadius.all(Radius.circular(xl));
  static const BorderRadius roundedPill = BorderRadius.all(Radius.circular(pill));

  static const BorderRadius sheetTop = BorderRadius.only(
    topLeft: Radius.circular(sheet),
    topRight: Radius.circular(sheet),
  );
}
