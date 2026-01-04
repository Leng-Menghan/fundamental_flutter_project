import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../l10n/app_localization.dart';
import '../../models/transaction.dart';
import '../../models/category.dart';
import '../widgets/cus_dropdown_category.dart';
import '../widgets/cus_outline_button.dart';
import '../widgets/cus_select_date.dart';
import '../widgets/cus_textfield.dart';
import '../widgets/transaction_filter_button.dart';

class TransactionFormScreen extends StatefulWidget {
  final String amountLabel;
  final DateTime? date;
  final Transaction? editTransaction;
  const TransactionFormScreen({super.key, required this.amountLabel, this.editTransaction, this.date});

  @override
  State<TransactionFormScreen> createState() => _TransactionFormScreenState();
}

class _TransactionFormScreenState extends State<TransactionFormScreen> {
  final _formKey = GlobalKey<FormState>();

  TransactionType type = TransactionType.income;
  final titleController = TextEditingController();
  final amountController = TextEditingController();
  Category? selectedCategory;
  DateTime? selectedDate;

  @override
  void initState() {
    super.initState();
    if(widget.editTransaction != null){
      type = widget.editTransaction!.type;
      titleController.text = widget.editTransaction!.title;
      selectedCategory = widget.editTransaction!.category;
      amountController.text = widget.editTransaction!.amount.toString();
      selectedDate = widget.editTransaction!.date;
      dateController.text = DateFormat("EEE, dd MMM yyyy").format(widget.editTransaction!.date);
    }
    if(widget.date != null){
      selectedDate = widget.date;
      dateController.text = DateFormat("EEE, dd MMM yyyy").format(widget.date!);
    }
  }

  final dateController = TextEditingController();

  List<Category> get categories => type == TransactionType.income ? Category.incomeCategories : Category.expenseCategories;

  Future<void> selectDate() async {
    final locale = Localizations.localeOf(context).toString();
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now(),
      firstDate: DateTime(2015, 8),
      lastDate: DateTime(2101)
    );
    if (picked != null) {
      setState(() {
        selectedDate = picked;
        dateController.text = DateFormat("EEE, dd MMM yyyy", locale).format(selectedDate!);
      });
    }
  }
  
  void onSave(){
    if (_formKey.currentState!.validate()) {
      String title = titleController.text;
      double? amount = double.tryParse(amountController.text);
      Category? category = selectedCategory;
      DateTime? date = selectedDate;
      Transaction newTransaction = Transaction(id: widget.editTransaction?.id , title: title, amount: amount!, category: category!, type: type, date: date!);
      Navigator.of(context).pop<Transaction>(newTransaction);
    }
  }

  String? validateTitle(String? value, AppLocalizations language) {
    if (value == null || value.isEmpty) {
      return language.titleRequired;
    }
    if (value.length < 5 ||  value.length > 50) {
      return language.titleLength;
    }
    return null;
  }

  String? validateAmount(String? value, AppLocalizations language) {
    if (value == null || value.isEmpty) {
      return language.amountRequired;
    }
    double? amount = double.tryParse(value);
    if ( amount == null || amount <= 0) {
      return language.amountPositive;
    }
    return null;
  }
  String? validateCategory(Category? value, AppLocalizations language) {
    if (value == null) {
      return language.categoryRequired;
    }
    return null;
  }

  String? validateDate(String? value, AppLocalizations language){
    if(selectedDate == null){
      return language.dateRequired;
    }
    return null;
  }

  @override
  void dispose() {
    titleController.dispose();
    amountController.dispose();
    dateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorTheme = Theme.of(context).colorScheme;
    final language = AppLocalizations.of(context)!;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        toolbarHeight: 80,
        leading: IconButton(onPressed: () => Navigator.pop(context) , icon: Icon(Icons.arrow_back_ios_rounded, color: Colors.white,)),
        title: Text(
          widget.editTransaction == null ? 
            (type == TransactionType.income ? language.createIncome : language.createExpense)
          : 
            (type == TransactionType.income ? language.editIncome : language.editExpense),
          style: textTheme.displaySmall?.copyWith(color: colorTheme.onPrimary),
        ),
        centerTitle: true,
        backgroundColor: colorTheme.secondary,
      ),
      backgroundColor: colorTheme.secondary,
      body: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20)
          ),
          color: colorTheme.onPrimary,
        ),
        padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TransactionFilterButton(onPress: (t) {
                      setState(() {
                        type = t!;
                        selectedCategory = null;
                      });
                    }, currentSelect: type,),
                    const SizedBox(height: 20),
                    CustomTextField(
                      label: language.title.toUpperCase(),
                      hintText: language.enterTitle,
                      text: titleController,
                      validator: (value) => validateTitle(value, language),
                      islength: true,
                    ),
                    const SizedBox(height: 5),
                    CustomDropdownCategory(
                      selectedCategory: selectedCategory,
                      key: ValueKey(type),
                      validator: (value) => validateCategory(value, language),
                      categoryList: categories, 
                      onSelectCategory: (value){
                        setState(() {
                          selectedCategory = value;
                        });
                      },
                    ),
                    const SizedBox(height: 20),
                    CustomTextField(
                      label: language.amount.toUpperCase(),
                      hintText: language.enterAmount,
                      text: amountController,
                      isNumInput: true,
                      prefix: "${widget.amountLabel} ",
                      validator: (value)=> validateAmount(value, language),
                    ),
                    const SizedBox(height: 20),
                    CustomeSelectDate(
                      validator: (value) => validateDate(value, language), 
                      hintText: language.selectDate, 
                      label: language.date.toUpperCase(), 
                      onTap: selectDate, 
                      text: dateController)
                  ],
                ),
              ),
            ),
            CustomOutlineButton(onPress: onSave, isLong: true, name: language.save)
          ],
        ),
      ),
    );
  }
}
