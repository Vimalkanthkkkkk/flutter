import 'package:flutter/material.dart';

class CategoryPage extends StatefulWidget {
  const CategoryPage({super.key});

  @override
  State<CategoryPage> createState() => Category();
}

class Category extends State<CategoryPage> {

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        shape: BoxBorder.fromLTRB(
          bottom: BorderSide(
            width: 0.21,
            color: const Color.fromARGB(255, 76, 75, 75),
          ),
        ),
        backgroundColor: Color.fromARGB(255, 25, 24, 24),
        elevation: 0,
        leading: Builder(
          builder: (context) => IconButton(
            icon: Icon(
              IconData(
                0xf63a,
                fontFamily: 'MaterialIcons',
                matchTextDirection: true,
              ),
              size: 30,
            ),
            onPressed: () =>     Navigator.pop(context),
            color: Color.fromARGB(255, 225, 26, 66),
          ),
        ),
        title: Text(
          "Categories",
          textAlign: TextAlign.start,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: Color.fromARGB(255, 255, 255, 255),
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(
              IconData(0xf026e, fontFamily: 'MaterialIcons'),
              size: 30,
            ),
            onPressed: () => {},
            color: Color.fromARGB(255, 95, 94, 94),
          ),
          IconButton(
            icon: const Icon(
              IconData(0xf815, fontFamily: 'MaterialIcons'),
              size: 30,
            ),
            onPressed: () => {},
            color: Color.fromARGB(255, 95, 94, 94),
          ),
        ],
      ),
      backgroundColor: Color.fromARGB(255, 25, 24, 24),
      body: Padding(
        padding: EdgeInsets.all(8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 20),
            Text(
              'Custom categories ',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            Text(
              '5 available ',
              style: TextStyle(
                color: const Color.fromARGB(255, 103, 101, 101),
                fontSize: 14,
                fontWeight: FontWeight.w700,
              ),
            ),
            SizedBox(height: 10),
            Center(
              child: Icon(
                IconData(0xf4c7, fontFamily: 'MaterialIcons'),
                size: 38,
                color: const Color.fromARGB(255, 103, 101, 101),
              ),
            ),
            Center(
              child: Text(
                'There are no custom categories',
                style: TextStyle(
                  color: const Color.fromARGB(255, 103, 101, 101),
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            SizedBox(height: 60),
            Divider(
              height: 0.20,
              thickness: 1,
              color: Color.fromARGB(255, 67, 67, 67),
            ),
            SizedBox(height: 12),
            Text(
              'Default categories',
              style: TextStyle(
                color: const Color.fromARGB(255, 255, 255, 255),
                fontSize: 16,
                fontWeight: FontWeight.w700,
              ),
            ),
            Text(
              'Editable for premium users',
              style: TextStyle(
                color: const Color.fromARGB(255, 103, 101, 101),
                fontSize: 14,
                fontWeight: FontWeight.w700,
              ),
            ),
            SizedBox(height: 20),
            SizedBox(
              height: 108,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  CategoryCard(
                    title: 'Quit a bad habit',
                    entries: 0,
                    iconData: IconData(0xf6c6, fontFamily: 'MaterialIcons'),
                    iconColor: Color.fromARGB(255, 247, 1, 1),
                    onTap: () {},
                  ),
                  CategoryCard(
                    title: 'Art',
                    entries: 5,
                    iconData: IconData(0xf5ef, fontFamily: 'MaterialIcons'),
                    iconColor: Color.fromARGB(255, 217, 22, 22),
                    onTap: () {},
                  ),
                  CategoryCard(
                    title: 'Task',
                    entries: 5,
                    iconData: IconData(0xf51a, fontFamily: 'MaterialIcons'),
                    iconColor: Color.fromARGB(255, 241, 29, 96),
                    onTap: () {},
                  ),
                  CategoryCard(
                    title: 'Meditation',
                    entries: 12,
                    iconData: IconData(0xf0144, fontFamily: 'MaterialIcons'),
                    iconColor: Color.fromARGB(255, 241, 8, 179),
                    onTap: () {},
                  ),
                  CategoryCard(
                    title: 'Study',
                    entries: 8,
                    iconData: IconData(0xf012e, fontFamily: 'MaterialIcons'),
                    iconColor: Color.fromARGB(255, 161, 7, 232),
                    onTap: () {},
                  ),
                  CategoryCard(
                    title: 'Sports',
                    entries: 3,
                    iconData: IconData(0xe1d2, fontFamily: 'MaterialIcons'),
                    iconColor: Color.fromARGB(255, 76, 175, 80),
                    onTap: () {},
                  ),

                  //----------------------------------------------------------------------
                  CategoryCard(
                    title: 'Entertainment',
                    entries: 3,
                    iconData: IconData(0xf862, fontFamily: 'MaterialIcons'),
                    iconColor: Color.fromARGB(255, 27, 172, 180),
                    onTap: () {},
                  ),
                  CategoryCard(
                    title: 'Social',
                    entries: 3,
                    iconData: IconData(0xf631, fontFamily: 'MaterialIcons'),
                    iconColor: Color.fromARGB(255, 2, 185, 133),
                    onTap: () {},
                  ),
                  CategoryCard(
                    title: 'Finance',
                    entries: 3,
                    iconData: IconData(0xf58f, fontFamily: 'MaterialIcons'),
                    iconColor: Color.fromARGB(255, 3, 188, 86),
                    onTap: () {},
                  ),
                  CategoryCard(
                    title: 'Health',
                    entries: 3,
                    iconData: IconData(0xf0f2, fontFamily: 'MaterialIcons'),
                    iconColor: Color.fromARGB(255, 2, 179, 19),
                    onTap: () {},
                  ),
                  CategoryCard(
                    title: 'Work',
                    entries: 3,
                    iconData: IconData(0xf7f4, fontFamily: 'MaterialIcons'),
                    iconColor: Color.fromARGB(255, 76, 160, 2),
                    onTap: () {},
                  ),
                  CategoryCard(
                    title: 'Nutrition',
                    entries: 3,
                    iconData: IconData(0xf869, fontFamily: 'MaterialIcons'),
                    iconColor: Color.fromARGB(255, 230, 124, 12),
                    onTap: () {},
                  ),
                  CategoryCard(
                    title: 'Home',
                    entries: 3,
                    iconData: IconData(0xe319, fontFamily: 'MaterialIcons'),
                    iconColor: Color.fromARGB(255, 234, 149, 4),
                    onTap: () {},
                  ),
                  CategoryCard(
                    title: 'Outdoor',
                    entries: 3,
                    iconData: IconData(0xf83e, fontFamily: 'MaterialIcons'),
                    iconColor: Color.fromARGB(255, 218, 89, 14),
                    onTap: () {},
                  ),
                  CategoryCard(
                    title: 'Other',
                    entries: 3,
                    iconData: IconData(0xf02b9, fontFamily: 'MaterialIcons'),
                    iconColor: Color.fromARGB(255, 229, 52, 8),
                    onTap: () {},
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            Divider(
              height: 0.20,
              thickness: 1,
              color: Color.fromARGB(255, 67, 67, 67),
            ),
            SizedBox(height: 300),
            TextButton(
              onPressed: (){
                
              },
              style: TextButton.styleFrom(
                backgroundColor: Color.fromARGB(255, 225, 26, 66),
                fixedSize: Size(400, 60),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadiusGeometry.all(Radius.circular(14)),
                ),
              ),
              child: Text(
                "New Category",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CategoryCard extends StatelessWidget {
  const CategoryCard({
    super.key,
    required this.title,
    required this.entries,
    required this.iconData,
    required this.iconColor,
    required this.onTap,
  });

  final String title;
  final int entries;
  final IconData iconData;
  final Color iconColor;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 75,
      height: 90,
      margin: EdgeInsets.only(right: 0),
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Color.fromARGB(0, 44, 42, 42),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Color.fromARGB(0, 67, 67, 67), width: 1),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            height: 50,
            width: 50,
            decoration: BoxDecoration(
              color: iconColor,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              iconData,
              size: 40,
              color: const Color.fromARGB(255, 34, 32, 32),
            ),
          ),
          SizedBox(height: 6),
          Text(
            title,
            style: TextStyle(
              color: const Color.fromARGB(255, 255, 255, 255),
              fontSize: 12,
              fontWeight: FontWeight.bold,
              overflow: TextOverflow.ellipsis,
            ),
            maxLines: 1,
            textAlign: TextAlign.center,
          ),
          Text(
            '$entries entries',
            style: TextStyle(
              color: const Color.fromARGB(255, 144, 144, 144),
              fontSize: 11,
              fontWeight: FontWeight.w600,
              overflow: TextOverflow.ellipsis,
            ),
            maxLines: 1,
          ),
        ],
      ),
    );
  }
}
