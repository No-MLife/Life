String getCareerText(String experience) {
  switch (experience) {
    case 'ZERO_YEAR':
      return '0년';
    case 'ONE_TO_TWO_YEARS':
      return '1~2년 이하';
    case 'THREE_TO_FIVE_YEARS':
      return '3~5년';
    case 'MORE_THAN_SIX_YEARS':
      return '6년 이상';
    default:
      return '';
  }
}
