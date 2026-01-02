import 'package:flutter/material.dart';
import '../../models/category.dart';
import '../../l10n/app_localization.dart';
import 'input_decoration.dart';
class CustomDropdownCategory extends StatelessWidget {
  final List<Category> categoryList;
  final ValueChanged<Category> onSelectCategory;
  final String? Function(Category?)? validator;
  final Category? selectedCategory;
  const CustomDropdownCategory({super.key, required this.categoryList, required this.onSelectCategory, required this.validator, this.selectedCategory});

  @override
  Widget build(BuildContext context) {
    final language = AppLocalizations.of(context)!;
    final textTheme = Theme.of(context).textTheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(language.category.toUpperCase(), style:const TextStyle(color: Colors.black),),
        const SizedBox(height: 10),
        DropdownButtonFormField<Category>(
          initialValue: selectedCategory,
          icon: Padding(
            padding: const EdgeInsets.only(right: 10),
            child: Icon(Icons.keyboard_arrow_down),
          ),
          validator: validator,
          decoration: customInputDecoration(),
          hint: Text(language.selectCategory, style:const TextStyle(fontWeight: FontWeight.normal, color: Colors.grey, fontSize: 14),),
          items: categoryList.map((c) {
            return DropdownMenuItem<Category>(
              value: c,
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 20,
                    backgroundColor: c.backgroundColor,
                    child: Image.asset(
                      c.icon,
                      width: 20,
                      height: 20,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Text(c.label, style: textTheme.titleMedium),
                ],
              ),
            );
          }).toList(),
          selectedItemBuilder: (context) {
            return categoryList.map((c) {
              return Text(c.label, style: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.normal));
            }).toList();
          },
          onChanged: (value) {
            if (value != null) {
              onSelectCategory(value);
            }
          },
        ),
      ],
    );
  }
}
