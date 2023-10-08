import 'package:fluent_ui/fluent_ui.dart';
import 'package:lotus_bridge_window/service/http_utils.dart';

import '../models/result.dart';

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

  HttpUtil httpUtil=HttpUtil();
  String name ='';
  String elType = '';
  String label ='';
  String placeholder = '';
  Map<String,dynamic> options={} ;
  @override
  void initState() {
    super.initState();
    initData() ;
  }
  @override
  Widget build(BuildContext context) {
    String labelOption= options['label']??'label';
    String valueOption= options['value']??'value';
    List dictValue= options['dict_value']??[];
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
          onSaved: (value) {
            widget.onSubmit({
              name:value.toString()
            });
          },
        ),
      );
    }else if(elType == 'select'){
      return InfoLabel(
        label: label,
        child: ComboboxFormField(
          value: widget.value,
          items: dictValue.map((opt) => ComboBoxItem(
            value: opt[valueOption],
              child: Text(opt[labelOption]))).toList(),
          onSaved: (value) {
            widget.onSubmit({
              name:value.toString()
            });
          },
          onChanged: ( value) {
            widget.onSubmit({
              name:value.toString()
            });
          },
        ),
      );
    }
    return Container();
  }

  void initData() {
   setState(() {
     var field= widget.formData;
     name = field['name'] as String;
     elType = field['eltype'] as String;
     label = field['label'] as String;
     placeholder = field['placeholder'] as String;
     options = field['options']??{};
     if(elType!='select'){
       return;
     }

     if(options['dict_value']==null||options['dict_value'].isEmpty){
       String? dictUrl= options['dict_url'];
       if(dictUrl!=null) {
        httpUtil.get(dictUrl).then((result) {
          if(result.success) {
           setState(() {
             options['dict_value']=result.data;
           });
          }
        });
       }
     }
   });
  }
}