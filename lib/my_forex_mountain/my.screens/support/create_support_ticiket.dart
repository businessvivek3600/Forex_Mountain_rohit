import 'dart:ui';
import 'package:flutter/material.dart';

class CreateSupportTicket extends StatefulWidget {
  const CreateSupportTicket({super.key});

  @override
  State<CreateSupportTicket> createState() => _CreateSupportTicketState();
}

class _CreateSupportTicketState extends State<CreateSupportTicket> {
  final TextEditingController subjectController = TextEditingController();
  final TextEditingController bodyController = TextEditingController();

  final List<String> departments = ['Support', 'Billing', 'Sales'];
  final List<String> priorities = ['Low', 'Medium', 'High'];

  String selectedDepartment = 'Support';
  String selectedPriority = 'Low';

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
            initialChildSize: 0.55,
            maxChildSize: 0.9,
            minChildSize: 0.4,
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
                        const Text('Create Ticket',
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
                              _buildDropdown(
                                departments,
                                selectedDepartment,
                                    (val) => setState(() {
                                  selectedDepartment = val!;
                                }),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 22),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildLabel('Priority'),
                              _buildDropdown(
                                priorities,
                                selectedPriority,
                                    (val) => setState(() {
                                  selectedPriority = val!;
                                }),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 22),
                    _buildLabel('Ticket Body'),
                    _buildTextField(bodyController, 'Describe your issue',
                        maxLines: 3),
                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: () {
                          final ticket = {
                            'subject': subjectController.text,
                            'department': selectedDepartment,
                            'priority': selectedPriority,
                            'body': bodyController.text,
                          };
                          Navigator.of(context).pop(ticket);
                        },
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
    return Text(text,
        style: const TextStyle(fontSize: 14, color: Colors.white));
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

  Widget _buildDropdown(List<String> items, String selectedValue,
      ValueChanged<String?> onChanged) {
    return DropdownButtonFormField<String>(
      dropdownColor: Colors.black87,
      value: selectedValue,
      items: items
          .map((e) => DropdownMenuItem(
          value: e,
          child: Text(e, style: const TextStyle(color: Colors.white))))
          .toList(),
      onChanged: onChanged,
      decoration: _inputDecoration(null),
      style: const TextStyle(color: Colors.white),
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
