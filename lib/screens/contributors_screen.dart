import 'dart:convert';
import 'package:purple_app/api/model.dart';
import 'package:purple_app/functions.dart';
import 'package:purple_app/screens/home_screen.dart';
import 'package:purple_app/size_config.dart';
import 'package:purple_app/style/app_style.dart';

import '../api/api_client.dart';
import 'contribution_screen.dart';
import 'package:flutter/material.dart';
import 'create_contributor.dart';

class ContributorsScreen extends StatefulWidget {
  final UserModel user;
  final ContributorModel contributors;
  const ContributorsScreen(
      {Key? key, required this.user, required this.contributors})
      : super(key: key);

  @override
  State<ContributorsScreen> createState() => ContributorsScreenState();
}

class ContributorsScreenState extends State<ContributorsScreen> {
  @override
  Widget build(BuildContext context) {
    //Asyncronous function for loading contribution
    Future<void> _contribution(contributor) async {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Row(
          children: [
            CircularProgressIndicator(),
            addHorizontalSp(10.0),
            Text('Loading Contribution')
          ],
        ),
        backgroundColor: Colors.green.shade300,
      ));
      ApiClient _apiClient = ApiClient();
      var contributorId = contributor["_id"];
      //getting contributions from api - (check ApiClient contribution)
      dynamic contribution = await _apiClient.contribution(widget.user.token);
      print(contribution);
      ContributionModel user_contribution =
          ContributionModel(data: contribution["data"]);

      //go-to Contribution Screen
      return navigateToRoute(
          context,
          ContributionScreen(
              user: widget.user,
              contributors: widget.contributors,
              contributorId: contributorId,
              data: contributor,
              contribution: user_contribution));
    }

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          navigateAndRemoveUntilRoute(
              context,
              CreateContributor(
                  user: widget.user, contributors: widget.contributors));
        },
        backgroundColor: appBrandColor,
        child: const Icon(Icons.add),
      ),
      appBar: AppBar(
        title: Text(
          "My Contributors",
          style: TextStyle(
              color: appBrandColor,
              fontSize: 20.0,
              fontWeight: FontWeight.w600),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
            onPressed: () {
              navigateAndRemoveUntilRoute(
                  context,
                  HomePage(user: widget.user, contributors: widget.contributors));
            },
            icon: const Icon(
              Icons.keyboard_arrow_left_outlined,
              color: Colors.grey,
              size: 30,
            )),
      ),
      backgroundColor: Colors.white,
      body: Column(
        children: [
          addVerticalSp(30),
          Expanded(
            child: ListView(physics: const BouncingScrollPhysics(), children: [
              ListView.builder(
                shrinkWrap: true,
                physics: const BouncingScrollPhysics(),
                scrollDirection: Axis.vertical,
                itemCount: (widget.contributors.data) == null ? 0 : (widget.contributors.data).length,
                itemBuilder: (BuildContext context, int index) {
                  var data = json.encode(widget.contributors.data);
                  return json.decode(data)["$index"]["agent"] == widget.user.id && (widget.contributors.data).length != null
                      ? GestureDetector(
                          onTap: () async {
                            await _contribution(json.decode(data)["$index"]);
                          },
                          child: Container(
                            width: double.infinity,
                            margin: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 10),
                            padding: const EdgeInsets.symmetric(vertical: 20),
                            decoration:
                                const BoxDecoration(color: Color(0xFFF7F7F7)),
                            child: Row(children: [
                              addHorizontalSp(30),
                              const CircleAvatar(
                                backgroundImage:
                                    AssetImage('assets/images/avatar.jpg'),
                              ),
                              addHorizontalSp(20),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '${json.decode(data)["$index"]["firstName"].toString().toUpperCase()} ${json.decode(data)["$index"]["lastName"].toString().toUpperCase()}',
                                    style: normalTextStyle(context).copyWith(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    '${json.decode(data)["$index"]["mobileNumber"]}',
                                    style: normalTextStyle(context).copyWith(
                                        color: Colors.grey[500],
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            ]),
                          ),
                        )
                      : addVerticalSp(1.0);
                },
              ),
            ]),
          ),
        ],
      ),
    );
  }
}
