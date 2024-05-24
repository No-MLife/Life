import '../../util/post_category.dart';

String getCategoryEmoji(Category category) {
  switch (category) {
    case Category.free:
      return '📝️';
    case Category.dailyProof:
      return '📸';
    case Category.constructionMethod:
      return '🏗️';
    case Category.complaintDiscussion:
      return '😤';
    case Category.siteDebateDispute:
      return '🏢';
    case Category.equipmentRecommendation:
      return '🔧';
    case Category.restaurant:
      return '🍽️';
    default:
      return '📜';
  }
}
