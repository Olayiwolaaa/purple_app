import 'package:flutter/material.dart';
import 'package:purple_app/api/api_client.dart';
import 'package:purple_app/api/model.dart';
import 'package:purple_app/functions.dart';
import 'package:purple_app/size_config.dart';
import 'package:purple_app/style/app_style.dart';
import 'package:purple_app/widget/button.dart';
import 'package:purple_app/widget/text_field.dart';
import 'contributors_screen.dart';

class CreateContribution extends StatefulWidget {
  final UserModel user;
  final ContributorModel contributors;
  final data;
  CreateContribution(
      {Key? key, required this.user, required this.contributors, this.data})
      : super(key: key);

  @override
  State<CreateContribution> createState() => _CreateContributionState();
}

enum Fruit { daily, weekly, monthly }

class _CreateContributionState extends State<CreateContribution> {
  Fruit? _fruit = Fruit.daily;
  final TextEditingController nameController = TextEditingController();
  final TextEditingController amountController = TextEditingController();
  final TextEditingController startDateController = TextEditingController();
  final TextEditingController endDateController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    //Asyncronous function for creating a contribution
    Future<void> _createContributor() async {
      ApiClient _apiClient = ApiClient();
      if (_formKey.currentState!.validate()) {
        //If the textfields are not empty, Print "Creating Contribution"
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Row(
            children: [
              CircularProgressIndicator(),
              addHorizontalSp(10.0),
              Text('Creating Contribution')
            ],
          ),
          backgroundColor: Colors.green.shade300,
        ));

        //Process create contribution information - (check ApiClient createContribution)
        dynamic res = await _apiClient.createContribution(
          widget.user.id,
          widget.data["_id"],
          _fruit.toString().split('.').last,
          nameController.text,
          int.parse(amountController.text),
          startDateController.text,
          endDateController.text,
          widget.user.token,
        );
        // Print api response
        print(res);

        //StatusCode of 201 = Login Details found in database
        if (res['statusCode'] == 201) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Row(
              children: [
                Icon(
                  Icons.check,
                  color: Colors.white,
                ),
                addHorizontalSp(3.0),
                Text('Contribution Successfully Created'),
              ],
            ),
            backgroundColor: Colors.green.shade300,
          ));
          //go-to Contributors Screen
          return navigateToRoute(
              context,
              ContributorsScreen(
                  user: widget.user, contributors: widget.contributors));
        }
        // If any error occur
        else {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text('Error: ${res['message']}'),
            backgroundColor: Colors.red.shade300,
          ));
        }
      }
    }

    return Form(
      key: _formKey,
      child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            leading: IconButton(
                onPressed: () {
                  navigateAndRemoveUntilRoute(context, ContributorsScreen(
                  user: widget.user, contributors: widget.contributors));
                },
                icon: const Icon(
                  Icons.keyboard_arrow_left_outlined,
                  color: Colors.black,
                  size: 30,
                )),
          ),
          backgroundColor: Colors.white,
          body: SingleChildScrollView(
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Center(
                    child: CircleAvatar(
                      backgroundImage: AssetImage(AppImagePaths.appLogo),
                    ),
                  ),
                  addVerticalSp(30),
                  Center(
                    child: Text(
                      "Add New Contribution",
                      style: bigTextStyle(context).copyWith(
                        letterSpacing: -1,
                        // fontSize: 50,
                        fontWeight: FontWeight.w800,
                        color: appBrandColor,
                      ),
                    ),
                  ),
                  addVerticalSp(5),
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.only(right: 20.0),
                      child: Text(
                        "Fill in the data below to create a contribution",
                        textAlign: TextAlign.center,
                        style: normalTextStyle(context).copyWith(
                          fontSize: screenAwareSize(16, context),
                          fontWeight: FontWeight.w100,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                  addVerticalSp(30),
                  Row(
                    children: [
                      Radio<Fruit>(
                        value: Fruit.daily,
                        groupValue: _fruit,
                        onChanged: (Fruit? value) {
                          setState(() {
                            _fruit = value;
                          });
                        },
                      ),
                      Text('Daily'),
                      Radio<Fruit>(
                        value: Fruit.weekly,
                        groupValue: _fruit,
                        onChanged: (Fruit? value) {
                          setState(() {
                            _fruit = value;
                          });
                        },
                      ),
                      Text('Weekly'),
                      Radio<Fruit>(
                        value: Fruit.monthly,
                        groupValue: _fruit,
                        onChanged: (Fruit? value) {
                          setState(() {
                            _fruit = value;
                          });
                        },
                      ),
                      Text('Monthly'),
                    ],
                  ),
                  addVerticalSp(10),
                  PurpleAppTextField(
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your firstname';
                      }
                      return null;
                    },
                    keyboardType: TextInputType.name,
                    textEditingController: nameController,
                    label: "Name",
                    hintText: "e.g Holiday Getaway",
                  ),
                  addVerticalSp(30),
                  PurpleAppTextField(
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your lastname';
                      }
                      return null;
                    },
                    keyboardType: TextInputType.number,
                    textEditingController: amountController,
                    label: "Amount",
                    hintText: "How much to save based on contributopn plan",
                  ),
                  addVerticalSp(30),
                  PurpleAppTextField(
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your mobile number';
                      }
                      return null;
                    },
                    keyboardType: TextInputType.datetime,
                    textEditingController: startDateController,
                    label: "Start Date",
                    hintText: "YY-MM-DD",
                  ),
                  addVerticalSp(30),
                  PurpleAppTextField(
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your mobile number';
                      }
                      return null;
                    },
                    keyboardType: TextInputType.datetime,
                    textEditingController: endDateController,
                    label: "End Date",
                    hintText: "YY-MM-DD",
                  ),
                  addVerticalSp(30),
                  PurpleAppButton(
                    width: screenWidth(context),
                    height: screenAwareSize(100, context),
                    label: "Create Contribution",
                    onClick: _createContributor,
                    // onClick: () {},
                  )
                ],
              ),
            ),
          )),
    );
  }

  Container _contributionPlan(plan) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.grey[300], borderRadius: BorderRadius.circular(10.0)),
      height: 60.0,
      width: double.infinity,
      child: Center(
        child: Text(
          '${plan}',
          style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.w500),
        ),
      ),
    );
  }
}
