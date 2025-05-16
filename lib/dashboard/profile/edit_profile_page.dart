import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:stream24news/utils/componants/sizedbox.dart';

import '../../auth/auth_service.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  int? selectedIndex;

  Future<void> updateUserProfile({
    required String displayName,
    required String photoUrl,
  }) async {
    try {
      User? user = AuthService().getUser();

      if (user != null) {
        if (_nameController.text.isNotEmpty) {
          await user.updateDisplayName(displayName);
        }
        if (_emailController.text.isNotEmpty) {
          await user.updatePhotoURL(photoUrl);
        }

        await user.reload();
      } else {
        throw Exception("No user is currently signed in.");
      }
    } catch (e) {
      rethrow;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Profile'),
        centerTitle: true,
        backgroundColor: theme.colorScheme.primary,
        foregroundColor: theme.colorScheme.onPrimary,
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
        children: [
          Center(
            child: GestureDetector(
              onTap: _openAvatarSelector,
              child: CircleAvatar(
                radius: 50,
                backgroundColor: selectedIndex != null
                    ? Colors.primaries[selectedIndex! % Colors.primaries.length]
                        .shade200
                    : theme.colorScheme.primaryContainer,
                child: selectedIndex != null
                    ? ClipOval(
                        child: CachedNetworkImage(
                          imageUrl:
                              'https://api.dicebear.com/7.x/adventurer/png?seed=$selectedIndex',
                          width: 80,
                          height: 80,
                          fit: BoxFit.cover,
                          placeholder: (_, __) =>
                              const CircularProgressIndicator(),
                          errorWidget: (_, __, ___) => Icon(
                            Icons.person,
                            size: 40,
                            color: theme.colorScheme.onPrimaryContainer,
                          ),
                        ),
                      )
                    : Icon(
                        Icons.person,
                        size: 40,
                        color: theme.colorScheme.onPrimaryContainer,
                      ),
              ),
            ),
          ),
          sizedBoxH30(context),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text("Please enter name"), sizedBoxH20(context),

              _buildTextField(
                controller: _nameController,
                label: 'Full Name',
                icon: Icons.person_outline,
                keyboardType: TextInputType.name,
              ),
              sizedBoxH20(context),
              // _buildTextField(
              //   controller: _emailController,
              //   label: 'Email (not allowed)',
              //   icon: Icons.email_outlined,
              //   keyboardType: TextInputType.emailAddress,
              // ),
              // sizedBoxH20(context),
              // _buildTextField(
              //   controller: _phoneController,
              //   label: 'Phone Number',
              //   icon: Icons.phone_outlined,
              //   keyboardType: TextInputType.phone,
              // ),
              sizedBoxH30(context),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () async {
                    await updateUserProfile(
                      displayName: _nameController.text.trim(),
                      photoUrl:
                          'https://api.dicebear.com/7.x/adventurer/png?seed=$selectedIndex',
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    backgroundColor: theme.colorScheme.primary,
                  ),
                  child: Text(
                    'Save Changes',
                    style: theme.textTheme.labelLarge?.copyWith(
                      color: theme.colorScheme.onPrimary,
                    ),
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  void _openAvatarSelector() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Theme.of(context).colorScheme.surfaceContainer,
      isScrollControlled: true,
      builder: (context) => SizedBox(
        height: MediaQuery.of(context).size.height * 0.6,
        child: GridView.builder(
          padding: const EdgeInsets.all(16),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 5,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
          ),
          itemCount: 50,
          itemBuilder: (context, index) {
            final imageUrl =
                'https://api.dicebear.com/7.x/adventurer/png?seed=$index';

            return GestureDetector(
              onTap: () {
                setState(() => selectedIndex = index);
                Navigator.pop(context);
              },
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: selectedIndex == index
                        ? Colors.green
                        : Colors.transparent,
                    width: 2,
                  ),
                ),
                child: CircleAvatar(
                  backgroundColor: Colors
                      .primaries[index % Colors.primaries.length].shade200,
                  child: ClipOval(
                    child: CachedNetworkImage(
                      imageUrl: imageUrl,
                      width: 40,
                      height: 40,
                      fit: BoxFit.cover,
                      placeholder: (_, __) =>
                          const CircularProgressIndicator(strokeWidth: 1.5),
                      errorWidget: (_, __, ___) => const Icon(Icons.error),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    required TextInputType keyboardType,
  }) {
    final theme = Theme.of(context);
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      validator: (value) => value == null || value.isEmpty ? 'Required' : null,
      decoration: InputDecoration(
        prefixIcon: Icon(icon, color: theme.colorScheme.primary),
        labelText: label,
        labelStyle: theme.textTheme.bodyMedium,
        filled: true,
        fillColor: theme.colorScheme.surfaceContainer,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }
}
