import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:local_auth/local_auth.dart';
import 'package:webinar/app/pages/authentication_page/forget_password_page.dart';
import 'package:webinar/app/pages/authentication_page/register_page.dart';
import 'package:webinar/app/pages/main_page/home_page/single_course_page/single_content_page/web_view_page.dart';
import 'package:webinar/app/pages/main_page/main_page.dart';
import 'package:webinar/app/providers/page_provider.dart';
import 'package:webinar/app/services/authentication_service/authentication_service.dart';
import 'package:webinar/app/widgets/authentication_widget/auth_widget.dart';
import 'package:webinar/app/widgets/authentication_widget/register_widget/register_widget.dart';
import 'package:webinar/app/widgets/main_widget/main_widget.dart';
import 'package:webinar/common/components.dart';
import 'package:webinar/common/common.dart';
import 'package:webinar/common/data/api_public_data.dart';
import 'package:webinar/common/enums/page_name_enum.dart';
import 'package:webinar/common/utils/constants.dart';
import 'package:webinar/locator.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../../../common/utils/app_text.dart';
import '../../../config/assets.dart';
import '../../../config/colors.dart';
import '../../../config/styles.dart';
import '../../widgets/authentication_widget/country_code_widget/code_country.dart';
import 'biometric_db.dart';



class LoginPage extends StatefulWidget {
  static const String pageName = '/login';
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  TextEditingController mailController = TextEditingController();
  FocusNode mailNode = FocusNode();
  bool isSwitched =false;
  // TextEditingController phoneController = TextEditingController();
  // FocusNode phoneNode = FocusNode();
  
  TextEditingController passwordController = TextEditingController();
  FocusNode passwordNode = FocusNode();

  String? otherRegisterMethod;
  bool isEmptyInputs=true;
  bool isPhoneNumber=true;
  bool isSendingData=false;
  bool checkbiometricdata=false;
  DatabaseHelper db = DatabaseHelper();
  CountryCode countryCode = CountryCode(
    code: "US",
    dialCode: "+1",
    flagUri: "${AppAssets.flags}en.png",
    name: "United States"
  );

  @override
  void initState() {
    super.initState();

    if((PublicData.apiConfigData?['register_method'] ?? '') == 'email'){
      isPhoneNumber = false;
      otherRegisterMethod = 'email';
    }else{
      isPhoneNumber = true;
      otherRegisterMethod = 'phone';
    }


    mailController.addListener(() {
      if( (mailController.text.trim().isNotEmpty) && passwordController.text.trim().isNotEmpty){
        if(isEmptyInputs){
          isEmptyInputs = false;
          setState(() {});
        }
      }else{
        if(!isEmptyInputs){
          isEmptyInputs = true;
          setState(() {});
        }
      }
    });

    passwordController.addListener(() {
      if( (mailController.text.trim().isNotEmpty) && passwordController.text.trim().isNotEmpty){
        if(isEmptyInputs){
          isEmptyInputs = false;
          setState(() {});
        }
      }else{
        if(!isEmptyInputs){
          isEmptyInputs = true;
          setState(() {});
        }
      }
    });
    checktable();

  }
  final LocalAuthentication auth = LocalAuthentication();



  Future<void> checktable () async {
    checkbiometricdata = await  db.checkTable();
    print("table data: ${checkbiometricdata}");
   setState(() {

   });
  }

