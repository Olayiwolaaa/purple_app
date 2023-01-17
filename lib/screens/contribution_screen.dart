import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:purple_app/api/api_client.dart';
import 'package:purple_app/api/model.dart';
import 'package:purple_app/functions.dart';
import 'package:purple_app/size_config.dart';
import 'package:purple_app/style/app_style.dart';
import 'package:purple_app/widget/elevated_button.dart';
import 'package:purple_app/widget/text_field.dart';
import 'contributors_screen.dart';
import 'create_contribution.dart';

class ContributionScreen extends StatefulWidget {
  final UserModel user;
  final ContributorModel contributors;
  final data;
  final ContributionModel contribution;
  final contributorId;
  const ContributionScreen(
      {Key? key,
      required this.user,
      required this.contributors,
      this.data,
      this.contributorId,
      required this.contribution})
      : super(key: key);

  @override
  State<ContributionScreen> createState() => ContributionScreenState();
}

class ContributionScreenState extends State<ContributionScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          navigateAndRemoveUntilRoute(
              context,
              CreateContribution(
                  user: widget.user,
                  contributors: widget.contributors,
                  data: widget.data));
        },
        backgroundColor: appBrandColor,
        child: const Icon(Icons.wallet),
      ),
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          '${widget.data['firstName'].toString().toUpperCase()} ${widget.data['lastName'].toString().toUpperCase()}',
          style: TextStyle(color: appBrandColor, fontSize: 20),
        ),
        backgroundColor: const Color.fromARGB(255, 219, 219, 219),
        elevation: 0,
        leading: IconButton(
            onPressed: () {
              navigateAndRemoveUntilRoute(
                  context,
                  ContributorsScreen(
                    user: widget.user,
                    contributors: widget.contributors,
                  ));
            },
            icon: const Icon(
              Icons.keyboard_arrow_left_outlined,
              color: Colors.black,
              size: 30,
            )),
      ),
      backgroundColor: Colors.white,
      body: Column(
        children: [
          addVerticalSp(30),
          Expanded(
            child: ListView.builder(
                shrinkWrap: true,
                scrollDirection: Axis.vertical,
                itemCount: (widget.contribution.data) == null ? 0 : (widget.contribution.data).length,
                itemBuilder: (context, index) {
                  var data = json.encode(widget.contribution.data);
                  // return json.decode(data)["$index"]["contributor"] == widget.contributorId
                      return  Container(
                      alignment: Alignment.topCenter,
                      margin: EdgeInsets.symmetric(horizontal: 5),
                      width: 370,
                      // color: Colors.red,
                      child: _contributionTypeCard(context, index));
                }
                // child:
                ),
          ),
        ],
      ),
    );
  }

  Stack _contributionTypeCard(BuildContext context, index) {
    var contr = json.decode(json.encode(widget.contribution.data["${index}"]));

    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          padding: EdgeInsets.symmetric(),
            height: 300,
            width: double.infinity,
            decoration: BoxDecoration(
                image: const DecorationImage(
                  image: AssetImage(
                    "assets/images/curly_path.png",
                  ),
                  opacity: 0.3,
                ),
                color: (index == 0)
                    ? appCard1
                    : (index == 1)
                        ? appCard2
                        : appCard3,
                borderRadius: BorderRadius.circular(20)),
            child: Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '',
                    style: normalTextStyle(context)
                        .copyWith(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  addVerticalSp(20),
                  Text('',
                      style: normalTextStyle(context)
                          .copyWith(fontWeight: FontWeight.bold)),
                  Text('',
                      style: normalTextStyle(context).copyWith(fontSize: 15)),
                ],
              ),
            )),
        Positioned(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundImage: AssetImage('assets/images/avatar.jpg'),
                  ),
                  Column(
                    children: [
                      Text('${contr["name"]}'),
                      Text(
                          '${contr["goal"]} | ${contr["contributionPlan"]} | Self'),
                      addVerticalSp(10.0),
                      Text(
                        contr["contributes"] == []
                            ? 'N 0'
                            : json.encode(contr["goal"]),
                        style: TextStyle(
                            fontSize: 30.0, fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                  _infoButton(contr)
                ],
              ),
              addVerticalSp(20.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _button('Add Money', Icons.attach_money_sharp, contr["_id"]),
                  addHorizontalSp(20.0),
                  _button('Withdraw', Icons.money_off, contr["_id"]),
                ],
              )
            ],
          ),
        )
      ],
    );
  }

  Container _button(label, icon, contributionId) {
    final TextEditingController addMoneyController = TextEditingController();
    final _formKey = GlobalKey<FormState>();

    Future<void> _addMoney(contributionId) async {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Row(
          children: [
            CircularProgressIndicator(),
            addHorizontalSp(10.0),
            Text('Processing...')
          ],
        ),
        backgroundColor: Colors.green.shade300,
      ));
      ApiClient _apiClient = ApiClient();
      dynamic add_money = await _apiClient.addMoney(contributionId,
          int.parse(addMoneyController.text), widget.user.token);
      // print(add_money);
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      if (add_money['statusCode'] == 200) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Row(
            children: [
              Icon(
                Icons.check,
                color: Colors.white,
              ),
              addHorizontalSp(3.0),
              Text('Money Added Successfully'),
            ],
          ),
          backgroundColor: Colors.green.shade300,
        ));

        dynamic contribution = await _apiClient.contribution(widget.user.token);
        ContributionModel user_contribution =
            ContributionModel(data: contribution["data"]);

        return navigateToRoute(
            context,
            ContributionScreen(
                user: widget.user,
                contributors: widget.contributors,
                contributorId: widget.contributorId,
                data: widget.data,
                contribution: user_contribution));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Error: ${add_money['message']}'),
          backgroundColor: Colors.red.shade300,
        ));
      }
    }

    return Container(
      height: 40.0,
      width: 120.0,
      decoration: BoxDecoration(
          color: Colors.orangeAccent, borderRadius: BorderRadius.circular(10)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          PurpleAppElevatedButton(
              elevatedButton: Container(
                  child: Column(children: [
                Row(
                  children: [
                    Icon(
                      Icons.arrow_back_ios,
                      size: 12,
                    ),
                    addHorizontalSp(10),
                    Text(
                      "POS Transactions",
                      style: TextStyle(fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
                addVerticalSp(30),
                PurpleAppTextField(
                  keyboardType: TextInputType.number,
                  textEditingController: addMoneyController,
                  label: "Amount",
                  hintText: "Enter Amount",
                ),
                addVerticalSp(10),
                GestureDetector(
                  onTap: () {
                    _addMoney(
                      contributionId,
                    );
                  },
                  child: Container(
                    height: screenAwareSize(100, context),
                    width: screenWidth(context),
                    decoration: BoxDecoration(
                        color: appBrandColor,
                        borderRadius: BorderRadius.circular(10.0)),
                    child: Center(
                        child: Text(
                      'Add Money',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: screenAwareSize(28, context),
                      ),
                    )),
                  ),
                ),
              ])),
              card: Row(
                children: [
                  Icon(icon),
                  Text(
                    label,
                    style: TextStyle(fontWeight: FontWeight.w500),
                  )
                ],
              )),
        ],
      ),
    );
  }

  PurpleAppElevatedButton _infoButton(contr) {
    return PurpleAppElevatedButton(
      elevatedButton: Column(
        children: [
          Container(
            margin: const EdgeInsets.all(20),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
            decoration: const BoxDecoration(color: Color(0xFFEEF6FF)),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  const Icon(Icons.keyboard_arrow_down, size: 30),
                  Text(
                    'Contributes',
                    style: normalTextStyle(context)
                        .copyWith(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const Icon(Icons.keyboard_arrow_down, size: 30),
                ]),
          ),
          Expanded(
            child: ListView.builder(
              shrinkWrap: true,
              scrollDirection: Axis.vertical,
              itemCount: contr["contributes"].length,
              itemBuilder: (BuildContext context, int index) {
                return Container(
                  width: double.infinity,
                  margin:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                  decoration: const BoxDecoration(color: Color(0xFFF7F7F7)),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Text(
                          'N${contr["contributes"][index]["amount"]}',
                          style: normalTextStyle(context).copyWith(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: appBrandColor),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Received from ${widget.data['firstName']} ${widget.data['lastName']}',
                              style: normalTextStyle(context).copyWith(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              '${contr["contributes"][index]["date"]}',
                              style: normalTextStyle(context).copyWith(
                                  color: Colors.grey[500],
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        )
                      ]),
                );
              },
            ),
          ),
        ],
      ),
      card: Icon(Icons.remove_red_eye),
    );
  }

  Container _walletDetailsRow(title, info) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.0),
      // margin: EdgeInsets.only(bottom: 10.0),
      height: 70.0,
      width: 170,
      decoration: BoxDecoration(
          color: Colors.grey[200], borderRadius: BorderRadius.circular(10.0)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            title,
            style: TextStyle(color: appBrandColor, fontWeight: FontWeight.w600),
          ),
          addVerticalSp(5.0),
          Text(info)
        ],
      ),
    );
  }

  Container _walletDetailsColumn(title, info) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.0),
      margin: EdgeInsets.only(bottom: 10.0),
      height: 70.0,
      width: double.infinity,
      decoration: BoxDecoration(
          color: Colors.grey[200], borderRadius: BorderRadius.circular(10.0)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            title,
            style: TextStyle(color: appBrandColor, fontWeight: FontWeight.w600),
          ),
          addVerticalSp(5.0),
          Text(info)
        ],
      ),
    );
  }
}
