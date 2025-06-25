class URLs {
  static const String _baseUrl = 'https://app.esportsbd.top/api/v1';

  //auth related api
  static const String signUpUrl = '$_baseUrl/register';
  static const String loginUrl = '$_baseUrl/login';

  // Dashboard or homepage and match releated related api
  static const String imagesliderUrl = '$_baseUrl/dashboard/image-slider';
  static const String marqueeTextUrl = '$_baseUrl/dashboard/text-slider';
  static const String matchCategoryUrl = '$_baseUrl/dashboard/category-matches';
  static const String topCategory = '$_baseUrl/dashboard/category';
  static const String todayMatchUrl = '$_baseUrl/dashboard/today-matches';
  static const String appInfoUrl = '$_baseUrl/dashboard/app-info';

  // sub category wise match list api
  static const String matchBySubcategory = '$_baseUrl/match/sub-categories/';
  static const String joinMatchUrl = '$_baseUrl/match/join';

  // profile related api
  static const String profileUrl = '$_baseUrl/user/profile';
  static const String balanceUrl = '$_baseUrl/user/balance';
  static const String updateProfileUrl = '$_baseUrl/user/update';
  static const String topPlayerListUrl = '$_baseUrl/top-teams';

  // help  video  url
  static const String helpVideoUrl = '$_baseUrl/help-videos';

  // deposit and withdraw related api
  static const String depositUrl = '$_baseUrl/account/recharge';
  static const String withdrawUrl = '$_baseUrl/account/withdraw-request';

  // mobile banking related api
  static const String mobileBankingUrl = '$_baseUrl/bank-info';

  //result screen api
  static const String resultTopTitleUrl = '$_baseUrl/sub-category/finish/list';




// old api
  static const String BRMatchUrl =
      '$_baseUrl/api/match/get_all_matches.php?categories=BR MATCH';
  static const String ClashSquadUrl =
      '$_baseUrl/api/match/get_all_matches.php?categories=CLASH SQUAD';
  static const String LoneWolfUrl =
      '$_baseUrl/api/match/get_all_matches.php?categories=LONE WOLF';
  static const String CS2vs2Url =
      '$_baseUrl/api/match/get_all_matches.php?categories=CS 2 VS 2';
  static const String LudoUrl =
      '$_baseUrl/api/match/get_all_matches.php?categories=LUDO';
  static const String FreeMatchUrl =
      '$_baseUrl/api/match/get_all_matches.php?categories=FREE MATCH';
  static const String getUserBalanceUrl =
      '$_baseUrl/api/payment/get_user_balance.php';
  static const String joinedMatchUrl = '$_baseUrl/api/match/joined_match.php';
  static const String decrementBalanceUrl =
      '$_baseUrl/api/payment/decrease_user_balance.php';
  static const String getJoinedMatchUrl =
      '$_baseUrl/api/match/get_my_joined_match.php';
  static const String legacyWithdrawUrl =
      '$_baseUrl/api/withdraw/create_user_withdraw.php';
  static const String changePasswordUrl = '$_baseUrl/auth/change_password.php';

  // rest api url by roman
}
