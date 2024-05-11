import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:m_life_app/util/post_category.dart';
import 'package:m_life_app/view/pages/post/category/freeboard_page.dart';
import '../../components/buildBottomNavigationBar.dart';
import '../../components/buildFloatingActionButton.dart';
import '../../components/ad_banner.dart';
import '../../components/category_emogi.dart';
import '../../components/custom_header_navi.dart';
import 'category/complaint_discussion_page.dart';
import 'category/construction_method_page.dart';
import 'category/daily_proof_page.dart';
import 'category/equipment_recommendation_page.dart';
import 'category/graduation_review_page.dart';
import 'category/restaurant_page.dart';
import 'category/site_debate_dispute_page.dart';
import 'category/union_related_page.dart';

class CategoryPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'M-Life',
      ),
      body: ListView.builder(
        itemCount: Category.values.length + 2, // 구분선을 위해 itemCount 수정
        itemBuilder: (context, index) {
          if (index == 0) {
            return Container(
              height: 70,
              margin: EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Colors.amber[200],
                borderRadius: BorderRadius.circular(16.0),
              ),
              child: AdBanner(
                imagePaths: [
                  'assets/ad1.png',
                  'assets/ad2.png',
                  'assets/ad3.png',
                  'assets/ad4.png',
                ],
              ),
            );
          } else if (index == 1) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 1),
              child: Divider(
                color: Colors.grey[400],
                thickness: 1.0,
              ),
            );
          }

          final categoryIndex = index - 2; // 구분선을 고려하여 인덱스 조정
          final category = Category.values[categoryIndex];

          return InkWell(
            onTap: () {
              switch (category) {
                case Category.free:
                  Get.to(() => FreePage(category: Category.free));
                  break;
                case Category.dailyProof:
                  Get.to(() => DailyProofPage(category: Category.dailyProof));
                  break;
                case Category.constructionMethod:
                  Get.to(() => ConstructionMethodPage(
                      category: Category.constructionMethod));
                  break;
                case Category.graduationReview:
                  Get.to(() => GraduationReviewPage(
                      category: Category.graduationReview));
                  break;
                case Category.complaintDiscussion:
                  Get.to(() => ComplaintDiscussionPage(
                      category: Category.complaintDiscussion));
                  break;
                case Category.siteDebateDispute:
                  Get.to(() => SiteDebateDisputePage(
                        category: Category.siteDebateDispute,
                      ));
                  break;
                case Category.unionRelated:
                  Get.to(() => UnionRelatedPage(
                        category: Category.unionRelated,
                      ));
                  break;
                case Category.equipmentRecommendation:
                  Get.to(() => EquipmentRecommendationPage(
                        category: Category.equipmentRecommendation,
                      ));
                  break;
                case Category.restaurant:
                  Get.to(() => RestaurantPage(
                        category: Category.restaurant,
                      ));
                  break;
              }
            },
            child: Container(
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: categoryIndex % 2 == 0 ? Colors.white : Colors.grey[100],
                border: Border(
                  bottom: BorderSide(
                    color: Colors.grey[300]!,
                    width: 1.0,
                  ),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        getCategoryEmoji(category),
                        style: TextStyle(
                          fontSize: 32,
                        ),
                      ),
                      SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              category.name,
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                            SizedBox(height: 8),
                            Text(
                              category.description,
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.grey[700],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: buildFloatingActionButton(),
      bottomNavigationBar: buildBottomNavigationBar(),
    );
  }
}
