import 'package:fluent_ui/fluent_ui.dart';

class DynamicForm extends StatefulWidget {
  final Map<String, dynamic> formData;
  final void Function(Map<String, String>) onSubmit;
  final String? value;

  const DynamicForm({Key? key, required this.formData, required this.onSubmit,
  this.value}) : super(key: key);

  @override
  _DynamicFormState createState() => _DynamicFormState();
}

class _DynamicFormState extends State<DynamicForm> {

  @override
  Widget build(BuildContext context) {
     var field= widget.formData;
    final name = field['name'] as String;
    final elType = field['eltype'] as String;
    final label = field['label'] as String;
    final placeholder = field['placeholder'] as String;

    if (elType == 'input') {
      return InfoLabel(
        label: label,
        child: TextFormBox(
          initialValue: widget.value,
          placeholder: placeholder,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return label;
            }
            return null;
          },
          onSaved: (value) {
            widget.onSubmit({
              name:value.toString()
            });
          },
        ),
      );
    } else if (elType == 'number') {
      return InfoLabel(
        label: label,
        child: TextFormBox(
          initialValue: widget.value,
          placeholder: placeholder,
          // mode: SpinButtonPlacementMode.inline,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return label;
            }
            if (int.tryParse(value) == null) {
              return '请输入数字';
            }
            return null;
          },
          onChanged: (value){

          },
          onSaved: (value) {
            widget.onSubmit({
              name:value.toString()
            });
          },
        ),
      );
    }
    return Container();
  }
}