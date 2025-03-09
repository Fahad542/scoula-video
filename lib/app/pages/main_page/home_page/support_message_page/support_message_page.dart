import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hive/hive.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webinar/app/pages/main_page/home_page/support_message_page/faq.dart';
import 'package:webinar/app/providers/user_provider.dart';
import 'package:webinar/app/services/user_service/support_service.dart';
import 'package:webinar/common/common.dart';
import 'package:webinar/common/components.dart';
import 'package:webinar/common/utils/app_text.dart';
import 'package:webinar/locator.dart';
import '../../../../../common/badges.dart';
import '../../../../../config/assets.dart';
import '../../../../../config/colors.dart';
import '../../../../../config/styles.dart';
import '../../../../models/support_model.dart';
import 'Support_ticket.dart';


class SupportMessagePage extends StatefulWidget {
  static const String pageName = '/support-message';
  const SupportMessagePage({super.key});

  @override
  State<SupportMessagePage> createState() => _SupportMessagePageState();
}

class _SupportMessagePageState extends State<SupportMessagePage> with TickerProviderStateMixin{

  late TabController tabController;

  bool isLoadingTickets = false;
  List<SupportModel> ticketsData = [];

  bool isLoadingClasses = false;
  List<SupportModel> classSupportData = [];
  
  bool isLoadingMyClasss = false;
  List<SupportModel> myClassSupportData = [];

  int currentTab = 0;
  final String email = 'feedback@scuolavideo.com';
  final String subject = 'Support Request';
  final String body = 'Hello, I need help with...';
  final String phoneNumber = '+393277764333'; // Add the phone number with the country code.

  Future<void> launchWhatsApp() async {
    final Uri whatsappUri = Uri.parse("https://wa.me/$phoneNumber");

    if (await canLaunchUrl(whatsappUri)) {
      await launchUrl(whatsappUri, mode: LaunchMode.externalApplication);
    } else {
      print("Could not open WhatsApp.");
    }
  }


  launchEmail() async {
    launchUrl(Uri.parse("mailto:${email}?subject=${subject}&body=${body}"));
    // final url = 'mailto:feedback@scuolavideo.com?subject=Support+Query&body=Hello%2C+I+need+support+with...';
    // if (await canLaunch(url)) {
    //   await launch(url);
    // } else {
    //   throw 'Could not launch $url';
    // }
  }

  // Function to show an error dialog if the email client can't be launched
  _showErrorDialog() {
    print("No email client found or could not open email client.");
    // You can show a dialog or snackbar to inform the user
  }


  @override
  void initState() {
    super.initState();

    if(locator<UserProvider>().profile?.roleName != 'user'){
      tabController = TabController(length: 3, vsync: this);
    }else{
      tabController = TabController(length: 2, vsync: this);
    }

    tabController.addListener(() { 
      setState(() {
        currentTab = tabController.index;
      });
    });

    getData();

  }


  getData(){
    
    isLoadingTickets = true;
    isLoadingClasses = true;

    SupportService.getTickets().then((value) {
      ticketsData = value;
      isLoadingTickets = false;

      setState(() {});
    });

    SupportService.getClassSupport().then((value) {
      classSupportData = value;
      isLoadingClasses = false;

      setState(() {});
    });

    if(locator<UserProvider>().profile?.roleName != 'user'){
      isLoadingMyClasss = true;
      
      SupportService.getMyClassSupport().then((value) {
        myClassSupportData = value;
        isLoadingMyClasss = false;

        setState(() {});
      });
    }
  }



  @override
  Widget build(BuildContext context) {
    return directionality(
      child: Scaffold(

        appBar: appbar(title: appText.support),

        body:

        Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 0),
              child:
               Image.asset(AppAssets.customer, height: 200,width: 400,) // Replace with your image path
              ),



        SizedBox(height: 20),
        // Subtitle Section
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Text(
            appText.supheading,
             style: style16Bold().copyWith(height: 1.3),
            textAlign: TextAlign.center,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40.0, vertical: 10.0),
          child: Text(
              appText.suptext,
            style: style12Regular().copyWith(color: greyA5),
            textAlign: TextAlign.center,
          ),
        ),
        SizedBox(height: 20),
        // Options Section
        SupportOption(

          title: appText.customersupport,
          description: appText.customersupporttext, onTap: () {

          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => SupportTicket()),
          );

          // launchWhatsApp();
        }, svgPath:AppAssets.supportticket,
        ),

            SupportOption(

          title: appText.email,
          description: appText.emailtext, onTap: () async {
await launchEmail();
        }, svgPath: AppAssets.email,
        ),
            SupportOption(

              title: appText.whatsapp,
              description: appText.whatupdetail, onTap: () async {
              await launchWhatsApp();
            }, svgPath: AppAssets.whatsupp,
            ),



          ],
        ),



      ));


  }}





class SupportOption extends StatelessWidget {
  final String svgPath; // Change the icon parameter to svgPath
  final String title;
  final String description;
  final VoidCallback onTap; // Accept onTap as a parameter

  const SupportOption({
    required this.svgPath,
    required this.title,
    required this.description,
    required this.onTap, // Mark onTap as required
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        child: ListTile(
          leading: Container(
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: green77().withOpacity(0.2),
            ),
            child: SvgPicture.asset(
              svgPath, // Use the passed svgPath for the SVG image
              color: green77(), // You can add color if needed
              width: 24, // Adjust the size as needed
              height: 24, // Adjust the size as needed
            ),
          ),
          title: Text(
            title,
            style: style14Bold().copyWith(height: 1.3),
          ),
          subtitle: Text(
            description,
            style: style12Regular().copyWith(color: greyA5),
          ),
          onTap: onTap, // Use the passed onTap function
        ),
      ),
    );
  }
}
