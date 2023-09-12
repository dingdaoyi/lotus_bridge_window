import 'package:fluent_ui/fluent_ui.dart';
class DrawerNavigation extends StatelessWidget {
  final List<DrawerNavItem> items;

  const DrawerNavigation({
    super.key,
    required this.items,
  }) ;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      scrollDirection: Axis.horizontal,
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        return Center(
          child: GestureDetector(
            child: Text.rich(
              TextSpan(
                children: [
                  if( item.icon!=null) WidgetSpan(child: Icon(item.icon,
                  color:  const Color.fromRGBO(159, 172, 175, 1),size: 14,)),
                  TextSpan(
                    text: ' ${item.title}',
                    style: const TextStyle(
                      color: Color.fromRGBO(159, 172, 175, 1)
                    ),
                  ),
                ],
              ),
            ),
            onTap: () {
              item.callback?.call();
            },
          ),
        );
      }, separatorBuilder: (BuildContext context, int index) {
        return  const Center(child: Icon(FluentIcons.chevron_right,size: 14,
        color: Color.fromRGBO(159, 172, 175, 1),),);
    },
    );
  }
}

typedef DrawerNavItemCallback = void Function();

class DrawerNavItem {

  final String title;
  final IconData? icon;
  final DrawerNavItemCallback? callback;


  const DrawerNavItem({
    required this.title,
    this.icon,
    this.callback
  });
}