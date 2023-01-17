import 'package:flutter/material.dart';
import 'package:purple_app/api/model.dart';
import 'package:purple_app/style/app_style.dart';
import 'package:purple_app/screens/contributors_screen.dart';
import 'package:purple_app/size_config.dart';
import 'package:purple_app/widget/card.dart';

class HomePage extends StatefulWidget {
  final UserModel user;
  final ContributorModel contributors;
  const HomePage({Key? key, required this.user, required this.contributors})
      : super(key: key);


  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    Future<bool> onWillPop() async {
      final shouldPop = await showDialog(
          context: context,
          builder: (context) => AlertDialog(
                content: Text("Do you want to Close this App?"),
                actions: <Widget>[
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(false),
                    child: Text("No"),
                  ),
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(true),
                    child: Text("Yes"),
                  ),
                ],
              ));

      return shouldPop ?? false;
    }

    return WillPopScope(
      onWillPop: onWillPop,
      child: Scaffold(
        appBar: AppBar(
            elevation: 0,
            backgroundColor: appBrandColor,
            automaticallyImplyLeading: false,
            title: GestureDetector(
              // onTap: () => navigateAndRemoveUntilRoute(
              //     context,
              //     ProfilePage(
              //         user: widhvkjbget.user, contributors: widget.contributors)),
              child: Row(
                children: [
                  const CircleAvatar(
                    backgroundImage: AssetImage('assets/images/avatar.jpg'),
                  ),
                  addHorizontalSp(15),
                  Text('Welcome Back,  ${widget.user.firstName} ${widget.user.lastName}',
                      style: normalTextStyle(context).copyWith(
                          fontSize: 16,
                          color: Colors.white,
                          fontWeight: FontWeight.bold)),
                ],
              ),
            )),
        backgroundColor: Colors.white,
        body: Center(
          child: Column(
            children: [
              addVerticalSp(30),
              Text('Click the button below to view all Contributors'),
              PurpleAppCard(
                  label: 'Contributors',
                  page: ContributorsScreen(
                      user: widget.user,
                      contributors: widget.contributors,
                    ),
                  colour: Colors.purple[200]
                  ),
            ],
          ),
        ),
      ),
    );
  }
}
