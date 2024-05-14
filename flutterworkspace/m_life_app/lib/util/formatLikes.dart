String formatLikes(int likes) {
  if (likes >= 1000) {
    return "${(likes / 1000).toStringAsFixed(1)}K";
  } else {
    return likes.toString();
  }
}
