import 'package:flutter/material.dart';
import 'package:webinar/config/colors.dart';

import '../../../../../common/components.dart';
import '../../../../../common/utils/app_text.dart';
import '../../../../../config/styles.dart';

class FAQPage extends StatelessWidget {
  final List<Map<String, String>> faqs = [
    {
      "title": appText.isAppFreeTitle,
      "description": appText.isAppFreeDescription,
    },
    {
      "title": appText.howToDownloadTitle,
      "description": appText.howToDownloadDescription,
    },
    {
      "title": appText.howToCreateAccountTitle,
      "description": appText.howToCreateAccountDescription,
    },
    {
      "title": appText.selfPacedLearningTitle,
      "description": appText.selfPacedLearningDescription,
    },
    {
      "title": appText.supportIfQuestionsTitle,
      "description": appText.supportIfQuestionsDescription,
    },
    {
      "title": appText.useAppOfflineTitle,
      "description": appText.useAppOfflineDescription,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appbar(title: appText.faqs),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Search TextField
            // TextField(
            //   decoration: InputDecoration(
            //     prefixIcon: Icon(Icons.search, color: Colors.grey),
            //     hintText: "Search",
            //     filled: true,
            //     fillColor: Colors.grey[200],
            //     border: OutlineInputBorder(
            //       borderRadius: BorderRadius.circular(10.0),
            //       borderSide: BorderSide.none,
            //     ),
            //     contentPadding: EdgeInsets.symmetric(vertical: 14.0),
            //   ),
            // ),
            // SizedBox(height: 16.0),

            // FAQ List
            Expanded(
              child: ListView.builder(
                physics: BouncingScrollPhysics(),
                itemCount: faqs.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Container(

                      decoration: BoxDecoration(
                        color: green77().withOpacity(0.06),
                        borderRadius: BorderRadius.circular(
                            15),
                      

                        // Rounded corners
                      ),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(15),
                        // Ink effect for rounded corners
                        onTap: () {
                          // Handle card tap
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Leading icon
                              // Container(
                              //   padding: EdgeInsets.all(10),
                              //   decoration: BoxDecoration(
                              //     color: green77().withOpacity(0.1),
                              //     shape: BoxShape.circle,
                              //   ),
                              //   child: Icon(
                              //     Icons.help_outline,
                              //     color: green77(),
                              //   ),
                              // ),
                              //SizedBox(width: 16.0),
                              // Title and description
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      faqs[index]["title"]!,
                                      style: style14Bold().copyWith(height: 1.3),
                                    ),
                                    SizedBox(height: 8.0),
                                    Text(
                                      faqs[index]["description"]!,
                                      style: style12Regular().copyWith(color: greyA5),
                                    ),
                                  ],
                                ),
                              ),
                              // Trailing arrow icon
                              Icon(Icons.arrow_forward, size: 16,
                                  color: green77()),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
