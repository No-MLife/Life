enum Category {
  free(2, '자유 게시판'),
  dailyProof(3, '일당 인증'),
  constructionMethod(4, '시공 방법'),
  graduationReview(5, '졸업 후기'),
  complaintDiscussion(6, '불만 토론'),
  siteDebateDispute(7, '현장 논쟁 분쟁'),
  unionRelated(8, '노조 관련'),
  equipmentRecommendation(9, '장비 추천'),
  restaurant(10, '맛집');

  final int id;
  final String name;

  const Category(this.id, this.name);
}
