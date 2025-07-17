import 'package:flutter/material.dart';

class CreateSupportTicket extends StatefulWidget {
  const CreateSupportTicket({super.key});

  @override
  State<CreateSupportTicket> createState() => _CreateSupportTicketState();
}

class _CreateSupportTicketState extends State<CreateSupportTicket> {
  final TextEditingController subjectController = TextEditingController();
  final TextEditingController bodyController = TextEditingController();

  String selectedDepartment = 'Support';
  String selectedPriority = 'Low';

  final departments = ['Support', 'Billing', 'Sales'];
  final priorities = ['Low', 'Medium', 'High'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black87, // Dark background for contrast
      body: Center(
        child: Container(
          width: 350,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            // Semi-transparent white for subtle background
            color: Colors.white.withOpacity(0.15),
            borderRadius: BorderRadius.circular(16),
          ),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                // Title & Close
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Create Ticket',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white, // White text for visibility
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close, color: Colors.white),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Subject
                const Text('Subject', style: TextStyle(color: Colors.white)),
                const SizedBox(height: 6),
                TextField(
                  controller: subjectController,
                  style: const TextStyle(color: Colors.white),
                  decoration: _inputDecoration('Enter your subject'),
                ),
                const SizedBox(height: 16),

                // Department & Priority
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Department', style: TextStyle(color: Colors.white)),
                          const SizedBox(height: 6),
                          DropdownButtonFormField<String>(
                            dropdownColor: Colors.black87,
                            value: selectedDepartment,
                            items: departments
                                .map((dep) => DropdownMenuItem(
                              value: dep,
                              child: Text(dep, style: const TextStyle(color: Colors.white)),
                            ))
                                .toList(),
                            onChanged: (val) {
                              setState(() {
                                selectedDepartment = val!;
                              });
                            },
                            decoration: _inputDecoration(null),
                            style: const TextStyle(color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Priority', style: TextStyle(color: Colors.white)),
                          const SizedBox(height: 6),
                          DropdownButtonFormField<String>(
                            dropdownColor: Colors.black87,
                            value: selectedPriority,
                            items: priorities
                                .map((prio) => DropdownMenuItem(
                              value: prio,
                              child: Text(prio, style: const TextStyle(color: Colors.white)),
                            ))
                                .toList(),
                            onChanged: (val) {
                              setState(() {
                                selectedPriority = val!;
                              });
                            },
                            decoration: _inputDecoration(null),
                            style: const TextStyle(color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Ticket Body
                const Text('Ticket Body', style: TextStyle(color: Colors.white)),
                const SizedBox(height: 6),
                TextField(
                  controller: bodyController,
                  maxLines: 3,
                  style: const TextStyle(color: Colors.white),
                  decoration: _inputDecoration('Describe your issue'),
                ),
                const SizedBox(height: 24),

                // Create Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      // Submit logic here
                      Navigator.of(context).pop(); // Close for now
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text('Create'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  InputDecoration _inputDecoration(String? hint) {
    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(color: Colors.white54),
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
