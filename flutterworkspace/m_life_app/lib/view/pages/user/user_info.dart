import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:m_life_app/controller/user_controller.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../util/getCareerText.dart';
import '../../../util/getExperienceValue.dart';
import '../../../util/showImageFullScreen.dart';
import '../../components/buildBottomNavigationBar.dart';
import '../../components/custom_header_navi.dart';

class UserInfo extends StatefulWidget {
  @override
  _ProfileSettingsPageState createState() => _ProfileSettingsPageState();
}

class _ProfileSettingsPageState extends State<UserInfo> {
  final UserController _userController = Get.find();
  TextEditingController _nameController = TextEditingController();
  TextEditingController _bioController = TextEditingController();
  String _selectedJob = '';
  String _selectedCareer = '';
  String _selectedPosition = '';
  File? _selectedImage;

  List<String> _jobOptions = [
    '철근공',
    '목수',
    '콘크리트공',
    '용접공',
    '설비공',
    '전기공',
    '기타',
  ];

  List<String> _careerOptions = [
    '0년',
    '1~2년 이하',
    '3~5년',
    '6년 이상',
  ];

  void _updatePosition() {
    setState(() {
      switch (_selectedCareer) {
        case '0년':
          _selectedPosition = '잡부';
          break;
        case '1~2년 이하':
          _selectedPosition = '기능공';
          break;
        case '3~5년':
          _selectedPosition = '기술자';
          break;
        case '6년 이상':
          _selectedPosition = '현장소장';
          break;
        default:
          _selectedPosition = '';
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _nameController.text = _userController.principal.value.nickname ?? '';
    _bioController.text = _userController.profile.value.introduction ?? '';
    _selectedJob = _userController.profile.value.jobName ?? '';
    _selectedCareer = getCareerText(_userController.profile.value.experience!);
    _updatePosition();
  }

  Future<void> _selectImage() async {
    final picker = ImagePicker();
    final pickedImage = await picker.pickImage(source: ImageSource.gallery);

    if (pickedImage != null) {
      File imageFile = File(pickedImage.path);
      int result = await _userController.updateProfileImage(
        _userController.principal.value.nickname!,
        imageFile,
      );

      if (result != -1) {
        setState(() {
          _selectedImage = imageFile;
        });
        print("프로필 이미지가 성공적으로 업로드되었습니다.");
      } else {
        print("프로필 이미지 업로드에 실패했습니다.");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'M-Life',
        onBackPressed: () => Get.back(),
      ),
      body: ListView(
        padding: EdgeInsets.all(16.0),
        children: [
          Column(
            children: [
              Text(
                '프로필 설정',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8),
              Text(
                '나중에 언제든지 변경할 수 있습니다',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[600],
                ),
              ),
              SizedBox(height: 24),
            ],
          ),
          Center(
            child: Stack(
              children: [
                GestureDetector(
                  onTap: () => showImageFullScreen(context),
                  child: Container(
                    width: 200,
                    height: 200,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.grey[200],
                    ),
                    child: _selectedImage != null
                        ? ClipOval(
                            child: Image.file(
                              _selectedImage!,
                              height: 200,
                              width: 200,
                              fit: BoxFit.cover,
                            ),
                          )
                        : _userController.profile.value.profileImageUrl != ""
                            ? ClipOval(
                                child: CachedNetworkImage(
                                  imageUrl: _userController
                                      .profile.value.profileImageUrl!,
                                  placeholder: (context, url) =>
                                      CircularProgressIndicator(),
                                  errorWidget: (context, url, error) =>
                                      Icon(Icons.person, size: 80),
                                  width: 200,
                                  height: 200,
                                  fit: BoxFit.cover,
                                ),
                              )
                            : Icon(Icons.person, size: 80),
                  ),
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.amber,
                    ),
                    child: IconButton(
                      icon: Icon(Icons.camera_alt),
                      color: Colors.white,
                      onPressed: _selectImage,
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 20),
          TextField(
            controller: _nameController,
            decoration: InputDecoration(
              labelText: '사용자 이름',
              labelStyle: TextStyle(color: Colors.black54),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0),
                borderSide: BorderSide(color: Colors.amber[300]!),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0),
                borderSide: BorderSide(color: Colors.amber[300]!),
              ),
            ),
          ),
          SizedBox(height: 16),
          TextField(
            controller: _bioController,
            maxLines: 1,
            decoration: InputDecoration(
              labelText: '한 줄 자기 소개',
              labelStyle: TextStyle(color: Colors.black54),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0),
                borderSide: BorderSide(color: Colors.amber[300]!),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0),
                borderSide: BorderSide(color: Colors.amber[300]!),
              ),
            ),
          ),
          SizedBox(height: 16),
          JobDropdown(
            selectedJob: _selectedJob,
            jobOptions: _jobOptions,
            onChanged: (value) {
              setState(() {
                _selectedJob = value!;
              });
            },
          ),
          SizedBox(height: 16),
          CareerDropdown(
            selectedCareer: _selectedCareer,
            careerOptions: _careerOptions,
            onChanged: (value) {
              setState(() {
                _selectedCareer = value!;
                _updatePosition();
              });
            },
          ),
          SizedBox(height: 16),
          TextFormField(
            controller: TextEditingController(text: _selectedPosition),
            enabled: false,
            decoration: InputDecoration(
              labelText: '직책',
              labelStyle: TextStyle(color: Colors.black54),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0),
                borderSide: BorderSide(color: Colors.amber[300]!),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0),
                borderSide: BorderSide(color: Colors.amber[300]!),
              ),
            ),
          ),
          SizedBox(height: 32),
          ElevatedButton(
            onPressed: () async {
              String experienceValue = getExperienceValue(_selectedCareer);
              int result = await _userController.updateProfile(
                _userController.principal.value.nickname!,
                _bioController.text,
                _selectedJob,
                experienceValue,
              );
              if (result != -1) {
                Get.snackbar("성공", "프로필 정보가 성공적으로 업데이트되었습니다.");
                _userController
                    .getProfile(_userController.principal.value.nickname!);
              } else {
                Get.snackbar("실패", "프로필 정보 업데이트에 실패했습니다.");
              }
            },
            style: ElevatedButton.styleFrom(
              foregroundColor: Colors.white,
              backgroundColor: Colors.amber[500],
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
              child: Text('저장하기', style: TextStyle(fontSize: 16)),
            ),
          ),
        ],
      ),
      bottomNavigationBar: buildBottomNavigationBar(),
    );
  }
}

