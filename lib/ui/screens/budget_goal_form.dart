import 'package:flutter/material.dart';
import 'package:fundamental_flutter_project/ui/widgets/cus_outline_button.dart';
import '../widgets/cus_textfield.dart';
import '../../models/category.dart';
import '../../models/budget_goal.dart';
import '../widgets/cus_dropdown_category.dart';

class CreateBudget extends StatefulWidget {
  final String amountLabel;
  final BudgetGoal? edit;
  final DateTime date;
  final List<Category> avaliableCategories;
  const CreateBudget({super.key, required this.amountLabel, required this.date, this.edit, required this.avaliableCategories});

  @override
  State<CreateBudget> createState() => _CreateBudgetState();
}

class _CreateBudgetState extends State<CreateBudget> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _amountController = TextEditingController();
  Category? _selectedCategory;

  void _saveBudget() {
    if (_formKey.currentState!.validate()) {
      final double? amount = double.tryParse(_amountController.text);
      final Category? category = _selectedCategory;
      final goal = BudgetGoal(
        id: widget.edit?.id,
        category: category!,
        goalAmount: amount!,
        year: widget.date.year,
        month: widget.date.month,
      );
      Navigator.pop<BudgetGoal>(context, goal);
    }
  }

  @override
  void initState() {
    if(widget.edit != null){
      _amountController.text = widget.edit!.goalAmount.toString();
      _selectedCategory = widget.edit!.category;
    }
    super.initState();
  }

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  String? validateAmount(String? value) {
    if (value == null || value.isEmpty) {
      return "The amount needs to be filled";
    }
    double? amount = double.tryParse(value);
    if ( amount == null || amount <= 0) {
      return "Value must be positive number";
    }
    return null;
  }

  String? validateCategory(Category? value) {
    if (value == null) {
      return "Please select category";
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final textTheme = theme.textTheme;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        toolbarHeight: 80,
        leading: IconButton(onPressed: () => Navigator.pop(context) , icon: Icon(Icons.arrow_back_ios_rounded, color: Colors.white,)),
        title: Text(
          "Create Budget Goal",
          style: textTheme.displaySmall?.copyWith(color: colors.onPrimary),
        ),
        centerTitle: true,
        backgroundColor: colors.secondary,
      ),
      backgroundColor: colors.secondary,
      body: Container(
        padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20)
          ),
          color: colors.onPrimary,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Form(
              key: _formKey,
              child: Column(
                children: [
                  CustomTextField(
                    label: "AMOUNT", 
                    hintText: "Enter Amount", 
                    text: _amountController, 
                    validator: validateAmount, 
                    isNumInput: true,
                    prefix: "${widget.amountLabel} ",
                  ),
                  const SizedBox(height: 20),
                  CustomDropdownCategory(
                    selectedCategory: _selectedCategory,
                    categoryList: widget.avaliableCategories, 
                    onSelectCategory: (value) => setState(() => _selectedCategory = value),
                    validator: validateCategory
                  ),
                ],
              ),
            ),
            const Spacer(),
            CustomOutlineButton(name: "Save", onPress: _saveBudget, isLong: true,),
          ],
        ),
      ),
    );
  }
}
