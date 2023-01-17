import 'package:flutter/material.dart';
import 'package:purple_app/api/api_client.dart';
import 'package:purple_app/api/model.dart';
import 'package:purple_app/style/app_style.dart';
import 'package:purple_app/functions.dart';
import 'package:purple_app/screens/home_screen.dart';
import 'package:purple_app/size_config.dart';
import 'package:purple_app/widget/button.dart';
import 'package:purple_app/widget/text_field.dart';
import 'contributors_screen.dart';

class CreateContributor extends StatefulWidget {
  final UserModel user;
  final ContributorModel contributors;
  CreateContributor({Key? key, required this.user, required this.contributors})
      : super(key: key);

  @override
  State<CreateContributor> createState() => _CreateContributorState();
}

class _CreateContributorState extends State<CreateContributor> {
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController mobileNumberController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    //Asyncronous function for creating contributor
    Future<void> _createContributor() async {
      ApiClient _apiClient = ApiClient();
      //If the textfields are not empty, Print "Creating Contributor"
      if (_formKey.currentState!.validate()) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Row(
            children: [
              CircularProgressIndicator(),
              addHorizontalSp(10.0),
              Text('Creating Contributor')
            ],
          ),
          backgroundColor: Colors.green.shade300,
        ));

        //Process create contributor information - (check ApiClient createContributor)
        dynamic res = await _apiClient.createContributor(
          firstNameController.text,
          lastNameController.text,
          addressController.text,
          (mobileNumberController.text).toString(),
          widget.user.id,
          widget.user.token,
        );

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
                Text('Contributor Successfully Created'),
              ],
            ),
            backgroundColor: Colors.green.shade300,
          ));
          //Load Contributors
          dynamic Contributors =
              await _apiClient.contributors(widget.user.token);
          ContributorModel contributors =
              ContributorModel(data: Contributors['data']);
          //go-to Contributors Screen
          return navigateToRoute(
              context,
              ContributorsScreen(
                  user: widget.user, contributors: contributors));
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
                      "Add New Contributor",
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
                        "Fill in the data below to create a contributor",
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
                  PurpleAppTextField(
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your firstname';
                      }
                      return null;
                    },
                    keyboardType: TextInputType.name,
                    textEditingController: firstNameController,
                    label: "FirstName",
                    hintText: "e.g, Joe",
                  ),
                  addVerticalSp(30),
                  PurpleAppTextField(
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your lastname';
                      }
                      return null;
                    },
                    keyboardType: TextInputType.name,
                    textEditingController: lastNameController,
                    label: "LastName",
                    hintText: "e.g, Joe",
                  ),
                  addVerticalSp(30),
                  PurpleAppTextField(
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your mobile number';
                      }
                      return null;
                    },
                    keyboardType: TextInputType.number,
                    textEditingController: mobileNumberController,
                    label: "Mobile Number",
                    hintText: "e.g, +234 234 5454 641",
                  ),
                  addVerticalSp(30),
                  PurpleAppTextField(
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your address';
                      }
                      return null;
                    },
                    keyboardType: TextInputType.streetAddress,
                    textEditingController: addressController,
                    label: "Address",
                    hintText: "e.g, Block 4D, Lekki, Lagos Island.",
                  ),
                  addVerticalSp(30),
                  PurpleAppButton(
                      width: screenWidth(context),
                      height: screenAwareSize(100, context),
                      label: "Next",
                      onClick: _createContributor)
                ],
              ),
            ),
          )),
    );
  }
}