class JobDropdown extends StatelessWidget {
  final String selectedJob;
  final List<String> jobOptions;
  final Function(String?) onChanged;

  JobDropdown({
    required this.selectedJob,
    required this.jobOptions,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField(
      value: selectedJob.isNotEmpty ? selectedJob : null,
      items: jobOptions.map((job) {
        return DropdownMenuItem(
          value: job,
          child: Text(job),
        );
      }).toList(),
      onChanged: onChanged,
      decoration: InputDecoration(
        labelText: '직업',
        labelStyle: TextStyle(color: Colors.black54),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: BorderSide(color: Colors.amber[300]!),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: BorderSide(color: Colors.amber[300]!),
        ),
      ),
    );
  }
}

class CareerDropdown extends StatelessWidget {
  final String selectedCareer;
  final List<String> careerOptions;
  final Function(String?) onChanged;

  CareerDropdown({
    required this.selectedCareer,
    required this.careerOptions,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField(
      value: selectedCareer.isNotEmpty ? selectedCareer : null,
      items: careerOptions.map((career) {
        return DropdownMenuItem(
          value: career,
          child: Text(career),
        );
      }).toList(),
      onChanged: onChanged,
      decoration: InputDecoration(
        labelText: '경력',
        labelStyle: TextStyle(color: Colors.black54),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: BorderSide(color: Colors.amber[300]!),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: BorderSide(color: Colors.amber[300]!),
        ),
      ),
    );
  }
}
