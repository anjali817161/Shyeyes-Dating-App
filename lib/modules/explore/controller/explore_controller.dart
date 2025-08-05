import 'package:get/get.dart';

class Category {
  final String title;
  final String image;
  final String count;
  final int colorCode;

  Category({
    required this.title,
    required this.image,
    required this.count,
    required this.colorCode,
  });
}

class ExploreController extends GetxController {
  var categories = <Category>[
    Category(
      title: "New friends",
      image: "https://cdn-icons-png.flaticon.com/512/565/565654.png",
      count: "7K",
      colorCode: 0xFFFF5A5F,
    ),
    Category(
      title: "Long-term partner",
      image: "https://cdn-icons-png.flaticon.com/512/726/726476.png",
      count: "30K",
      colorCode: 0xFFB960F3,
    ),
    Category(
      title: "Serious Daters",
      image: "https://cdn-icons-png.flaticon.com/512/3003/3003984.png",
      count: "19K",
      colorCode: 0xFFFF7A59,
    ),
    Category(
      title: "Foodies",
      image: "https://cdn-icons-png.flaticon.com/512/1046/1046784.png",
      count: "",
      colorCode: 0xFF56C596,
    ),
    Category(
      title: "Nature Lovers",
      image: "https://cdn-icons-png.flaticon.com/512/2913/2913465.png",
      count: "",
      colorCode: 0xFF54BAB9,
    ),
    Category(
      title: "Music Lovers",
      image: "https://cdn-icons-png.flaticon.com/512/727/727245.png",
      count: "16K",
      colorCode: 0xFF9D76C1,
    ),
    Category(
      title: "Self Care",
      image: "https://cdn-icons-png.flaticon.com/512/3315/3315946.png",
      count: "11K",
      colorCode: 0xFF7EAA92,
    ),
    Category(
      title: "Gamers",
      image: "https://cdn-icons-png.flaticon.com/512/1162/1162499.png",
      count: "5K",
      colorCode: 0xFF4E4FEB,
    ),
    Category(
      title: "Animal Parents",
      image: "https://cdn-icons-png.flaticon.com/512/616/616408.png",
      count: "790",
      colorCode: 0xFFDB6400,
    ),
    Category(
      title: "Free Tonight",
      image: "https://cdn-icons-png.flaticon.com/512/3515/3515431.png",
      count: "40K",
      colorCode: 0xFFFE7A36,
    ),
    Category(
      title: "Short-term fun",
      image: "https://cdn-icons-png.flaticon.com/512/2550/2550203.png",
      count: "22K",
      colorCode: 0xFF00A8E8,
    ),
    Category(
      title: "Non-monogamous",
      image: "https://cdn-icons-png.flaticon.com/512/3502/3502631.png",
      count: "19K",
      colorCode: 0xFF03C988,
    ),
    Category(
      title: "Get Photo Verified",
      image: "https://cdn-icons-png.flaticon.com/512/833/833472.png",
      count: "29K",
      colorCode: 0xFF03C988,
    ),
  ].obs;
}
