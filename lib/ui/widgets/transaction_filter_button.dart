import 'package:flutter/material.dart';

import '../../models/transaction.dart';
import 'filter_button.dart';
import '../../l10n/app_localization.dart';

class TransactionFilterButton extends StatefulWidget {
  final ValueChanged<TransactionType?> onPress;
  final bool isExistAll;
  final TransactionType? currentSelect;
  const TransactionFilterButton({super.key, required this.onPress, this.isExistAll = false, this.currentSelect});

  @override
  State<TransactionFilterButton> createState() => _TransactionFilterButtonState();
}

class _TransactionFilterButtonState extends State<TransactionFilterButton> {
  TransactionType? transactionType;
  @override
  void initState() {
    super.initState(); 
    if(widget.currentSelect != null){
      transactionType = widget.currentSelect;
    }else{
      transactionType = widget.isExistAll ? null : TransactionType.income;
    }
  }
  void onPressed(TransactionType? type){
    setState(() {
      transactionType = type;
    });
    widget.onPress(type);
  } 

  @override
  Widget build(BuildContext context) {
    final colorTheme = Theme.of(context).colorScheme;
    return Container(
      padding: EdgeInsets.symmetric(vertical: 3, horizontal: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        color: colorTheme.primary
      ),
      child: Row(
        children: [
            if(widget.isExistAll) Expanded(child: FilterButton(name: AppLocalizations.of(context)!.all, onPress:() => onPressed(null), isClick: transactionType == null),),
            Expanded(
              child: FilterButton(name: AppLocalizations.of(context)!.income, onPress:() => onPressed(TransactionType.income), isClick: transactionType == TransactionType.income),
            ),
            Expanded(
              child: FilterButton(name: AppLocalizations.of(context)!.expense, onPress:() => onPressed(TransactionType.expense), isClick: transactionType == TransactionType.expense),
            )
        ],
      ),
    );
  }
}