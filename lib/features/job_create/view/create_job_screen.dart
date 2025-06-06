import 'package:flutter/material.dart';

class CreateJobScreen extends StatefulWidget {
  const CreateJobScreen({super.key});

  @override
  State<CreateJobScreen> createState() => _CreateJobScreenState();
}

class _CreateJobScreenState extends State<CreateJobScreen> {
  final lightPurple = const Color(0xFFD1C4E9);

  String? selectedCategory;
  String? selectedWorkMode;
  String? selectedLocation;

  final OutlineInputBorder border = OutlineInputBorder(
    borderRadius: BorderRadius.circular(10),
    borderSide: const BorderSide(color: Color(0xFFD1C4E9)),
  );

  final List<String> categories = [
    'Office',
    'Accounting',
    'Sales',
    'Support',
    'Teaching',
    'IT',
    'Technical',
    'Driving',
    'Delivery',
    'Cleaning',
    'Security',
    'Healthcare',
    'Restaurant',
    'Construction',
    'Design',
  ];

  final List<String> workModes = ['Remote', 'Full-time', 'Part-time'];
  final List<String> locations = ['Yangon', 'Mandalay', 'Naypyitaw', 'All'];

  final _formKey = GlobalKey<FormState>();
  final Map<String, String> formData = {};
  final TextEditingController salaryController = TextEditingController();
  final TextEditingController requirementsController = TextEditingController();
  final TextEditingController responsibilitiesController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9F9FB),
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        elevation: 0.5,
        title: const Text(
          'Create A Job',
          style: TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 8,
                  offset: Offset(0, 2),
                )
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _sectionHeader('Basic Info'),
                _formRow('Job Title'),
                _formRow('Company Name'),
                _popupRow('Location', selectedLocation, locations, (value) {
                  setState(() => selectedLocation = value);
                }, isRequired: true),
                _formRow('Salary', hintText: '10000 - 20000 baht', controller: salaryController),
                _formRow('Job Type'),
                _popupRow('Work Mode', selectedWorkMode, workModes, (value) {
                  setState(() => selectedWorkMode = value);
                }, isRequired: true),

                const SizedBox(height: 24),
                _sectionHeader('Job Summary'),
                _formRow('Education'),
                _formRow('Working Days'),
                _formRow('Working Hours'),

                const SizedBox(height: 16),
                _label('Category'),
                const SizedBox(height: 8),
                _categoryDropdown(),

                const SizedBox(height: 24),
                _sectionHeader('Requirements'),
                _input(maxLines: 4, controller: requirementsController),

                const SizedBox(height: 24),
                _sectionHeader('Responsibilities'),
                _input(maxLines: 4, controller: responsibilitiesController),

                const SizedBox(height: 32),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        if (requirementsController.text.trim().isEmpty && responsibilitiesController.text.trim().isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Please fill either Requirements or Responsibilities')),
                          );
                          return;
                        }
                        // TODO: Handle form submission
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF0C1C6B),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      'Create Job',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                        color: Colors.white,
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _sectionHeader(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(
        text,
        style: const TextStyle(
          fontWeight: FontWeight.w700,
          fontSize: 16,
          color: Colors.black87,
        ),
      ),
    );
  }

  Widget _formRow(String labelText, {String? hintText, TextEditingController? controller}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _label(labelText),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          decoration: InputDecoration(
            hintText: hintText,
            filled: true,
            fillColor: Colors.white,
            border: border,
            enabledBorder: border,
            focusedBorder: border.copyWith(
              borderSide: BorderSide(color: lightPurple, width: 2),
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          ),
          validator: (value) => (value == null || value.trim().isEmpty) ? 'This field is required' : null,
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _label(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontWeight: FontWeight.w500,
        fontSize: 14,
        color: Colors.black87,
      ),
    );
  }

  Widget _input({int maxLines = 1, TextEditingController? controller}) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white,
        border: border,
        enabledBorder: border,
        focusedBorder: border.copyWith(
          borderSide: BorderSide(color: lightPurple, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      ),
    );
  }

  Widget _popupRow(String label, String? selected, List<String> options, ValueChanged<String> onSelected, {bool isRequired = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _label(label),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: () => _showPopupDialog(label, options, onSelected),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              border: Border.all(color: lightPurple),
              borderRadius: BorderRadius.circular(10),
              color: Colors.white,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(selected ?? 'Select $label'),
                const Icon(Icons.arrow_drop_down),
              ],
            ),
          ),
        ),
        if (isRequired && (selected == null || selected.isEmpty))
          const Padding(
            padding: EdgeInsets.only(top: 8.0),
            child: Text('This field is required', style: TextStyle(color: Colors.red, fontSize: 12)),
          ),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _categoryDropdown() {
    return GestureDetector(
      onTap: () => _showPopupDialog('Category', categories, (value) {
        setState(() => selectedCategory = value);
      }),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          border: Border.all(color: lightPurple),
          borderRadius: BorderRadius.circular(10),
          color: Colors.white,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(selectedCategory ?? 'Select Category'),
            const Icon(Icons.arrow_drop_down),
          ],
        ),
      ),
    );
  }

  void _showPopupDialog(
    String title,
    List<String> options,
    ValueChanged<String> onSelected,
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Select $title'),
        content: SizedBox(
          width: double.maxFinite,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: options.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(options[index]),
                onTap: () {
                  onSelected(options[index]);
                  Navigator.pop(context);
                },
              );
            },
          ),
        ),
      ),
    );
  }
}
