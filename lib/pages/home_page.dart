import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:lebasket/models/team.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});

  final List<Team> teams = [];

  // get teams
  Future getTeams() async {
    var response = await http.get(
      Uri.https('api.balldontlie.io', '/v1/teams'),
      headers: {'Authorization': '52e8b14b-076d-4e2c-8dd4-535581bd7081'},
    ); // calling the API involves adding headers & using your API key for authorization
    var jsonData = jsonDecode(response.body);

    for (var eachTeam in jsonData['data']) {
      final team = Team(
        abbreviation: eachTeam['abbreviation'],
        city: eachTeam['city'],
      );
      teams.add(team);
    }

    print(teams.length);
  }

  @override
  Widget build(BuildContext context) {
    getTeams();
    return Scaffold(
      body: FutureBuilder(
        future: getTeams(),
        builder: (context, snapshot) {
          // is it done loading? then show team data
          if (snapshot.connectionState == ConnectionState.done) {
            return ListView.builder(
              itemCount: teams.length,
              itemBuilder: (context, index) {
                return ListTile(title: Text(teams[index].abbreviation));
              },
            );
          }
          // if it is still loading, show loading circle
          else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
