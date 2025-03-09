import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:webinar/app/services/user_service/terms_services.dart';
import 'package:webinar/common/common.dart';


import '../../../../../common/components.dart';
import '../../../../../common/utils/app_text.dart';
import '../../../../../config/styles.dart';
import '../../../../models/terms_and_conditions_model.dart';

class Terms_and_condiiton extends StatefulWidget {
  static const String pageNam = '/terms_and_conditions';
  //const Terms_and_condiiton({super.key});

  @override
  State<Terms_and_condiiton> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<Terms_and_condiiton> {

  List<PrivacyData> data = [];
  bool isloading =false;
  @override
  void initState() {
    getdata();
    super.initState();
  }
  void getdata() async {
setState(() {
  isloading =true;
});
    data = await TermService.get_terms_and_conditions();
setState(() {
  isloading =false;
});
    print(data);
  }
  @override
  Widget build(BuildContext context) {
    return directionality(
        child: Scaffold(
            appBar: appbar(title: appText.terms),

          body:
             isloading
            ?
         loading()
        :
          ListView.builder(
              itemCount: data.length,
              physics: BouncingScrollPhysics(),
              itemBuilder: (BuildContext context, index) {
                var datalist = data[index];
                return
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: Html(data: datalist.privacyData,
                    )
                  );
              })
              ));
  }
}