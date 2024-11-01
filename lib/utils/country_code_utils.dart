import 'package:flutter_sim_country_code/flutter_sim_country_code.dart';

import '../shared/constants/country_codes.dart';

// Future<String?> getCurrentCountryCode() async {
//   try {
//     // Request location permission
//     LocationPermission permission = await Geolocator.requestPermission();
//     if (permission == LocationPermission.denied ||
//         permission == LocationPermission.deniedForever) {
//       return null;
//     }

//     // Get current location
//     Position position = await Geolocator.getCurrentPosition(
//         desiredAccuracy: LocationAccuracy.high);

//     // Reverse geocode the location to get the country
//     List<Placemark> placemarks =
//         await placemarkFromCoordinates(position.latitude, position.longitude);
//     if (placemarks.isNotEmpty) {
//       return placemarks.first.isoCountryCode; // e.g., "NG"
//     }
//   } catch (e) {
//     print("Error getting country code: $e");
//     return null;
//   }

//   return null;
// }

Future<String?> getSimCountryCode() async {
  String? countryCode = await FlutterSimCountryCode.simCountryCode;
  // print("simCountryCode = $countryCode");
  return countryCode; // Should return "NG" if the SIM is from Nigeria
}

Future<String?> getCurrentCountryDialingCode([String? countryIsoCode]) async {
  // Step 1: Get the country ISO code (e.g., NG, US)
  // String? isoCode = countryIsoCode ??
  //     (countryCode.isNotEmpty ? countryCode : (await getCurrentCountryCode()));
  //
  String? isoCode = countryIsoCode ?? await getSimCountryCode();
  if (isoCode == null) return null;
  return countryCodes.firstWhere(
      (map) => map["alpha_2_code"] == isoCode || map["alpha_3_code"] == isoCode,
      orElse: () => {})["dial_code"];
}
