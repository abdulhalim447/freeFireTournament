class NetworkResponse {  
  final int statusCode;  
  final bool isSuccess;  
  final dynamic responsData;  
  final String? errorMessage;  
  
  NetworkResponse({  
    required this.statusCode,  
    required this.isSuccess,  
     this.responsData,  
     this.errorMessage = 'Something went wrong: ',  
  });  
}