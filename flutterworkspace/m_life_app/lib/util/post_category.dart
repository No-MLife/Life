enum Category {
  free(2, '자유 게시판', '자유롭게 글을 작성할 수 있는 게시판입니다.'),
  dailyProof(3, '일당 인증', '작업 완료 후 받은 일당을 인증하는 게시판입니다.'),
  constructionMethod(4, '시공 방법', '다양한 시공 방법과 관련된 정보를 공유하는 게시판입니다.'),
  graduationReview(5, '졸업 후기', '건설 관련 교육 과정 졸업 후 후기를 공유하는 게시판입니다.'),
  complaintDiscussion(
      6, '불만 토론', '작업 환경, 처우 등에 대한 불만사항을 토론하고 개선방안을 모색하는 게시판입니다.'),
  siteDebateDispute(
      7, '현장 논쟁 분쟁', '현장에서 발생하는 다양한 논쟁과 분쟁 사례를 공유하고 해결방안을 논의하는 게시판입니다.'),
  unionRelated(8, '노조 관련', '건설 노동조합과 관련된 소식, 활동, 정보 등을 공유하는 게시판입니다.'),
  equipmentRecommendation(
      9, '장비 추천', '건설 현장에서 사용되는 각종 장비, 공구 등에 대한 추천과 사용 팁을 공유하는 게시판입니다.'),
  restaurant(10, '맛집', '건설 현장 주변의 맛집 정보를 공유하는 게시판입니다.');

  final int id;
  final String name;
  final String description;

  const Category(this.id, this.name, this.description);
}
