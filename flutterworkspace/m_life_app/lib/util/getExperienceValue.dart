String getExperienceValue(String selectedCareer) {
  switch (selectedCareer) {
    case '0년':
      return 'ZERO_YEAR';
    case '1~2년 이하':
      return 'ONE_TO_TWO_YEARS';
    case '3~5년':
      return 'THREE_TO_FIVE_YEARS';
    case '6년 이상':
      return 'MORE_THAN_SIX_YEARS';
    default:
      return '';
  }
}
