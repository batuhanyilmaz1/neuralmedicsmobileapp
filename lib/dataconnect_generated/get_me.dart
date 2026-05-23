part of 'generated.dart';

class GetMeVariablesBuilder {
  
  final FirebaseDataConnect _dataConnect;
  GetMeVariablesBuilder(this._dataConnect, );
  Deserializer<GetMeData> dataDeserializer = (dynamic json)  => GetMeData.fromJson(jsonDecode(json));
  
  Future<QueryResult<GetMeData, void>> execute({QueryFetchPolicy fetchPolicy = QueryFetchPolicy.preferCache}) {
    return ref().execute(fetchPolicy: fetchPolicy);
  }

  QueryRef<GetMeData, void> ref() {
    
    return _dataConnect.query("GetMe", dataDeserializer, emptySerializer, null);
  }
}

@immutable
class GetMeUser {
  final String uid;
  final String email;
  final String? displayName;
  final Timestamp createdAt;
  GetMeUser.fromJson(dynamic json):
  
  uid = nativeFromJson<String>(json['uid']),
  email = nativeFromJson<String>(json['email']),
  displayName = json['displayName'] == null ? null : nativeFromJson<String>(json['displayName']),
  createdAt = Timestamp.fromJson(json['createdAt']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final GetMeUser otherTyped = other as GetMeUser;
    return uid == otherTyped.uid && 
    email == otherTyped.email && 
    displayName == otherTyped.displayName && 
    createdAt == otherTyped.createdAt;
    
  }
  @override
  int get hashCode => Object.hashAll([uid.hashCode, email.hashCode, displayName.hashCode, createdAt.hashCode]);
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['uid'] = nativeToJson<String>(uid);
    json['email'] = nativeToJson<String>(email);
    if (displayName != null) {
      json['displayName'] = nativeToJson<String?>(displayName);
    }
    json['createdAt'] = createdAt.toJson();
    return json;
  }

  GetMeUser({
    required this.uid,
    required this.email,
    this.displayName,
    required this.createdAt,
  });
}

@immutable
class GetMeData {
  final GetMeUser? user;
  GetMeData.fromJson(dynamic json):
  
  user = json['user'] == null ? null : GetMeUser.fromJson(json['user']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final GetMeData otherTyped = other as GetMeData;
    return user == otherTyped.user;
    
  }
  @override
  int get hashCode => user.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    if (user != null) {
      json['user'] = user!.toJson();
    }
    return json;
  }

  GetMeData({
    this.user,
  });
}

