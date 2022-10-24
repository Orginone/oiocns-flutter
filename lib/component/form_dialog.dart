import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:get/get.dart';

class FormDialog extends GetView<FormController> {
  const FormDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormBuilderState>();
    return Scaffold(
      appBar: AppBar(title: const Text('Form Builder Example')),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              FormBuilder(
                key: formKey,
                // enabled: false,
                onChanged: () {
                  formKey.currentState!.save();
                  debugPrint(formKey.currentState!.value.toString());
                },
                autovalidateMode: AutovalidateMode.disabled,
                initialValue: const {
                  'movie_rating': 5,
                  'best_language': 'Dart',
                  'age': '13',
                  'gender': 'Male',
                  'languages_filter': ['Dart']
                },
                skipDisabled: true,
                child: Column(
                  children: <Widget>[
                    const SizedBox(height: 15),
                    FormBuilderDateTimePicker(
                      name: 'date',
                      initialEntryMode: DatePickerEntryMode.calendar,
                      initialValue: DateTime.now(),
                      inputType: InputType.both,
                      decoration: InputDecoration(
                        labelText: 'Appointment Time',
                        suffixIcon: IconButton(
                          icon: const Icon(Icons.close),
                          onPressed: () {
                            formKey.currentState!.fields['date']
                                ?.didChange(null);
                          },
                        ),
                      ),
                      initialTime: const TimeOfDay(hour: 8, minute: 0),
                      // locale: const Locale.fromSubtags(languageCode: 'fr'),
                    ),
                    FormBuilderDateRangePicker(
                      name: 'date_range',
                      firstDate: DateTime(1970),
                      lastDate: DateTime(2030),
                      decoration: InputDecoration(
                        labelText: 'Date Range',
                        helperText: 'Helper text',
                        hintText: 'Hint text',
                        suffixIcon: IconButton(
                          icon: const Icon(Icons.close),
                          onPressed: () {
                            formKey.currentState!.fields['date_range']
                                ?.didChange(null);
                          },
                        ),
                      ),
                    ),
                    FormBuilderSlider(
                      name: 'slider',
                      min: 0.0,
                      max: 10.0,
                      initialValue: 7.0,
                      divisions: 20,
                      activeColor: Colors.red,
                      inactiveColor: Colors.pink[100],
                      decoration: const InputDecoration(
                        labelText: 'Number of things',
                      ),
                    ),
                    FormBuilderRangeSlider(
                      name: 'range_slider',
                      // validator: FormBuilderValidators.compose([FormBuilderValidators.min(context, 6)]),
                      min: 0.0,
                      max: 100.0,
                      initialValue: const RangeValues(4, 7),
                      divisions: 20,
                      activeColor: Colors.red,
                      inactiveColor: Colors.pink[100],
                      decoration:
                          const InputDecoration(labelText: 'Price Range'),
                    ),
                    FormBuilderCheckbox(
                      name: 'accept_terms',
                      initialValue: false,
                      title: RichText(
                        text: const TextSpan(
                          children: [
                            TextSpan(
                              text: 'I have read and agree to the ',
                              style: TextStyle(color: Colors.black),
                            ),
                            TextSpan(
                              text: 'Terms and Conditions',
                              style: TextStyle(color: Colors.blue),
                              // Flutter doesn't allow a button inside a button
                              // https://github.com/flutter/flutter/issues/31437#issuecomment-492411086
                              /*
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  print('launch url');
                                },
                              */
                            ),
                          ],
                        ),
                      ),
                    ),
                    FormBuilderTextField(
                      autovalidateMode: AutovalidateMode.always,
                      name: 'age',
                      decoration: InputDecoration(
                        labelText: 'Age',
                      ),
                      onChanged: (val) {
                      },
                      // valueTransformer: (text) => num.tryParse(text),
                      // initialValue: '12',
                      keyboardType: TextInputType.number,
                      textInputAction: TextInputAction.next,
                    ),
                    FormBuilderDropdown<String>(
                      items: [],
                      // autovalidate: true,
                      name: 'gender',
                      decoration: InputDecoration(
                        labelText: 'Gender',
                        hintText: 'Select Gender',
                      ),
                      onChanged: (val) {
                      },
                      valueTransformer: (val) => val?.toString(),
                    ),
                    FormBuilderRadioGroup<String>(
                      decoration: const InputDecoration(
                        labelText: 'My chosen language',
                      ),
                      initialValue: null,
                      name: 'best_language',
                      options:
                          ['Dart', 'Kotlin', 'Java', 'Swift', 'Objective-C']
                              .map((lang) => FormBuilderFieldOption(
                                    value: lang,
                                    child: Text(lang),
                                  ))
                              .toList(growable: false),
                      controlAffinity: ControlAffinity.trailing,
                    ),
                    FormBuilderSegmentedControl(
                      decoration: const InputDecoration(
                        labelText: 'Movie Rating (Archer)',
                      ),
                      name: 'movie_rating',
                      // initialValue: 1,
                      // textStyle: TextStyle(fontWeight: FontWeight.bold),
                      options: List.generate(5, (i) => i + 1)
                          .map((number) => FormBuilderFieldOption(
                                value: number,
                                child: Text(
                                  number.toString(),
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold),
                                ),
                              ))
                          .toList(),
                    ),
                    FormBuilderSwitch(
                      title: const Text('I Accept the terms and conditions'),
                      name: 'accept_terms_switch',
                      initialValue: true,
                    ),
                    FormBuilderCheckboxGroup<String>(
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      decoration: const InputDecoration(
                          labelText: 'The language of my people'),
                      name: 'languages',
                      // initialValue: const ['Dart'],
                      options: const [
                        FormBuilderFieldOption(value: 'Dart'),
                        FormBuilderFieldOption(value: 'Kotlin'),
                        FormBuilderFieldOption(value: 'Java'),
                        FormBuilderFieldOption(value: 'Swift'),
                        FormBuilderFieldOption(value: 'Objective-C'),
                      ],
                      separator: const VerticalDivider(
                        width: 10,
                        thickness: 5,
                        color: Colors.red,
                      ),
                    ),
                    FormBuilderFilterChip<String>(
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      decoration: const InputDecoration(
                          labelText: 'The language of my people'),
                      name: 'languages_filter',
                      selectedColor: Colors.red,
                      options: const [
                        FormBuilderChipOption(
                          value: 'Dart',
                          avatar: CircleAvatar(child: Text('D')),
                        ),
                        FormBuilderChipOption(
                          value: 'Kotlin',
                          avatar: CircleAvatar(child: Text('K')),
                        ),
                        FormBuilderChipOption(
                          value: 'Java',
                          avatar: CircleAvatar(child: Text('J')),
                        ),
                        FormBuilderChipOption(
                          value: 'Swift',
                          avatar: CircleAvatar(child: Text('S')),
                        ),
                        FormBuilderChipOption(
                          value: 'Objective-C',
                          avatar: CircleAvatar(child: Text('O')),
                        ),
                      ],
                    ),
                    FormBuilderChoiceChip<String>(
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      decoration: const InputDecoration(
                          labelText:
                              'Ok, if I had to choose one language, it would be:'),
                      name: 'languages_choice',
                      initialValue: 'Dart',
                      options: const [
                        FormBuilderChipOption(
                          value: 'Dart',
                          avatar: CircleAvatar(child: Text('D')),
                        ),
                        FormBuilderChipOption(
                          value: 'Kotlin',
                          avatar: CircleAvatar(child: Text('K')),
                        ),
                        FormBuilderChipOption(
                          value: 'Java',
                          avatar: CircleAvatar(child: Text('J')),
                        ),
                        FormBuilderChipOption(
                          value: 'Swift',
                          avatar: CircleAvatar(child: Text('S')),
                        ),
                        FormBuilderChipOption(
                          value: 'Objective-C',
                          avatar: CircleAvatar(child: Text('O')),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Row(
                children: <Widget>[
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        if (formKey.currentState?.saveAndValidate() ?? false) {
                          debugPrint(formKey.currentState?.value.toString());
                        } else {
                          debugPrint(formKey.currentState?.value.toString());
                          debugPrint('validation failed');
                        }
                      },
                      child: const Text(
                        'Submit',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        formKey.currentState?.reset();
                      },
                      // color: Theme.of(context).colorScheme.secondary,
                      child: Text(
                        'Reset',
                        style: TextStyle(
                            color: Theme.of(context).colorScheme.secondary),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class FormController extends GetxController {}