  Future<void> authenticate(BuildContext context) async {
    try {

      bool isBiometricAvailable = await auth.canCheckBiometrics;

      if (!isBiometricAvailable) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Biometric authentication is not available on this device.'),
          ),
        );
        return;
      }

      // Check for enrolled biometrics (e.g., face or fingerprint)
      List<BiometricType> availableBiometrics = await auth.getAvailableBiometrics();
      if (availableBiometrics.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('No biometrics enrolled. Please set up biometrics on your device.'),
          ),
        );
        return;
      }

      // Perform authentication
      bool authenticated = await auth.authenticate(
        localizedReason: 'Authenticate to proceed.',
        options: const AuthenticationOptions(
          biometricOnly: true, // Only allow biometrics (no device PIN/fallback)
          //stickyAuth: true, // Keeps authentication active until success or failure
        ),
      );

      // Handle authentication result
      if (authenticated) {
        DatabaseHelper db = DatabaseHelper();
        var data1 = ( await db.getUser())!;
        setState(() {
          isSendingData=true;
        });
        bool res = await AuthenticationService.login(
            '${isPhoneNumber ? countryCode.dialCode!.replaceAll('+', '') : ''}${data1['email']}', data1['password'], isSwitched
        );
        setState(() {
          isSendingData=false;
        });

        if(res){
          await FirebaseMessaging.instance.deleteToken();
          locator<PageProvider>().setPage(PageNames.home);
          nextRoute(MainPage.pageName,isClearBackRoutes: true);
        }
      } else {

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Authentication Failed. Please try again.'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      // Handle unexpected errors
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('An error occurred: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }


  @override
  Widget build(BuildContext context) {

    return WillPopScope(
      // canPop: false,
      // onPopInvoked: (re){
      //   MainWidget.showExitDialog();
      // },

      onWillPop: () async {
        // Show the exit dialog
        MainWidget.showExitDialog();
        return false; // Prevent default back navigation
      },

      child: directionality(
        child: Scaffold(
          body: Stack(
            children: [
      
              Positioned.fill(
                child: Image.asset(
                  AppAssets.introBgPng,
                  width: getSize().width,
                  height: getSize().height,
                  fit: BoxFit.cover,
                )
              ),
      
      
              Positioned.fill(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  padding: padding(),
                  child: Column(
                    children: [
                      SizedBox(height: 30,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          closeButton(AppAssets.backSvg, onTap: (){
                            Navigator.pop(context);
                            locator<PageProvider>().setPage(PageNames.home);
                            nextRoute(MainPage.pageName, isClearBackRoutes: true);
                          }),
                        ],
                      ),
      // InkWell(
      //     onTap: (){
      //       Navigator.pop(context);
      //      locator<PageProvider>().setPage(PageNames.home);
      //       nextRoute(MainPage.pageName, isClearBackRoutes: true);
      //     },
      //     child: Icon(Icons.arrow_back)),
                      space(getSize().height * .05),
      
                      // title
                      Row(
                        children: [
      
                          Text(
                            appText.welcomeBack,
                            style: style24Bold(),
                          ),
      
                          space(0,width: 4),
      
                          SvgPicture.asset(AppAssets.emoji2Svg)
                        ],
                      ),
      
                      // desc
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            appText.welcomeBackDesc,
                            style: style14Regular().copyWith(color: greyA5),
                            textAlign: TextAlign.start,
                          ),
                        ],
                      ),
      
                      space(50),
      
                      // google and facebook auth
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [

                          if(PublicData.apiConfigData?['show_google_login_button'] ?? false)...{

                            socialWidget(AppAssets.googleSvg, () async {
                              final GoogleSignInAccount? gUser = await GoogleSignIn().signIn();
                              final GoogleSignInAuthentication gAuth = await gUser!.authentication;


                              if(gAuth.accessToken != null){

                                setState(() {
                                  isSendingData = true;
                                });
                                try{
                                  bool res = await AuthenticationService.google(gUser.email, gAuth.accessToken ?? '', gUser.displayName ?? '');
print("Res:${res}");
                                  if(res){

                                    await FirebaseMessaging.instance.deleteToken();
                                    nextRoute(MainPage.pageName,isClearBackRoutes: true);
                                  }
                                }
                                catch(e, stack)
                                {
                                  print("stack: ${stack}");
                                  print("errorrrr: ${e.toString()}");
                                }

                                setState ( () {
                                  isSendingData = false;
                                } );


                              }
                            }),

                            space(0,width: 20),
                          },
                          
                          if(PublicData.apiConfigData?['show_facebook_login_button'] ?? false)...{
                            socialWidget(AppAssets.facebookSvg, () async {
                              // try{
                                final LoginResult result = await FacebookAuth.instance.login(permissions: ['email']);
                                
                                if (result.status == LoginStatus.success) {
                                  final AccessToken accessToken = result.accessToken!;
                                  
                                  setState(() {
                                    isSendingData = true;
                                  });
                                  
                                  FacebookAuth.instance.getUserData().then((value) async {
      
                                    String email = value['email'];
                                    String name = value['name'] ?? '';
      
                                    try{
                                      bool res = await AuthenticationService.facebook(email, accessToken.tokenString, name);
      
                                      if(res){
                                        await FirebaseMessaging.instance.deleteToken();

                                        nextRoute(MainPage.pageName,isClearBackRoutes: true);
                                      }
                                    }catch(_){}
                                    
                                    setState(() {
                                      isSendingData = false;
                                    });
                                  });
      
                                } else {}
                              // }catch(e){}
                            }),
                            
                          }
                        ],
                      ),
      
                      // space(25),
                      //
                      // // Other Register Method
                      // if(PublicData.apiConfigData?['showOtherRegisterMethod'] == '1')...{
                      //   space(15),
                      //
                      //   Container(
                      //     decoration: BoxDecoration(
                      //       color: Colors.white,
                      //       borderRadius: borderRadius()
                      //     ),
                      //
                      //     width: getSize().width,
                      //     height:  52,
                      //
                      //     child: Row(
                      //       children: [
                      //
                      //         // email
                      //         AuthWidget.accountTypeWidget(appText.email, otherRegisterMethod ?? '', 'email', (){
                      //           setState(() {
                      //             otherRegisterMethod = 'email';
                      //             isPhoneNumber = false;
                      //             mailController.clear();
                      //           });
                      //         }),
                      //
                      //         // email
                      //         AuthWidget.accountTypeWidget(appText.phone, otherRegisterMethod ?? '', 'phone', (){
                      //           setState(() {
                      //             otherRegisterMethod = 'phone';
                      //             isPhoneNumber = true;
                      //             mailController.clear();
                      //           });
                      //         }),
                      //
                      //       ],
                      //     )
                      //   ),
                      //
                       space(15),
                      //
                      // },
                      //
                      // input
                      Column(
                        children: [
                          
                          if(isPhoneNumber)...{
                            // phone input
                            Row(
                              children: [
      
                                // country code
                                GestureDetector(
                                  onTap: () async {
                                    CountryCode? newData = await RegisterWidget.showCountryDialog();
      
                                    if(newData != null){
                                      countryCode = newData;
                                      setState(() {});
                                    } 
                                  },
                                  behavior: HitTestBehavior.opaque,
                                  child: Container(
                                    width: 52,
                                    height: 52,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: borderRadius()
                                    ),
                                    alignment: Alignment.center,
                                    child: ClipRRect(
                                      borderRadius: borderRadius(radius: 50),
                                      child: Image.asset(
                                        countryCode.flagUri ?? '',
                                        width: 21,
                                        height: 19,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                ),
      
                                space(0,width: 15),
      
                                Expanded(child: input(mailController, mailNode, appText.phoneNumber))  
                              ],
                            )
                          }else ...{
                            input(mailController, mailNode, appText.email, iconPathLeft: AppAssets.mailSvg,leftIconSize: 14),
                          },
      
                          space(16),
                          
                          input(passwordController, passwordNode, appText.password, iconPathLeft: AppAssets.passwordSvg,leftIconSize: 14,isPassword: true),
      
                        ],
                      ),
      
                      space(32),
      
                      // button
                      Center(
                        child: button(
                          onTap: () async {
      
                            FocusScope.of(context).unfocus();
      
                            if( mailController.text.trim().isNotEmpty && passwordController.text.trim().isNotEmpty){
                              setState(() {
                                isSendingData=true;
                              });
                              
                              bool res = await AuthenticationService.login(
                                '${isPhoneNumber ? countryCode.dialCode!.replaceAll('+', '') : ''}${mailController.text.trim()}', passwordController.text.trim(), isSwitched
                              );
      
                              
                              setState(() {
                                isSendingData=false;
                              });
                              
                              if(res){
                                await FirebaseMessaging.instance.deleteToken();

                                locator<PageProvider>().setPage(PageNames.home);
                                nextRoute(MainPage.pageName,isClearBackRoutes: true);
                              }
                            }
                          }, 
                          width: getSize().width, 
                          height: 52, 
                          text: appText.license,
                          bgColor: isEmptyInputs ? greyCF : green77(), 
                          textColor: Colors.white, 
                          borderColor: Colors.transparent,
                          isLoading: isSendingData
                        ),
                      ),
                      if(checkbiometricdata ==false)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text('Enable thumb Recognition', style: style12Regular(),),
                          Switch(
                            value:isSwitched,
                            onChanged: (value) {

                              setState(() {
                                isSwitched = value;
                                print(isSwitched);
                              });
                            },
                            activeColor: green77(), // On state color
                            inactiveThumbColor: Colors.black.withOpacity(0.5), // Off state color
                            inactiveTrackColor: Colors.grey,
                          ),
                        ],
                      ),
                      space(30),
                      if(checkbiometricdata ==true)
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [

                         InkWell(
                             onTap: () async {
                              await  authenticate(context);
                             },
                             child: Container(
                                 decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
                                 child: Image.asset(AppAssets.thumb, height: 60,width: 60,color: green77(),))),
                          space(10),

                          Text('Touch ID', style: style12Regular(),),
                        ],
                      ),



                      space(35),
      
                      // haveAnAccount
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            appText.dontHaveAnAccount,
                            style: style16Regular(),
                          ),
      
                          space(0,width: 2),
      
                          GestureDetector(
                            onTap: (){
                              nextRoute(RegisterPage.pageName,isClearBackRoutes: true);
                            },
                            behavior: HitTestBehavior.opaque,
                            child: Text(
                              appText.signup,
                              style: style16Regular(),
                            ),
                          )
                        ],
                      ),
      
                      space(10),
      
                      Center(
                        child: GestureDetector(
                          onTap: (){
                            nextRoute(ForgetPasswordPage.pageName);
                          },
                          behavior: HitTestBehavior.opaque,
                          child: Text(
                            appText.forgetPassword,
                            style: style16Regular().copyWith(color: greyB2),
                          ),
                        ),
                      ),
      
                      space(55),


                      // termsPoliciesDesc
                      Center(
                        child: GestureDetector(
                          onTap: (){
                            //nextRoute(WebViewPage.pageName, arguments: ['${Constants.dommain}/pages/app-terms', appText.webinar, false, LoadRequestMethod.get]);
                          },
                          behavior: HitTestBehavior.opaque,
                          child: Text(
                            appText.termsPoliciesDesc,
                            style: style14Regular().copyWith(color: greyA5),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
      
                    ],
                  ),
                )
              )
            ],
          ),
        )
      ),
    );
  }




  socialWidget(String icon,Function onTap){
    return GestureDetector(
      onTap: (){
        onTap();
      },
      child: Container(
        width: 98,
        height: 52,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: borderRadius(radius: 16),
        ),

        child: SvgPicture.asset(icon,width: 30,),
      ),
    );
  }

}