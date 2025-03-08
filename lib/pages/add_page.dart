import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:levlin/database/quest_database.dart';
import 'package:levlin/theme/theme_colors.dart';
import 'package:provider/provider.dart';

class AddPage extends StatefulWidget {
  const AddPage({super.key});

  @override
  State<AddPage> createState() => _AddPageState();
}

class _AddPageState extends State<AddPage> {
  final _formKey = GlobalKey<FormState>();
  String _dropdownValue = 'Repetitions';

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _goalController = TextEditingController();

  final List<String> _options = ['Repetitions', 'Distance', 'Duration'];

  @override
  Widget build(BuildContext context) {
    final QuestDatabase questDatabase = context.watch<QuestDatabase>();
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    // Content form fields
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        /*

                          Q U E S T    N A M E
                        
                        */
                        Text(
                          "Quest Name",
                          style: GoogleFonts.poppins(
                            color: context.onSurface,
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 10),
                        TextFormField(
                          controller: _nameController,
                          style: GoogleFonts.roboto(
                            color: context.onSurface,
                            fontSize: 16,
                          ),
                          decoration: InputDecoration(
                            hintText: "Push-Ups",
                            hintStyle: GoogleFonts.roboto(
                              color: context.primary,
                              fontSize: 16,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter some text';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 72),
                        /*

                          Q U E S T    T Y P E

                        */
                        Text(
                          "Quest Type",
                          style: GoogleFonts.poppins(
                            color: context.onSurface,
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 10),
                        DropdownButtonFormField<String>(
                          style: GoogleFonts.roboto(
                            color: context.onSurface,
                            fontSize: 16,
                          ),
                          value: _dropdownValue,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          onChanged: (String? newValue) {
                            setState(() {
                              _dropdownValue = newValue!;
                            });
                          },
                          items:
                              _options.map<DropdownMenuItem<String>>((
                                String value,
                              ) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
                        ),
                        const SizedBox(height: 72),
                        /*

                          Q U E S T    G O A L

                        */
                        Text(
                          "Quest Goal",
                          style: GoogleFonts.poppins(
                            color: context.onSurface,
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 10),
                        TextFormField(
                          controller: _goalController,
                          style: GoogleFonts.roboto(
                            color: context.onSurface,
                            fontSize: 16,
                          ),
                          decoration: InputDecoration(
                            hintText: "100",
                            hintStyle: GoogleFonts.roboto(
                              color: context.primary,
                              fontSize: 16,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          keyboardType: TextInputType.number,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter a number';
                            }
                            final int? number = int.tryParse(value);
                            if (number == null) {
                              return 'Please enter a valid number';
                            }
                            if (number <= 0) {
                              return 'Please enter a number greater than 0';
                            }
                            return null;
                          },
                        ),
                      ],
                    ),
                    // Extra spacing if needed
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
          ),
          // Fixed submit button at the bottom of the screen
          GestureDetector(
            onTap: () {
              if (_formKey.currentState!.validate()) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Adding quest...')),
                );
                questDatabase.addQuest(
                  _nameController.text,
                  _dropdownValue,
                  int.parse(_goalController.text),
                );
              }
            },
            child: Container(
              margin: const EdgeInsets.only(bottom: 12),
              width: double.infinity,
              height: 48,
              decoration: BoxDecoration(
                color: context.primary,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(
                child: Text(
                  "Create Quest",
                  style: GoogleFonts.roboto(
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
