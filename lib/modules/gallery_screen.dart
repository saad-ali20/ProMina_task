import 'dart:ui';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:my_gallery/modules/login_screen.dart';
import 'package:my_gallery/models/user_model.dart';
import 'package:my_gallery/shared/services.dart';

class GalleryScreen extends StatefulWidget {
  final UserModel? user;

  const GalleryScreen({super.key, this.user});

  @override
  State<GalleryScreen> createState() => _GalleryScreenState();
}

class _GalleryScreenState extends State<GalleryScreen> {
  bool wantToUpload = false;
  List<MultipartFile> images = [];
  List<String> networkImgs = [];
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      networkImgs = await NetworkServices().getImages();
      setState(() {});
    });
  }

  late double height;
  late double widht;
  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    widht = MediaQuery.of(context).size.width;
    return SafeArea(
      child: Scaffold(
        body: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/gallery_bg.png'),
              fit: BoxFit.fill,
            ),
          ),
          child: Column(
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      alignment: Alignment.centerLeft,
                      margin: const EdgeInsets.only(top: 25),
                      width: widht * 0.38,
                      child: Text(
                        'Welcome ${widget.user!.user.name}',
                        maxLines: 2,
                        style: const TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.w400,
                            color: Color(0xff4A4A4A),
                            height: 1.2),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: 5, bottom: 35),
                      child: const CircleAvatar(
                        radius: 27,
                        backgroundImage: AssetImage('assets/images/user.png'),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 49,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: widht * 0.1),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    InkWell(
                      onTap: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => LoginScreen()),
                        );
                      },
                      child: Container(
                        height: 35,
                        width: widht * 0.36,
                        margin: const EdgeInsets.only(top: 5, bottom: 15),
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16.0),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              height: 26,
                              width: 28,
                              decoration: BoxDecoration(
                                color: const Color(0xffC83B3B),
                                borderRadius: BorderRadius.circular(9.0),
                              ),
                              child: Center(
                                child:
                                    SvgPicture.asset('assets/icons/arrow.svg'),
                              ),
                            ),
                            const Text(
                              'Log out',
                              style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w400,
                                  color: Color(0xff4A4A4A),
                                  height: 1.2),
                            ),
                          ],
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        setState(() {
                          wantToUpload = !wantToUpload;
                        });
                      },
                      child: Container(
                        height: 39,
                        width: widht * 0.35,
                        margin: const EdgeInsets.only(top: 5, bottom: 15),
                        child: Image.asset('assets/images/upkiad.png'),
                      ),
                    ),
                  ],
                ),
              ),

              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Stack(
                    children: [
                      buildGridView(),
                      if (wantToUpload) uploadeImage()
                    ],
                  ),
                ),
              ),
              // Add more widgets to the Column here
            ],
          ),
        ),
      ),
    );
  }

  Widget uploadeImage() {
    return Padding(
      padding: EdgeInsets.only(
          left: widht * 0.06, right: widht * 0.06, top: height * 0.18),
      child: ClipRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
          child: Container(
            height: height * 0.3,
            padding: EdgeInsets.symmetric(horizontal: widht * 0.15),
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Colors.white.withOpacity(0.1),
                  spreadRadius: 3,
                  blurRadius: 7,
                  offset: const Offset(0,
                      3), // Change the offset to adjust the position of the inner shadow
                ),
              ],
              color: Colors.white.withOpacity(0.5),
              borderRadius: BorderRadius.circular(32.0),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                InkWell(
                  onTap: () async {
                    await _selectImage(context);
                    await NetworkServices().addImages();
                    networkImgs = await NetworkServices().getImages();
                    setState(() {});
                  },
                  child: Container(
                    height: 49,
                    width: widht * 0.5,
                    margin: const EdgeInsets.only(top: 5, bottom: 25),
                    child: Image.asset('assets/images/Group 12.png'),
                  ),
                ),
                InkWell(
                  onTap: () async {
                    await _openCamera(context);
                    await NetworkServices().addImages();
                    networkImgs = await NetworkServices().getImages();
                    setState(() {});
                  },
                  child: Container(
                    height: 49,
                    width: widht * 0.5,
                    margin: const EdgeInsets.only(top: 5, bottom: 10),
                    child: Image.asset('assets/images/Group 13.png'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildGridView() {
    return GridView.count(
      crossAxisCount: 3,
      mainAxisSpacing: 8,
      crossAxisSpacing: 8,
      children: List.generate(networkImgs.length, (index) {
        return Center(
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: InkWell(
                splashColor: Colors.blue.withAlpha(30),
                onTap: () {
                  // Handle the tap event
                },
                child: SizedBox(
                    width: 90,
                    height: 90,
                    child: FadeInImage(
                      fit: BoxFit.cover,
                      image: NetworkImage(networkImgs[index]),
                      placeholder: const AssetImage('assets/images/placeh.png'),
                      fadeInDuration: const Duration(milliseconds: 500),
                    )),
              ),
            ),
          ),
        );
      }),
    );
  }

  Future<void> _selectImage(BuildContext context) async {
    final ImagePicker imagePicker = ImagePicker();
    List<XFile>? imageFileList = [];
    final List<XFile> selectedImages = await imagePicker.pickMultiImage(
        maxWidth: 1080, maxHeight: 1920, imageQuality: 85);
    if (selectedImages.isNotEmpty) {
      imageFileList.addAll(selectedImages);
    }
    setState(() {});
    images.clear();
    for (int i = 0; i < imageFileList.length; i++) {
      String? fileName = imageFileList[i].path.split('/').last;
      images.add(await MultipartFile.fromFile(imageFileList[i].path,
          filename: fileName));
    }
    NetworkServices.globalimageFileList.addAll(images);
    images.clear();
    setState(() {
      wantToUpload = false;
    });
  }

  Future<void> _openCamera(BuildContext context) async {
    final ImagePicker imagePicker = ImagePicker();
    final XFile? selectedImages = await imagePicker.pickImage(
        source: ImageSource.camera,
        maxWidth: 1080,
        maxHeight: 1920,
        imageQuality: 85);
    if (selectedImages != null) {
      images.clear();
      String? fileName = selectedImages.path.split('/').last;
      images.add(await MultipartFile.fromFile(selectedImages.path,
          filename: fileName));
      NetworkServices.globalimageFileList.addAll(images);
      images.clear();
    }

    setState(() {
      wantToUpload = false;
    });
  }
}
