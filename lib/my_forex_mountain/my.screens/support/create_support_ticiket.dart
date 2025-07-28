import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../my.model/my_support_model.dart';
import '../../my.provider/my_dashboard_provider.dart';

class CreateSupportTicket extends StatefulWidget {
  const CreateSupportTicket({super.key, required this.departments});
  final List<Department> departments;
  @override
  State<CreateSupportTicket> createState() => _CreateSupportTicketState();
}

class _CreateSupportTicketState extends State<CreateSupportTicket> {
  final TextEditingController subjectController = TextEditingController();
  final TextEditingController bodyController = TextEditingController();

  Department? selectedDepartment;
  bool _userEditedSubject = false;

  @override
  void initState() {
    super.initState();
    if (widget.departments.isNotEmpty) {
      selectedDepartment = widget.departments.first;
    }
    bodyController.addListener(_autoGenerateSubjectFromBody);
    subjectController.addListener(() {
      _userEditedSubject = true;
    });
  }


  void _autoGenerateSubjectFromBody() {
    if (_userEditedSubject) return; // Don't auto-generate if user typed subject

    final text = bodyController.text.trim();

    if (text.isNotEmpty) {
      final words = text.split(RegExp(r'\s+'));
      final generatedSubject = words.take(6).join(' ') + (words.length > 6 ? '...' : '');
      subjectController.text = generatedSubject;
    } else {
      subjectController.text = '';
    }
  }

  @override
  void dispose() {
    bodyController.removeListener(_autoGenerateSubjectFromBody);
    subjectController.dispose();
    bodyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(20),
        topRight: Radius.circular(20),
      ),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.4),
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
            border: Border.all(color: Colors.white24),
          ),
          child: DraggableScrollableSheet(
            expand: false,
            initialChildSize: 0.7,
            maxChildSize: 0.7,
            minChildSize: 0.7,
            builder: (context, scrollController) {
              return SingleChildScrollView(
                controller: scrollController,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Describe Your Problem',
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.white)),
                        IconButton(
                          icon: const Icon(Icons.close, color: Colors.white),
                          onPressed: () => Navigator.of(context).pop(),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    _buildLabel('Subject'),
                    _buildTextField(subjectController, 'Enter your subject'),
                    const SizedBox(height: 22),
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildLabel('Department'),
                              DropdownButtonFormField<Department>(
                                value: selectedDepartment,
                                dropdownColor: Colors.black87,
                                style: const TextStyle(color: Colors.white),
                                decoration: _inputDecoration('Select Department'),
                                items: widget.departments.map((dept) {
                                  return DropdownMenuItem<Department>(
                                    value: dept,
                                    child: Text(
                                      dept.name ?? '',
                                      style: const TextStyle(color: Colors.white),
                                    ),
                                  );
                                }).toList(),
                                onChanged: (value) {
                                  setState(() {
                                    selectedDepartment = value;
                                  });
                                },
                              )


                            ],
                          ),
                        ),
                        // const SizedBox(width: 22),
                        // Expanded(
                        //   child: Column(
                        //     crossAxisAlignment: CrossAxisAlignment.start,
                        //     children: [
                        //       _buildLabel('Priority'),
                        //       _buildDropdown(
                        //         priorities,
                        //         selectedPriority,
                        //             (val) => setState(() {
                        //           selectedPriority = val!;
                        //         }),
                        //       ),
                        //     ],
                        //   ),
                        // ),
                      ],
                    ),
                    const SizedBox(height: 22),
                    _buildLabel('Describe your issue'),
                    _buildTextField(bodyController, 'Please describe your issue in detail...',
                        maxLines: 5),
                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(

                          onPressed: () async {
                            if (subjectController.text.isEmpty || bodyController.text.isEmpty || selectedDepartment == null) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Please fill in all fields')),
                              );
                              return;
                            }

                            final provider = Provider.of<MyDashboardProvider>(context, listen: false);

                            final success = await provider.createSupportTicket(
                              context: context,
                              subject: subjectController.text,
                              departmentId: selectedDepartment!.departmentId.toString(), // make sure ID is not null
                              message: bodyController.text,
                            );

                            if (success) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Ticket created successfully')),
                              );
                              Navigator.of(context).pop(); // Close the modal
                            }},


                        label: const Text("Create"),
                        icon: const Icon(Icons.send),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white.withOpacity(0.2),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                            side: const BorderSide(color: Colors.amber),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(text,
          style: const TextStyle(fontSize: 16, color: Colors.white,fontWeight: FontWeight.w600)),
    );
  }

  Widget _buildTextField(TextEditingController controller, String hint,
      {int maxLines = 1}) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      style: const TextStyle(color: Colors.white),
      decoration: _inputDecoration(hint),
    );
  }
  InputDecoration _inputDecoration(String? hint) {
    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(color: Colors.white54),
      filled: true,
      fillColor: Colors.white.withOpacity(0.05),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: Colors.white54),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: Colors.white),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
    );
  }
}
