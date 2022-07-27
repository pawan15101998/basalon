// ignore_for_file: avoid_print

import 'package:basalon/network/login_register_network.dart';
import 'package:basalon/screens/home_screen.dart';
import 'package:basalon/screens/login/registration_screen.dart';
import 'package:basalon/widgets/custom_buttons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../blocs/application_bloc.dart';
import '../../constant/login_user.dart';
import '../../modal/login_data.dart';
import '../../services/constant.dart';
import '../../widgets/RegistrationTextField.dart';

class SignInScreen extends StatefulWidget {
  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  bool _secureText = true;
  Map? userData;
  LoginData? getLoginData;

  final emailController = TextEditingController();
  final forgotEmailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    emailController.dispose();
    forgotEmailController.dispose();
    passwordController.dispose();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  late final application = Provider.of<ApplicationBloc>(context, listen: false);

  void errorAlertMessage(String errorMessage, BuildContext context) {
    showDialog<String>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        actionsAlignment: MainAxisAlignment.center,
        content: Text(errorMessage,textDirection: TextDirection.rtl,),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text(
              'אישור',
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    late LoginRegisterNetwork _loginRegisterNetwork = LoginRegisterNetwork(
        emailController: emailController.text,
        passwordController: passwordController.text);
    return SafeArea(
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size(80, 40),
          child: GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: Align(
              child: Padding(
                padding: const EdgeInsets.only(left: 15, top: 15),
                child: Image.asset("assets/images/Back_button.png"),
              ),
              alignment: Alignment.topLeft,
            ),
          ),
        ),
        body: SingleChildScrollView(
          child: Align(
            alignment: Alignment.topCenter,
            child: Column(
              children: [
                const Text(
                  'התחברות',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 32,
                  ),
                ),
                const SizedBox(height: 25),
                Padding(
                  padding: const EdgeInsets.all(18.0),
                  child: ElevatedButton(
                    onPressed: () async {
                      print('facebook login,,,,,,,,,,,');
                      final result = await FacebookAuth.i.login(permissions: [
                        "public_profile",
                        "email",
                      ]);
                      if (result.status == LoginStatus.success) {
                        final requestData = await FacebookAuth.i.getUserData(
                            fields:
                                "email, name, picture.height(200).width(200)");

                              

                        setState(() {
                          userData = requestData;
                          LoginUser(
                            userName: userData!['name'],
                            email: userData!['email'] != null
                                ? userData!['email']
                                : userData!['name'],
                            userId: int.parse(userData!['id']),
                          );
                          // LoginUser.shared?.userId = int.parse(userData!['id']);
                        });

                        setState(() {
                          application.imageFromFacebook =
                              userData!['picture']['data']['url'];
                          application.emailFromFacebook = userData!['email'];
                          application.nameFromFacebook = userData!['name'];
                          application.isUserLogin = true;
                        });
                        print(int.parse(userData!['id']));
                        print(result.accessToken?.token);
                        print(result.status);
                        print(result.message);
                        print('-------------------FACEBOOK----------------');
                        SharedPreferences sharedPreferences =
                            await SharedPreferences.getInstance();
                        sharedPreferences.setString(
                            'email',
                            userData!['email'] != null
                                ? userData!['email']
                                : userData!['name']);
                        sharedPreferences.setString('facebookName',
                            userData!['name'] != null ? userData!['name'] : '');
                        sharedPreferences.setString(
                            'facebookImage',
                            userData!['picture']['data']['url'] != null
                                ? userData!['picture']['data']['url']
                                : 'no image found ---------');
                        // sharedPreferences.setInt(
                        //     'loginId', int.parse(userData!['id']));
                        await _loginRegisterNetwork.registerFbData(
                            result.accessToken?.token,
                            int.parse(userData!['id']));

                        //Navigator.pushNamed(context, HomeScreen.route);
                        Navigator.of(context).pushAndRemoveUntil(
                            MaterialPageRoute(
                                builder: (context) => HomeScreen()),
                            (Route<dynamic> route) => false);
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      primary: const Color.fromRGBO(25, 119, 243, 1),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5)),
                      shadowColor: Colors.transparent,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(bottom: 5),
                          child: Image.asset("assets/images/facebook.png"),
                        ),
                        const Text('המשיכו עם פייסבוק',
                            style: TextStyle(fontSize: 20))
                      ],
                    ),
                  ),
                ),
                const Text(
                  'או',
                  style: ktextStyleBoldMedium,
                ),
                const SizedBox(height: 20),
                RegistrationTextInput(
                  obscureText: false,
                  controller: emailController,
                  hintText: 'אימייל',
                ),
                RegistrationTextInput(
                  obscureText: _secureText,
                  controller: passwordController,
                  hintText: 'סיסמה',
                  prefixIcon: GestureDetector(
                    onTap: () {
                      setState(() {
                        _secureText = !_secureText;
                      });
                    },
                    child: Icon(
                      _secureText ? Icons.visibility : Icons.visibility_off,
                      color: const Color.fromRGBO(144, 144, 144, 1),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 15, right: 15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      GestureDetector(
                        onTap: () {
                          showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  titlePadding: EdgeInsets.zero,
                                  title: SizedBox(
                                    height: 50,
                                    width: width,
                                    child: ElevatedButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      //child: const Text('שכחת את הסיסמא', style: TextStyle(fontSize: 20)),
                                      child: const Text('?שכחת ססמה',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 22,
                                              color: Colors.black)),
                                      style: ElevatedButton.styleFrom(
                                        //primary: const Color.fromRGBO(116, 101, 255, 1),
                                        primary: Colors.transparent,
                                        shadowColor: Colors.transparent,
                                      ),
                                    ),
                                  ),
                                  content: SizedBox(
                                    height: 200,
                                    child: Column(
                                      children: [
                                        const Text(
                                          'הזן את כתובת הדוא"ל שלך ואנו נשלח לך קישור שבו תוכל להשתמש כדי לבחור סיסמה חדשה.',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            color:
                                                Color.fromRGBO(92, 92, 92, 1),
                                            fontSize: 15,
                                          ),
                                        ),
                                        const SizedBox(height: 20),
                                        Container(
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  const BorderRadius.all(
                                                      Radius.circular(5)),
                                              border: Border.all(
                                                  color: const Color.fromRGBO(
                                                      216, 216, 216, 1))),
                                          child: TextField(
                                              controller: forgotEmailController,
                                              maxLines: 1,
                                              style: TextStyle(fontSize: 15),
                                              textAlignVertical:
                                                  TextAlignVertical.top,
                                              textAlign: TextAlign.end,
                                              decoration: InputDecoration(
                                                border: InputBorder.none,
                                                contentPadding: EdgeInsets.only(
                                                    left: 10, right: 10),
                                                hintText: 'הכנס את האימייל שלך',
                                              )),
                                        ),
                                        const SizedBox(height: 20),
                                        SizedBox(
                                          height: 50,
                                          width: width,
                                          child: ElevatedButton(
                                            onPressed: () async {
                                              Navigator.pop(context);
                                              if (forgotEmailController
                                                  .text.isNotEmpty) {
                                                _loginRegisterNetwork
                                                    .forgotPassword(
                                                  forgotEmailController.text,
                                                  context,
                                                );
                                                errorAlertMessage(
                                                    'שלחנו לך מייל עם הנחיות לאיפוס הסיסמה',
                                                    context);
                                              }
                                            },
                                            child: const Text('לאפס את הסיסמה',
                                                style: TextStyle(fontSize: 20)),
                                            style: ElevatedButton.styleFrom(
                                              primary: const Color.fromRGBO(
                                                  233, 108, 96, 1),
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(5),
                                              ),
                                              shadowColor: Colors.transparent,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              });
                        },
                        child: const Text('שכחתי סיסמה',
                            style: TextStyle(
                              fontSize: 15,
                              color: Color.fromRGBO(60, 74, 255, 1),
                            )),
                      ),
                      const Text(' | ',
                          style: TextStyle(
                            fontSize: 15,
                            color: Color.fromRGBO(60, 74, 255, 1),
                          )),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const RegistrationScreen()));
                        },
                        child: const Text('הרשמה',
                            style: TextStyle(
                              fontSize: 15,
                              color: Color.fromRGBO(60, 74, 255, 1),
                            )),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 40),
                CustomButton(
                  height: 50,
                  width: width - 30,
                  text: ' התחברות',
                  textStyle: TextStyle(fontSize: 20),
                  onPressed: () async {
                    SharedPreferences sharedPreferences =
                        await SharedPreferences.getInstance();
                    sharedPreferences.setString('email', emailController.text);
                    setState(() {
                      application.idFromLocalProvider =
                          sharedPreferences.getInt('loginId');
                      // application.isUserLogin = true;
                    });

                    if (emailController.text.isEmpty) {
                      _loginRegisterNetwork.errorAlertMessage(
                          "Please enter email!", context);
                    } else if (passwordController.text.isEmpty) {
                      _loginRegisterNetwork.errorAlertMessage(
                          'Please enter password!', context);
                    } else {
                      print(
                          'email is - ${emailController.text} and password is - ${passwordController.text}');
                      EasyLoading.show();
                      // loginData();
                      print('ooooooooooooo');

                      _loginRegisterNetwork.getUserLoginData(context);
                    }
                  },
                  color: Color.fromRGBO(233, 108, 96, 1),
                ),
                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }
}