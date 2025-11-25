import 'package:flutter/material.dart';
import '../model/bai_viet_model.dart';
import '../repository/bai_viet_repository.dart';
import '../widgets/news_item_card.dart';


/// MÀN HÌNH RIÊNG – dùng trong bottom nav
class NewsScreen extends StatelessWidget {
  const NewsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F8F8),
      body: SafeArea(
        child: const NewsSectionCore(), // phần thân dùng chung
      ),
    );
  }
}

/// SECTION NHÚNG VÀO HOME – chiều cao cố định, nội dung cuộn được
class NewsEmbeddedSection extends StatelessWidget {
  final double height;

  const NewsEmbeddedSection({super.key, this.height = 500});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: const NewsSectionCore(), // dùng chung body
    );
  }
}

class NewsHomeHeader extends StatelessWidget {
  const NewsHomeHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    double scale(double v) => v * width / 430;

    return Container(
      width: scale(398),
      height: scale(28),
      alignment: Alignment.centerLeft,
      child: Text(
        "Tin tức mới nhất",
        style: TextStyle(
          fontFamily: "SF Pro",
          fontWeight: FontWeight.w600, // Semibold ~ 590
          fontSize: scale(18),
          height: 28 / 18,
          color: const Color(0xFF4F4F4F),
        ),
      ),
    );
  }
}

/// PHẦN THÂN DÙNG CHUNG (stateful)
class NewsSectionCore extends StatefulWidget {
  const NewsSectionCore({super.key});

  @override
  State<NewsSectionCore> createState() => _NewsSectionCoreState();
}

class _NewsSectionCoreState extends State<NewsSectionCore> {
  int selectedIndex = 0;
  final List<String> tabs = ["Mega Story", "Hỏi đáp", "Hướng dẫn"];

  late Future<List<BaiVietModel>> futureMegaStory;
  late Future<List<BaiVietModel>> futureFAQ;
  late Future<List<BaiVietModel>> futureTutorial;

  late final BaiVietRepository _baiVietRepository;

  @override
  void initState() {
    super.initState();
    _baiVietRepository = BaiVietRepository();

    futureMegaStory = _baiVietRepository.getMegaStory(page: 0, size: 100);
    futureFAQ = _baiVietRepository.getHoiDap(page:0, size: 100);
    futureTutorial = _baiVietRepository.getHuongDan(page: 0, size: 100);
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    double scale(double v) => v * width / 430;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const SizedBox(height: 12),

        // ---------------- SEGMENT CONTROL ----------------
        Center(
          child: Container(
            width: scale(406),
            height: 48,
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: const Color(0xFFE6E6E6),
              borderRadius: BorderRadius.circular(256),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: List.generate(tabs.length, (index) {
                final bool isSelected = selectedIndex == index;
                return GestureDetector(
                  onTap: () => setState(() => selectedIndex = index),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    width: scale(122),
                    height: 40,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(256),
                      color: isSelected
                          ? const Color(0xFF17D066)
                          : Colors.transparent,
                      boxShadow: isSelected
                          ? const [
                              BoxShadow(
                                color: Color(0x3317D066),
                                blurRadius: 6,
                                spreadRadius: 1,
                                offset: Offset(0, 2),
                              ),
                            ]
                          : [],
                    ),
                    child: Center(
                      child: Text(
                        tabs[index],
                        style: TextStyle(
                          fontFamily: 'SF Pro',
                          fontWeight: isSelected
                              ? FontWeight.w500
                              : FontWeight.w400,
                          fontSize: 16,
                          height: 1.5,
                          color: isSelected
                              ? Colors.white
                              : const Color(0xFF848484),
                        ),
                      ),
                    ),
                  ),
                );
              }),
            ),
          ),
        ),

        const SizedBox(height: 16),

        // ---------------- NỘI DUNG TAB ----------------
        Expanded(
          child: IndexedStack(
            index: selectedIndex,
            children: [
              // 🟩 Tab 0: Mega Story (API)
              FutureBuilder<List<BaiVietModel>>(
                future: futureMegaStory,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.hasError) {
                    return Center(
                      child: Text(
                        'Lỗi tải Mega Story: ${snapshot.error}',
                        style: const TextStyle(color: Colors.red),
                      ),
                    );
                  }

                  final megaStories = snapshot.data ?? [];
                  if (megaStories.isEmpty) {
                    return const Center(
                      child: Text('Không có Mega Story hiện tại'),
                    );
                  }

                  return ListView.separated(
                    padding: EdgeInsets.symmetric(horizontal: scale(16)),
                    itemCount: megaStories.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 17),
                    itemBuilder: (context, index) {
                      return NewsCardCard(news: megaStories[index]);
                    },
                  );
                },
              ),

              // 🟦 Tab 1: Hỏi đáp (JSON)
               FutureBuilder<List<BaiVietModel>>(
                future: futureFAQ,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.hasError) {
                    return Center(
                      child: Text(
                        'Lỗi tải hỏi đáp: ${snapshot.error}',
                        style: const TextStyle(color: Colors.red),
                      ),
                    );
                  }

                  final tutorialList = snapshot.data ?? [];
                  if (tutorialList.isEmpty) {
                    return const Center(
                      child: Text('Không có hỏi đáp nào hiện tại'),
                    );
                  }

                  return ListView.separated(
                    padding: EdgeInsets.symmetric(horizontal: scale(16)),
                    itemCount: tutorialList.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 17),
                    itemBuilder: (context, index) {
                      return NewsCardCard(news: tutorialList[index]);
                    },
                  );
                },
              ),
              // FutureBuilder<List<FAQModel>>(
              //   future: futureFAQ,
              //   builder: (context, snapshot) {
              //     if (snapshot.connectionState == ConnectionState.waiting) {
              //       return const Center(child: CircularProgressIndicator());
              //     }
              //     if (snapshot.hasError) {
              //       return Center(
              //         child: Text(
              //           'Lỗi tải FAQ: ${snapshot.error}',
              //           style: const TextStyle(color: Colors.red),
              //         ),
              //       );
              //     }

              //     final faqList = snapshot.data ?? [];
              //     if (faqList.isEmpty) {
              //       return const Center(
              //         child: Text('Không có câu hỏi nào hiện tại'),
              //       );
              //     }

              //     return ListView.builder(
              //       padding: EdgeInsets.symmetric(horizontal: scale(16)),
              //       itemCount: faqList.length,
              //       itemBuilder: (context, index) {
              //         final faq = faqList[index];
              //         return FAQItem(title: faq.title, content: faq.content);
              //       },
              //     );
              //   },
              // ),

              // 🟨 Tab 2: Hướng dẫn (JSON)
              FutureBuilder<List<BaiVietModel>>(
                future: futureTutorial,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.hasError) {
                    return Center(
                      child: Text(
                        'Lỗi tải hướng dẫn: ${snapshot.error}',
                        style: const TextStyle(color: Colors.red),
                      ),
                    );
                  }

                  final tutorialList = snapshot.data ?? [];
                  if (tutorialList.isEmpty) {
                    return const Center(
                      child: Text('Không có hướng dẫn nào hiện tại'),
                    );
                  }

                  return ListView.separated(
                    padding: EdgeInsets.symmetric(horizontal: scale(16)),
                    itemCount: tutorialList.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 17),
                    itemBuilder: (context, index) {
                      return NewsCardCard(news: tutorialList[index]);
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}
