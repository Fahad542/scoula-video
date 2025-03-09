import 'package:flutter/material.dart';
import 'package:webinar/app/models/course_model.dart';
import 'package:webinar/app/pages/main_page/home_page/search_page/result_search_page.dart';
import 'package:webinar/app/services/guest_service/course_service.dart';
import 'package:webinar/common/components.dart';
import 'package:webinar/common/common.dart';
import 'package:webinar/common/utils/app_text.dart';
import 'package:webinar/config/colors.dart';
import 'package:webinar/config/styles.dart';
import '../../../../../config/assets.dart';
import '../../../../../locator.dart';
import '../../../../models/category_model.dart';
import '../../../../models/filter_model.dart';
import '../../../../providers/filter_course_provider.dart';
import '../../../../services/guest_service/categories_service.dart';
import '../../categories_page/filter_category_page/dynamiclly_filter.dart';

class SuggestedSearchPage extends StatefulWidget {
  static const String pageName = '/suggested-search-page';
  const SuggestedSearchPage({super.key});

  @override
  State<SuggestedSearchPage> createState() => SuggestedSearchPageState();
}

class SuggestedSearchPageState extends State<SuggestedSearchPage> {


  TextEditingController searchController = TextEditingController();
  FocusNode searchNode = FocusNode();
  List<FilterModel> filters = [];
  bool isShowButton = false;
  List<CourseModel> data = [];

  List<CourseModel> suggestedData = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();

      searchController.addListener(() {
        if (searchController.text
            .trim()
            .isNotEmpty) {
          if (!isShowButton) {
            setState(() {
              isShowButton = true;
            });
          }
        } else {
          if (isShowButton) {
            setState(() {
              isShowButton = false;
            });
          }
        }
      });
    getData();


  }


  getData() async {
    setState(() {
      isLoading = true;
    });
    
    suggestedData = await CourseService.getAll( offset: 0 );
    for (int i =0; i<suggestedData.length; i++ )
    {
      print("id :${suggestedData[i].id}");
    }
    suggestedData.shuffle();
    setState( ( ) {
      isLoading = false;
    });
  }
  getFilters() async {
    // print("category: ${suggestedData.first}");
    // if(suggestedData.first != null){
    //   filters = await CategoriesService.getFilters(suggestedData.first!);
    //
    //   locator<FilterCourseProvider>().filters = filters;
    //
    //   setState(() {});
    // }
  }
  @override
  Widget build(BuildContext context) {
    return directionality(
      child: Scaffold(
        appBar: appbar(title: appText.search),

        body: Stack(
          children: [
            

            // course
            Positioned.fill(
              child: SingleChildScrollView(
                padding: padding(),
                physics: const BouncingScrollPhysics(),

                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    space(20),

                    input(searchController, searchNode, appText.searchInputDesc,iconPathLeft: AppAssets.searchSvg),
                     space(20),
                    // button(
                    //       onTap: () async {
                    //
                    //         if(filters.isNotEmpty)
                    //         {
                    //           var res = await baseBottomSheet(
                    //               child: const DynamicllyFilter()
                    //           );
                    //
                    //           if(res != null && res){
                    //             data.clear();
                    //             getData();
                    //           }
                    //         }
                    //
                    //       },
                    //       width: getSize().width,
                    //       height: 48,
                    //       text: appText.filters,
                    //       bgColor: Colors.transparent,
                    //       textColor: filters.isEmpty ? green77().withOpacity(.35) : green77(),
                    //       borderColor: filters.isEmpty ? green77().withOpacity(.35) : green77(),
                    //       iconColor: filters.isEmpty ? green77().withOpacity(.35) : green77(),
                    //       iconPath: AppAssets.filterSvg,
                    //       raduis: 15
                    //   ),

                    Text(
                      appText.suggestedRandom,
                      style: style20Bold(),
                    ),


                    space(20),

                    if(isLoading)...{
                      loading()
                    }else...{
                    
                      ...List.generate( suggestedData.length, (index) {
                        return courseItemVertically(suggestedData[index]);
                      })
                    }

                  ],
                ),
                
              ),
            ),


            AnimatedPositioned(
              duration: const Duration(milliseconds: 300),
              bottom: isShowButton ? 0 : -150,
              child: Container(

                width: getSize().width,
                padding: const EdgeInsets.only(
                  left: 20,
                  right: 20,
                  top: 20,
                  bottom: 30
                ),

                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    boxShadow(Colors.black.withOpacity(.1),blur: 15,y: -3)
                  ],
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(30))
                ),
                child: button(
                  onTap: ( )
                  {
                    nextRoute(ResultSearchPage.pageName, arguments: searchController.text.trim());
                  }, 
                  width: getSize().width, 
                  height: 52, 
                  text: appText.search, 
                  bgColor: green77(), 
                  textColor: Colors.white
                ),
              )
            )


          ],
        ),
      )
    );
  }

}