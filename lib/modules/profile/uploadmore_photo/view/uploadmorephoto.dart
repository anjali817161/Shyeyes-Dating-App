import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:shyeyes/modules/widgets/api_endpoints.dart';
import 'package:shyeyes/modules/widgets/sharedPrefHelper.dart';

// Your token helper

void showUploadPhotoBottomSheet(BuildContext context) {
  showModalBottomSheet(
    backgroundColor: Color(0xFFFFF3F3),
    context: context,
    isScrollControlled: true,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (context) {
      return UploadPhotoSheet();
    },
  );
}

class UploadPhotoSheet extends StatefulWidget {
  @override
  State<UploadPhotoSheet> createState() => _UploadPhotoSheetState();
}

class _UploadPhotoSheetState extends State<UploadPhotoSheet> {
  List<XFile?> selectedImages = List.generate(4, (index) => null);
  bool isLoading = false;

  final ImagePicker _picker = ImagePicker();

  Future<void> pickImage(int index) async {
    final XFile? image = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 70,
    );
    if (image != null) {
      setState(() {
        selectedImages[index] = image;
      });
    }
  }

  Future<void> uploadPhotos() async {
    setState(() {
      isLoading = true;
    });

    String token = await SharedPrefHelper.getToken() ?? '';
    try {
      // Prepare multipart request
      var request = http.MultipartRequest(
        'POST',
        Uri.parse(ApiEndpoints.baseUrl + ApiEndpoints.moreuploadphoto),
      );
      request.headers['Authorization'] = 'Bearer $token';
      request.headers['Accept'] = 'application/json';

      // Add images to request
      for (var img in selectedImages) {
        if (img != null) {
          request.files.add(
            await http.MultipartFile.fromPath('photos[]', img.path),
          );
        }
      }

      var response = await request.send();
      var respStr = await response.stream.bytesToString();
      var jsonResp = json.decode(respStr);

      if (response.statusCode == 200) {
        print('Photos uploaded: ${jsonResp['photos']}');
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Photos uploaded successfully')));
        Navigator.pop(context); // close sheet
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(jsonResp['message'] ?? 'Upload failed')),
        );
      }
    } catch (e) {
      print('Error uploading photos: $e');
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Something went wrong')));
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Center(
            child: Text(
              "Upload Photo",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: Color(0xFFDF314D),
              ),
            ),
          ),
          const SizedBox(height: 20),
          GridView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: 4,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 1.2,
            ),
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () => pickImage(index),
                child: DottedBorder(
                  options: RectDottedBorderOptions(
                    color: const Color.fromARGB(255, 226, 55, 69),
                    strokeWidth: 2,
                    dashPattern: [6, 3],
                  ),
                  child: Container(
                    height: 150, // 👈 fixed height for better layout
                    decoration: BoxDecoration(
                      color: Colors.pink.shade50,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Center(
                      child: selectedImages[index] != null
                          ? ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: Image.file(
                                File(selectedImages[index]!.path),
                                fit: BoxFit.cover,
                                width: double.infinity,
                                height: double.infinity,
                              ),
                            )
                          : Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: const [
                                Icon(
                                  Icons.cloud_upload_outlined, // 👈 Upload icon
                                  size: 40,
                                  color: Color(0xFFDF314D),
                                ),
                                SizedBox(height: 8),
                                Text(
                                  "Upload Image",
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Color(0xFFDF314D),
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                    ),
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFFDF314D),
                padding: EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onPressed: isLoading ? null : uploadPhotos,
              child: isLoading
                  ? CircularProgressIndicator(color: Colors.white)
                  : Text(
                      "Submit",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
