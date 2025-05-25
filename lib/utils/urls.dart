class URLs {
  static const String _baseUrl = 'https://esportsbd.top/TournamentApp';
  static const String signUpUrl = '$_baseUrl/auth/signup.php';
  static const String loginUrl = '$_baseUrl/auth/login.php';
  static const String BRMatchUrl = '$_baseUrl/api/match/get_all_matches.php?categories=BR MATCH';
  static const String ClashSquadUrl = '$_baseUrl/api/match/get_all_matches.php?categories=CLASH SQUAD';
  static const String BattleRoyaleUrl = '$_baseUrl/api/match/get_all_matches.php?categories=BATTLE ROYALE';
  static const String getUserBalanceUrl = '$_baseUrl/api/payment/get_user_balance.php';
  static const String joinedMatchUrl = '$_baseUrl/api/match/joined_match.php';

  
}
