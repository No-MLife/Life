// src/util/Category.js
export const Category = {
    free: { id: 2, name: '자유 게시판', description: '자유롭게 글을 작성할 수 있는 게시판입니다.' },
    restaurant: { id: 3, name: '맛집', description: '건설 현장 주변의 맛집 정보를 공유하는 게시판입니다.' },
    constructionMethod: { id: 4, name: '시공 방법', description: '다양한 시공 방법과 관련된 정보를 공유하는 게시판입니다.' },
    complaintDiscussion: { id: 5, name: '불만 토론', description: '작업 환경, 처우 등에 대한 불만사항을 토론하고 개선방안을 모색하는 게시판입니다.' },
    equipmentRecommendation: { id: 6, name: '장비 추천', description: '건설 현장에서 사용되는 각종 장비, 공구 등에 대한 추천과 사용 팁을 공유하는 게시판입니다.' },
    siteDebateDispute: { id: 7, name: '현장 논쟁 분쟁', description: '현장에서 발생하는 다양한 논쟁과 분쟁 사례를 공유하고 해결방안을 논의하는 게시판입니다.' },
    dailyProof: { id: 8, name: '일당 인증', description: '작업 완료 후 받은 일당을 인증하는 게시판입니다.' },
  };
  
  export const getCategoryEmoji = (category) => {
    switch (category) {
      case Category.free:
        return '📝️';
        case Category.restaurant:
          return '🍽️';
      case Category.constructionMethod:
        return '🏗️';
      case Category.complaintDiscussion:
        return '😤';
      case Category.siteDebateDispute:
        return '🏢';
      case Category.equipmentRecommendation:
        return '🔧';
        case Category.dailyProof:
          return '📸';
      default:
        return '📜';
    }
  };
  