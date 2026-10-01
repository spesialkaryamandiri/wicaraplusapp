import 'package:flutter/material.dart';

class TherapyItem {
  final String title;
  final String imagePath;
  final String videoPath;
  final bool isFree; // Marks if available without premium/trial

  TherapyItem({
    required this.title,
    required this.imagePath,
    required this.videoPath,
    this.isFree = false,
  });
}

class TherapyCategory {
  final String name;
  final IconData icon;
  final Color color;
  final String iconPath; // Or IconData
  final List<TherapyItem> items;

  TherapyCategory({
    required this.name,
    required this.items,
    this.icon = Icons.record_voice_over,
    this.color = Colors.blue,
    this.iconPath = 'assets/image/Logo_WICARAplus_trans.png',
  });
}

final List<TherapyCategory> speechTherapyData = [
  TherapyCategory(
    name: "Huruf Vokal",
    icon: Icons.record_voice_over,
    color: Colors.blue,
    items: [
      TherapyItem(
        title: "A",
        imagePath: "assets/image/Vokal_A.png",
        videoPath: "assets/video/Vokal_A.mp4",
        isFree: true,
      ),
      TherapyItem(
        title: "I",
        imagePath: "assets/image/Vokal_I.jpg",
        videoPath: "assets/video/Vokal_I.mp4",
        isFree: true,
      ),
      TherapyItem(
        title: "U",
        imagePath: "assets/image/Vokal_U.jpg",
        videoPath: "assets/video/Vokal_U.mp4",
        isFree: true,
      ),
      TherapyItem(
        title: "E",
        imagePath: "assets/image/Vokal_E.png",
        videoPath: "assets/video/Vokal_E.mp4",
        isFree: false,
      ),TherapyItem(
        title: "O",
        imagePath: "assets/image/Vokal_O.png",
        videoPath: "assets/video/Vokal_O.mp4",
        isFree: true,
      ),
    ],
  ),
  TherapyCategory(
    name: "Huruf Konsonan",
    icon: Icons.sort_by_alpha,
    color: Colors.deepPurple,
    items: [
      TherapyItem(
        title: "B",
        imagePath: "assets/image/Kons_B.png",
        videoPath: "assets/video/Kons_B.mp4",
        isFree: true,
      ),
      TherapyItem(
        title: "C",
        imagePath: "assets/image/Kons_C.png",
        videoPath: "assets/video/Kons_C.mp4",
        isFree: true,
      ),
      TherapyItem(
        title: "D",
        imagePath: "assets/image/Kons_D.jpg",
        videoPath: "assets/video/Kons_D.mp4",
        isFree: false,
      ),
      TherapyItem(
        title: "F",
        imagePath: "assets/image/Kons_F.png",
        videoPath: "assets/video/Kons_F.mp4",
        isFree: false,
      ),
      TherapyItem(
        title: "G",
        imagePath: "assets/image/Kons_G.png",
        videoPath: "assets/video/Kons_G.mp4",
        isFree: false,
      ),
      TherapyItem(
        title: "H",
        imagePath: "assets/image/Kons_H.jpg",
        videoPath: "assets/video/Kons_H.mp4",
        isFree: false,
      ),
      TherapyItem(
        title: "J",
        imagePath: "assets/image/Kons_J.png",
        videoPath: "assets/video/Kons_J.mp4",
        isFree: false,
      ),
      TherapyItem(
        title: "K",
        imagePath: "assets/image/Kons_K.jpg",
        videoPath: "assets/video/Kons_K.mp4",
        isFree: false,
      ),
      TherapyItem(
        title: "L",
        imagePath: "assets/image/Kons_L.jpg",
        videoPath: "assets/video/Kons_L.mp4",
        isFree: false,
      ),
      TherapyItem(
        title: "M",
        imagePath: "assets/image/Kons_M.jpg",
        videoPath: "assets/video/Kons_M.mp4",
        isFree: false,
      ),
      TherapyItem(
        title: "N",
        imagePath: "assets/image/Kons_N.jpg",
        videoPath: "assets/video/Kons_N.mp4",
        isFree: false,
      ),
      TherapyItem(
        title: "P",
        imagePath: "assets/image/Kons_P.jpg",
        videoPath: "assets/video/Kons_P.mp4",
        isFree: false,
      ),
      TherapyItem(
        title: "Q",
        imagePath: "assets/image/Kons_Q.jpg",
        videoPath: "assets/video/Kons_Q.mp4",
        isFree: false,
      ),
      TherapyItem(
        title: "R",
        imagePath: "assets/image/Kons_R.jpg",
        videoPath: "assets/video/Kons_R.mp4",
        isFree: false,
      ),
      TherapyItem(
        title: "S",
        imagePath: "assets/image/Kons_S.jpg",
        videoPath: "assets/video/Kons_S.mp4",
        isFree: false,
      ),
      TherapyItem(
        title: "T",
        imagePath: "assets/image/Kons_T.jpg",
        videoPath: "assets/video/Kons_T.mp4",
        isFree: false,
      ),
      TherapyItem(
        title: "V",
        imagePath: "assets/image/Kons_V.jpg",
        videoPath: "assets/video/Kons_V.mp4",
        isFree: false,
      ),
      TherapyItem(
        title: "W",
        imagePath: "assets/image/Kons_W.png",
        videoPath: "assets/video/Kons_W.mp4",
        isFree: false,
      ),
      TherapyItem(
        title: "X",
        imagePath: "assets/image/Kons_X.jpg",
        videoPath: "assets/video/Kons_X.mp4",
        isFree: false,
      ),
      TherapyItem(
        title: "Y",
        imagePath: "assets/image/Kons_Y.png",
        videoPath: "assets/video/Kons_Y.mp4",
        isFree: false,
      ),
      TherapyItem(
        title: "Z",
        imagePath: "assets/image/Kons_Z.jpg",
        videoPath: "assets/video/Kons_Z.mp4",
        isFree: false,
      ),
    ],
  ),
  TherapyCategory(
    name: "Suku Kata",
    icon: Icons.segment,
    color: Colors.teal,
    items: [
      TherapyItem(
        title: "Ba",
        imagePath: "assets/image/SukuKata_Ba.jpg",
        videoPath: "assets/video/SukuKata_Ba.mp4",
        isFree: true,
      ),
      TherapyItem(
        title: "Bi",
        imagePath: "assets/image/SukuKata_Bi.png",
        videoPath: "assets/video/SukuKata_Bi.mp4",
        isFree: true,
      ),
      TherapyItem(
        title: "Bu",
        imagePath: "assets/image/SukuKata_Bu.png",
        videoPath: "assets/video/SukuKata_Bu.mp4",
        isFree: true,
      ),
      TherapyItem(
        title: "Be",
        imagePath: "assets/image/SukuKata_Be.jpg",
        videoPath: "assets/video/SukuKata_Be.mp4",
        isFree: true,
      ),
      TherapyItem(
        title: "Bo",
        imagePath: "assets/image/SukuKata_Bo.png",
        videoPath: "assets/video/SukuKata_Bo.mp4",
        isFree: true,
      ),
      TherapyItem(
        title: "Ca",
        imagePath: "assets/image/SukuKata_Ca.jpg",
        videoPath: "assets/video/SukuKata_Ca.mp4",
        isFree: true,
      ),
      TherapyItem(
        title: "Ci",
        imagePath: "assets/image/SukuKata_Ci.png",
        videoPath: "assets/video/SukuKata_Ci.mp4",
        isFree: true,
      ),
      TherapyItem(
        title: "Cu",
        imagePath: "assets/image/SukuKata_Cu.png",
        videoPath: "assets/video/SukuKata_Cu.mp4",
        isFree: true,
      ),
      TherapyItem(
        title: "Ce",
        imagePath: "assets/image/SukuKata_Ce.png",
        videoPath: "assets/video/SukuKata_Ce.mp4",
        isFree: true,
      ),
      TherapyItem(
        title: "Co",
        imagePath: "assets/image/SukuKata_Co.png",
        videoPath: "assets/video/SukuKata_Co.mp4",
        isFree: true,
      ),
      TherapyItem(
        title: "Da",
        imagePath: "assets/image/SukuKata_Da.jpg",
        videoPath: "assets/video/SukuKata_Da.mp4",
        isFree: false,
      ),
      TherapyItem(
        title: "Di",
        imagePath: "assets/image/SukuKata_Di.jpg",
        videoPath: "assets/video/SukuKata_Di.mp4",
        isFree: false,
      ),
      TherapyItem(
        title: "Du",
        imagePath: "assets/image/SukuKata_Du.png",
        videoPath: "assets/video/SukuKata_Du.mp4",
        isFree: false,
      ),
      TherapyItem(
        title: "De",
        imagePath: "assets/image/SukuKata_De.jpg",
        videoPath: "assets/video/SukuKata_De.mp4",
        isFree: false,
      ),
      TherapyItem(
        title: "Do",
        imagePath: "assets/image/SukuKata_Do.png",
        videoPath: "assets/video/SukuKata_Do.mp4",
        isFree: false,
      ),
    ],
  ),
  TherapyCategory(
    name: "Kata Dasar",
    icon: Icons.menu_book,
    color: Colors.orange,
    items: [
      TherapyItem(
        title: "Mama",
        imagePath: "assets/image/Kata_Mama.jpg",
        videoPath: "assets/video/Kata_Mama.mp4",
        isFree: true,
      ),
      TherapyItem(
        title: "Papa",
        imagePath: "assets/image/Kata_Papa.jpg",
        videoPath: "assets/video/Kata_Papa.mp4",
        isFree: true,
      ),
    ],
  ),
  TherapyCategory(
    name: "Kata Benda",
    icon: Icons.category,
    color: Colors.indigo,
    items: [
      TherapyItem(
        title: "Meja",
        imagePath: "assets/image/Kata_Mama.jpg",
        videoPath: "assets/video/Kata_Mama.mp4",
        isFree: true,
      ),
      TherapyItem(
        title: "Kursi",
        imagePath: "assets/image/Kata_Papa.jpg",
        videoPath: "assets/video/Kata_Papa.mp4",
        isFree: true,
      ),
      TherapyItem(
        title: "Buku",
        imagePath: "assets/image/Kata_Papa.jpg",
        videoPath: "assets/video/Kata_Papa.mp4",
        isFree: true,
      ),
      TherapyItem(
        title: "Rumah",
        imagePath: "assets/image/Kata_Papa.jpg",
        videoPath: "assets/video/Kata_Papa.mp4",
        isFree: true,
      ),
      TherapyItem(
        title: "Sepatu",
        imagePath: "assets/image/Kata_Papa.jpg",
        videoPath: "assets/video/Kata_Papa.mp4",
        isFree: true,
      ),
    ],
  ),
  TherapyCategory(
    name: "Kata Kerja",
    icon: Icons.directions_run,
    color: Colors.green,
    items: [
      TherapyItem(
        title: "Makan",
        imagePath: "assets/image/Kata_Mama.jpg",
        videoPath: "assets/video/Kata_Mama.mp4",
        isFree: true,
      ),
      TherapyItem(
        title: "Minum",
        imagePath: "assets/image/Kata_Papa.jpg",
        videoPath: "assets/video/Kata_Papa.mp4",
        isFree: true,
      ),
      TherapyItem(
        title: "Duduk",
        imagePath: "assets/image/Kata_Papa.jpg",
        videoPath: "assets/video/Kata_Papa.mp4",
        isFree: true,
      ),
      TherapyItem(
        title: "Bangun",
        imagePath: "assets/image/Kata_Papa.jpg",
        videoPath: "assets/video/Kata_Papa.mp4",
        isFree: true,
      ),
      TherapyItem(
        title: "Berdiri",
        imagePath: "assets/image/Kata_Papa.jpg",
        videoPath: "assets/video/Kata_Papa.mp4",
        isFree: true,
      ),
      TherapyItem(
        title: "Jalan",
        imagePath: "assets/image/Kata_Papa.jpg",
        videoPath: "assets/video/Kata_Papa.mp4",
        isFree: true,
      ),
      TherapyItem(
        title: "Mandi",
        imagePath: "assets/image/Kata_Papa.jpg",
        videoPath: "assets/video/Kata_Papa.mp4",
        isFree: true,
      ),
    ],
  ),
  TherapyCategory(
    name: "Kata Sifat",
    icon: Icons.sentiment_satisfied_alt,
    color: Colors.amber,
    items: [
      TherapyItem(
        title: "Senang",
        imagePath: "assets/image/Kata_Mama.jpg",
        videoPath: "assets/video/Kata_Mama.mp4",
        isFree: true,
      ),
      TherapyItem(
        title: "Sedih",
        imagePath: "assets/image/Kata_Papa.jpg",
        videoPath: "assets/video/Kata_Papa.mp4",
        isFree: true,
      ),
      TherapyItem(
        title: "Rajin",
        imagePath: "assets/image/Kata_Papa.jpg",
        videoPath: "assets/video/Kata_Papa.mp4",
        isFree: true,
      ),
      TherapyItem(
        title: "Pintar",
        imagePath: "assets/image/Kata_Papa.jpg",
        videoPath: "assets/video/Kata_Papa.mp4",
        isFree: true,
      ),
      TherapyItem(
        title: "Besar",
        imagePath: "assets/image/Kata_Papa.jpg",
        videoPath: "assets/video/Kata_Papa.mp4",
        isFree: true,
      ),
      TherapyItem(
        title: "Kecil",
        imagePath: "assets/image/Kata_Papa.jpg",
        videoPath: "assets/video/Kata_Papa.mp4",
        isFree: true,
      ),
      TherapyItem(
        title: "Tinggi",
        imagePath: "assets/image/Kata_Papa.jpg",
        videoPath: "assets/video/Kata_Papa.mp4",
        isFree: true,
      ),
      TherapyItem(
        title: "Pendek",
        imagePath: "assets/image/Kata_Papa.jpg",
        videoPath: "assets/video/Kata_Papa.mp4",
        isFree: true,
      ),
    ],
  ),
  TherapyCategory(
    name: "Kata Ganti",
    icon: Icons.people_alt,
    color: Colors.cyan,
    items: [
      TherapyItem(
        title: "Mama",
        imagePath: "assets/image/Kata_Mama.jpg",
        videoPath: "assets/video/Kata_Mama.mp4",
        isFree: true,
      ),
      TherapyItem(
        title: "Papa",
        imagePath: "assets/image/Kata_Papa.jpg",
        videoPath: "assets/video/Kata_Papa.mp4",
        isFree: true,
      ),
    ],
  ),
  TherapyCategory(
    name: "Kata Keterangan",
    icon: Icons.info_outline,
    color: Colors.pink,
    items: [
      TherapyItem(
        title: "Supaya",
        imagePath: "assets/image/Kata_Mama.jpg",
        videoPath: "assets/video/Kata_Mama.mp4",
        isFree: true,
      ),
      TherapyItem(
        title: "Lebih",
        imagePath: "assets/image/Kata_Papa.jpg",
        videoPath: "assets/video/Kata_Papa.mp4",
        isFree: true,
      ),
    ],
  ),
  TherapyCategory(
    name: "Bilangan",
    icon: Icons.format_list_numbered,
    color: Colors.deepOrange,
    items: [
      TherapyItem(
        title: "Satu",
        imagePath: "assets/image/Kata_Mama.jpg",
        videoPath: "assets/video/Kata_Mama.mp4",
        isFree: true,
      ),
      TherapyItem(
        title: "Dua",
        imagePath: "assets/image/Kata_Papa.jpg",
        videoPath: "assets/video/Kata_Papa.mp4",
        isFree: true,
      ),
      TherapyItem(
        title: "Tiga",
        imagePath: "assets/image/Kata_Mama.jpg",
        videoPath: "assets/video/Kata_Mama.mp4",
        isFree: true,
      ),
      TherapyItem(
        title: "Empat",
        imagePath: "assets/image/Kata_Papa.jpg",
        videoPath: "assets/video/Kata_Papa.mp4",
        isFree: true,
      ),
      TherapyItem(
        title: "Lima",
        imagePath: "assets/image/Kata_Mama.jpg",
        videoPath: "assets/video/Kata_Mama.mp4",
        isFree: true,
      ),
      TherapyItem(
        title: "Enam",
        imagePath: "assets/image/Kata_Papa.jpg",
        videoPath: "assets/video/Kata_Papa.mp4",
        isFree: true,
      ),
      TherapyItem(
        title: "Tujuh",
        imagePath: "assets/image/Kata_Mama.jpg",
        videoPath: "assets/video/Kata_Mama.mp4",
        isFree: true,
      ),
      TherapyItem(
        title: "Delapan",
        imagePath: "assets/image/Kata_Papa.jpg",
        videoPath: "assets/video/Kata_Papa.mp4",
        isFree: true,
      ),
      TherapyItem(
        title: "Sembilan",
        imagePath: "assets/image/Kata_Mama.jpg",
        videoPath: "assets/video/Kata_Mama.mp4",
        isFree: true,
      ),
      TherapyItem(
        title: "Sepuluh",
        imagePath: "assets/image/Kata_Papa.jpg",
        videoPath: "assets/video/Kata_Papa.mp4",
        isFree: true,
      ),
    ],
  ),
];
