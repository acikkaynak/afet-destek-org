import 'package:afet_destek/shared/state/app_cubit.dart';
import 'package:afet_destek/shared/theme/color_extensions.dart';
import 'package:afet_destek/shared/widgets/loader.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:reactive_forms/reactive_forms.dart';

class DemandCategorySelector extends StatefulWidget {
  const DemandCategorySelector({required this.formControl, super.key});
  final FormControl<List<String>> formControl;

  @override
  State<DemandCategorySelector> createState() => _DemandCategorySelectorState();
}

class _DemandCategorySelectorState extends State<DemandCategorySelector> {
  late List<String> _selectedCategoryIds;

  late TextEditingController controller;

  void setControllerText() {
    controller.text = _selectedCategoryIds
        .map(
          (id) => context.read<AppCubit>().state.whenOrNull(
                loaded: (currentLocation, demandCategories) => demandCategories
                    .firstWhereOrNull(
                      (category) => category.id == id,
                    )
                    ?.name,
              ),
        )
        .whereNotNull()
        .join(', ');
  }

  @override
  void initState() {
    super.initState();
    controller = TextEditingController();
    // ignore: cast_nullable_to_non_nullable
    _selectedCategoryIds = List.from(widget.formControl.value as List<String>);
    setControllerText();
  }

  @override
  Widget build(BuildContext context) {
    // ignore: cast_nullable_to_non_nullable
    _selectedCategoryIds = List.from(widget.formControl.value as List<String>);

    final demandCategories = context.read<AppCubit>().state.whenOrNull(
          loaded: (currentLocation, demandCategories) => demandCategories,
        );

    if (demandCategories == null) {
      return const Loader();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const AppFormFieldTitle(title: 'İhtiyaç Türü'),
        TextFormField(
          readOnly: true,
          controller: controller,
          decoration: InputDecoration(
            hintText: 'İhtiyaç Türü Seçiniz',
            focusedBorder: OutlineInputBorder(
              borderRadius: const BorderRadius.all(Radius.circular(10)),
              borderSide:
                  BorderSide(width: 2, color: context.appColors.mainRed),
            ),
            border: OutlineInputBorder(
              borderRadius: const BorderRadius.all(Radius.circular(8)),
              borderSide: BorderSide(width: 2, color: context.appColors.stroke),
            ),
            hintStyle:
                TextStyle(color: context.appColors.notificationTermTexts),
            suffixIcon: const Icon(Icons.arrow_forward_ios),
          ),
          onTap: () => showDialog<void>(
            context: context,
            builder: (context) => StatefulBuilder(
              builder: (context, setStateForAlert) {
                return Dialog(
                  insetPadding: const EdgeInsets.symmetric(horizontal: 4),
                  child: SizedBox(
                    height: MediaQuery.of(context).size.height * 0.95,
                    child: CustomScrollView(
                      slivers: [
                        SliverFillRemaining(
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        'İhtiyaç Türü '
                                        '(${_selectedCategoryIds.length})',
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleLarge,
                                      ),
                                    ),
                                    IconButton(
                                      onPressed: Navigator.of(context).pop,
                                      icon: const Icon(Icons.close),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 4),
                                const Divider(),
                                const SizedBox(height: 4),
                                Expanded(
                                  child: ListView.builder(
                                    shrinkWrap: true,
                                    itemCount: demandCategories.length,
                                    itemBuilder: (context, index) {
                                      final category = demandCategories[index];
                                      final isSelected = _selectedCategoryIds
                                          .contains(category.id);
                                      return CheckboxListTile(
                                        contentPadding: EdgeInsets.zero,
                                        controlAffinity:
                                            ListTileControlAffinity.leading,
                                        value: isSelected,
                                        onChanged: (value) {
                                          setState(
                                            () => isSelected
                                                ? _selectedCategoryIds
                                                    .remove(category.id)
                                                : _selectedCategoryIds
                                                    .add(category.id),
                                          );
                                          setStateForAlert(() {});

                                          widget.formControl.value =
                                              _selectedCategoryIds;

                                          setControllerText();
                                        },
                                        title: Text(category.name),
                                      );
                                    },
                                  ),
                                ),
                                const Divider(),
                                Wrap(
                                  children: [
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width,
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.06,
                                      child: ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          padding: EdgeInsets.zero,
                                          backgroundColor:
                                              context.appColors.mainRed,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                        ),
                                        onPressed: () =>
                                            Navigator.of(context).pop(),
                                        child: Text(
                                          'Kaydet',
                                          textAlign: TextAlign.center,
                                          style: Theme.of(context)
                                              .textTheme
                                              .titleLarge
                                              ?.copyWith(
                                                color: context.appColors.white,
                                                fontWeight: FontWeight.w600,
                                              ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}

class AppFormFieldTitle extends StatelessWidget {
  const AppFormFieldTitle({
    super.key,
    required this.title,
  });

  final String title;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: context.appColors.subtitles,
              ),
        ),
        const SizedBox(height: 8),
      ],
    );
  }
}
