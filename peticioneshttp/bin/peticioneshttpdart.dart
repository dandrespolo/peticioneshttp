
import 'dart:convert';
import 'package:http/http.dart' as http;

// Definición de las clases en Dart
class Geo {
  final String lat;
  final String lng;

  Geo({required this.lat, required this.lng});

  factory Geo.fromJson(Map<String, dynamic> json) {
    return Geo(
      lat: json['lat'],
      lng: json['lng'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'lat': lat,
      'lng': lng,
    };
  }
}

class Address {
  final String street;
  final String suite;
  final String city;
  final String zipcode;
  final Geo geo;

  Address({
    required this.street,
    required this.suite,
    required this.city,
    required this.zipcode,
    required this.geo,
  });

  factory Address.fromJson(Map<String, dynamic> json) {
    return Address(
      street: json['street'],
      suite: json['suite'],
      city: json['city'],
      zipcode: json['zipcode'],
      geo: Geo.fromJson(json['geo']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'street': street,
      'suite': suite,
      'city': city,
      'zipcode': zipcode,
      'geo': geo.toJson(),
    };
  }
}

class Company {
  final String name;
  final String catchPhrase;
  final String bs;

  Company({
    required this.name,
    required this.catchPhrase,
    required this.bs,
  });

  factory Company.fromJson(Map<String, dynamic> json) {
    return Company(
      name: json['name'],
      catchPhrase: json['catchPhrase'],
      bs: json['bs'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'catchPhrase': catchPhrase,
      'bs': bs,
    };
  }
}

class User {
  final int id;
  final String name;
  final String username;
  final String email;
  final Address address;
  final String phone;
  final String website;
  final Company company;

  User({
    required this.id,
    required this.name,
    required this.username,
    required this.email,
    required this.address,
    required this.phone,
    required this.website,
    required this.company,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      name: json['name'],
      username: json['username'],
      email: json['email'],
      address: Address.fromJson(json['address']),
      phone: json['phone'],
      website: json['website'],
      company: Company.fromJson(json['company']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'username': username,
      'email': email,
      'address': address.toJson(),
      'phone': phone,
      'website': website,
      'company': company.toJson(),
    };
  }
}

// Función para realizar la petición HTTP GET
Future<List<User>> fetchUsers() async {
  final url = 'https://jsonplaceholder.typicode.com/users'; // URL de la API

  try {
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      final List<User> users = data.map((json) => User.fromJson(json)).toList();
      return users;
    } else {
      throw Exception('No se pudieron cargar los usuarios');
    }
  } catch (e) {
    print('Error: $e');
    return [];
  }
}

// Función para filtrar usuarios cuyo nombre de usuario tenga más de 6 caracteres
List<User> filterUsersByUsernameLength(List<User> users) {
  return users.where((user) => user.username.length > 6).toList();
}

// Función para contar e imprimir usuarios con correo electrónico que tenga el dominio 'biz'
void countUsersByEmailDomain(List<User> users, String domain) {
  final count = users.where((user) => user.email.endsWith('@$domain')).length;
  print('Número de usuarios con dominio de correo electrónico $domain: $count');
}

// Ejemplo de cómo usar las funciones
void main() async {
  final List<User> users = await fetchUsers();

  // Filtrar usuarios por longitud del nombre de usuario
  final filteredUsers = filterUsersByUsernameLength(users);
  print('Usuarios con una longitud de nombre de usuario superior a 6:');
  for (var user in filteredUsers) {
    print('${user.username}');
  }

  // Contar usuarios con dominio de correo electrónico 'biz'
  countUsersByEmailDomain(users, 'biz');
}


