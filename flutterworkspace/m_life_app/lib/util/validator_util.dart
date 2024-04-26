import 'package:validators/validators.dart';

Function validate_username(){
  return(String? value){
    if(value!.isEmpty){return "ID를 입력해주세요";}
    else if(!isAlphanumeric(value)){ return "ID에는 한글이나 특수문자가 들어갈 수 없습니다.";}
    else if(value.length > 12){return "ID의 최대 길이는 12를 초과할 수 없습니다.";}
    else if(value.length < 4){return "ID의 최소 길이는 4이상입니다.";}
    else return null;
  };
}

Function validate_password(){
  return(String? value){
    if(value!.isEmpty){return "비밀번호를 입력해주세요";}
    else if(value.length > 12){return "비밀번호의 최대 길이는 12를 초과할 수 없습니다.";}
    else if(value.length < 4){return "비밀번호는 최소 길이는 4이상입니다.";}
    else return null;
  };
}

Function validate_nickname(){
  return(String? value){
    if(value!.isEmpty){return "닉네임을 입력해주세요";}
    else if(value.length > 12){return "닉네임의 최대 길이는 12를 초과할 수 없습니다.";}
    else if(value.length < 4){return "닉네임의 최소 길이는 4이상입니다.";}
    else return null;
  };
}

Function validate_email(){
  return(String? value){
    if(value!.isEmpty){return "이메일을 입력해주세요";}
    else if(!isEmail(value)){return "이메일 형식에 맞지 않습니다.";}
    else return null;
  };
}
