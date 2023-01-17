import 'package:flutter/material.dart';
import 'package:purple_app/api/api_client.dart';
import 'package:purple_app/api/model.dart';
import 'package:purple_app/functions.dart';
import 'package:purple_app/screens/home_screen.dart';
import 'package:purple_app/style/app_style.dart';
import 'package:purple_app/size_config.dart';
import 'package:purple_app/widget/button.dart';
import 'package:purple_app/widget/text_field.dart';

class SignIn extends StatelessWidget {
  SignIn({Key? key}) : super(key: key);
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    //Asyncronous function for login authentication
    Future<void> _loginUsers() async {
      ApiClient _apiClient = ApiClient();
      //If the textfields are not empty, Print "Signing-In"
      if (_formKey.currentState!.validate()) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          duration: Duration(seconds: 10),
          content: Row(
            children: [
              CircularProgressIndicator(),
              addHorizontalSp(10.0),
              Text('Signing-In')
            ],
          ),
          backgroundColor: Colors.green.shade300,
        ));
        //Process Login information - (check ApiClient login)
        dynamic res = await _apiClient.login(
          emailController.text,
          passwordController.text,
        );

        ScaffoldMessenger.of(context).hideCurrentSnackBar();
        //StatusCode of 1001 = Login Details found in database
        if (res['statusCode'] == 1001) {
          String accessToken = res['data']['accessToken'];
          dynamic isAgent = await _apiClient.getUserData(accessToken);
          //If User is an agent, allow login.
          if (isAgent['data']['role']['accessFor'] == 'AGENT') {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Row(
                children: [
                  Icon(
                    Icons.check,
                    color: Colors.white,
                  ),
                  addHorizontalSp(3.0),
                  Text('Login Successful'),
                ],
              ),
              backgroundColor: Colors.green.shade300,
            ));
            UserModel user = loadUser(isAgent, accessToken);
            print(user);
            //Load Contributors
            dynamic Contributors = await _apiClient.contributors(accessToken);
            ContributorModel contributors =
                ContributorModel(data: Contributors['data']);
            return navigateToRoute(
                context, HomePage(user: user, contributors: contributors));
          }
          //If user is not an agent, return Unauthorized User.
          else {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text('Error: Unauthorized User'),
              backgroundColor: Colors.red.shade300,
            ));
          }
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

    return Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 20.0, vertical: 60.0),
            child: Form(
              key: _formKey,
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
                      "SIGN IN",
                      style: bigTextStyle(context).copyWith(
                        letterSpacing: -1,
                        fontSize: 50,
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
                        "We are glad to have you back \nEnter your email address or Phone Number below",
                        textAlign: TextAlign.center,
                        style: normalTextStyle(context).copyWith(
                          fontSize: screenAwareSize(16, context),
                          fontWeight: FontWeight.w100,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                  addVerticalSp(50),
                  PurpleAppTextField(
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your email';
                      }
                      return null;
                    },
                    textEditingController: emailController,
                    label: "",
                    hintText: "Email Address",
                  ),
                  addVerticalSp(20),
                  PurpleAppTextField(
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your password';
                      }
                      return null;
                    },
                    // controller: emailController,
                    keyboardType: TextInputType.visiblePassword,
                    textEditingController: passwordController,
                    obscureText: true,
                    label: "",
                    hintText: "Password",
                  ),
                  addVerticalSp(30),
                  PurpleAppButton(
                    width: screenWidth(context),
                    height: screenAwareSize(100, context),
                    label: "Log in",
                    onClick: _loginUsers,
                  ),
                ],
              ),
            ),
          ),
        ));
  }

  UserModel loadUser(isAgent, accessToken) {
    return UserModel(
        id: (isAgent['data']['_id']),
        firstName: isAgent['data']['firstName'],
        lastName: isAgent['data']['lastName'],
        email: isAgent['data']['email'],
        mobileNumber: int.parse(isAgent['data']['mobileNumber']),
        token: accessToken,
        role: isAgent['data']['role']['accessFor']);
  }
}
