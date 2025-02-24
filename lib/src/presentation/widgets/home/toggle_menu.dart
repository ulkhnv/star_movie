import 'package:flutter/material.dart';
import 'package:star_movie/src/presentation/models/toggle_button_model.dart';
import 'package:star_movie/src/presentation/theme/app_colors.dart';
import 'package:star_movie/src/presentation/theme/app_spacing.dart';

class ToggleMenu extends StatefulWidget {
  const ToggleMenu({
    super.key,
    required this.tabController,
    required this.toggleButtons,
  });

  final TabController tabController;
  final List<ToggleButtonModel> toggleButtons;

  @override
  State createState() => _ToggleMenuState();
}

class _ToggleMenuState extends State<ToggleMenu> {
  int _selectedIndex = 0;

  void _onTap(int index) {
    setState(() {
      _selectedIndex = index;
      widget.tabController.animateTo(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.lightGrey),
      ),
      padding: const EdgeInsets.all(3),
      child: Row(
        children: List.generate(
          widget.toggleButtons.length,
          (index) => _buildToggleButton(index, widget.toggleButtons[index]),
        ),
      ),
    );
  }

  Widget _buildToggleButton(int index, ToggleButtonModel model) {
    bool isSelected = _selectedIndex == index;

    return Expanded(
      child: GestureDetector(
        onTap: () => _onTap(index),
        child: Container(
          decoration: BoxDecoration(
            color: isSelected ? AppColors.brand : Colors.transparent,
            borderRadius: BorderRadius.circular(20),
          ),
          alignment: Alignment.center,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (model.icon != null) ...[
                Icon(
                  model.icon,
                  color: isSelected ? AppColors.white : AppColors.grey,
                ),
                const SizedBox(width: AppSpacing.extraSmall),
              ],
              Text(
                model.text,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: isSelected ? AppColors.white : AppColors.grey,
                    fontWeight: FontWeight.w500),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
