import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:network_api/model/person.dart';

const String randomPersonUrl = "https://randomuser.me/api/";

class PersonServiceNetwork {
   Future<List<Person>> fetchUsers()async{
     try{
       final response = await http.get(Uri.parse(randomPersonUrl));
       if(response.statusCode==200){
         final Map<String, dynamic> decodedata = jsonDecode(response.body);
         final List<dynamic> results = decodedata["results"];
         final List<Person> persons =results.map((json)=>Person.fromJson(json)).toList();
          return persons;
         // return "response";
       }else{
         throw Exception("Something went wrong");
       }

     }catch(error){
       throw(error);
     }
   }

}