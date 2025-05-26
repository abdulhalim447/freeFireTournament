class URLs {
  static const String _baseUrl = 'https://esportsbd.top/TournamentApp';
  static const String signUpUrl = '$_baseUrl/auth/signup.php';
  static const String loginUrl = '$_baseUrl/auth/login.php';
  static const String BRMatchUrl = '$_baseUrl/api/match/get_all_matches.php?categories=BR MATCH';
  static const String ClashSquadUrl = '$_baseUrl/api/match/get_all_matches.php?categories=CLASH SQUAD';
  static const String LoneWolfUrl = '$_baseUrl/api/match/get_all_matches.php?categories=LONE WOLF';
  static const String CS2vs2Url = '$_baseUrl/api/match/get_all_matches.php?categories=CS 2 VS 2';
  static const String LudoUrl = '$_baseUrl/api/match/get_all_matches.php?categories=LUDO';
  static const String FreeMatchUrl = '$_baseUrl/api/match/get_all_matches.php?categories=FREE MATCH';
  static const String getUserBalanceUrl = '$_baseUrl/api/payment/get_user_balance.php';
  static const String joinedMatchUrl = '$_baseUrl/api/match/joined_match.php';
  static const String decrementBalanceUrl = '$_baseUrl/api/payment/decrease_user_balance.php';
  static const String getJoinedMatchUrl = '$_baseUrl/api/match/get_my_joined_match.php';

  
}
