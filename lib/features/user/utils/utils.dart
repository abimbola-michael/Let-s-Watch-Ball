import '../models/user.dart';

String getUserBio(User user) {
  String bio = "";
  if (user.bestPlayer != null) {
    bio += "Best Player: ${user.bestPlayer} ";
  }
  if (user.bestClub != null) {
    bio += "Best Club: ${user.bestClub} ";
  }
  if (user.bestCountry != null) {
    bio += "Best Country: ${user.bestCountry}";
  }
  return bio.trim();
}
