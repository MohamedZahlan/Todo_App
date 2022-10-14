import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_projects/modules/news_app/web_view.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../layout/todo_app/cubit/cubit.dart';
import '../../modules/news_app/search.dart';
import '../../modules/shop_app/login/shop_login_screen.dart';

Widget defaultButton(
        {Color background = Colors.teal,
        double width = double.infinity,
        bool isUpperCase = true,
        String text = 'login',
        Function? onTap,
        context
        //required Function function,
        }) =>
    Container(
      color: background,
      width: width,
      child: MaterialButton(
        onPressed: () {
          onTap!();
        },
        child: Text(isUpperCase ? text.toUpperCase() : text,
            style: Theme.of(context)
                .textTheme
                .bodyText1!
                .copyWith(color: Colors.white)),
      ),
    );

Widget defaultFormField({
  required String label,
  required IconData prefix,
  Widget? suffix,
  required TextEditingController controller,
  required validate,
  Function? onTap,
  bool obscureText = false,
  required TextInputType type,
}) =>
    TextFormField(
      decoration: InputDecoration(
        labelText: label,
        suffixIcon: suffix,
        prefixIcon: Icon(prefix),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
      ),
      validator: validate,
      obscureText: obscureText,
      keyboardType: type,
      onTap: () {
        onTap!();
      },
      textInputAction: TextInputAction.next,
      controller: controller,
      onChanged: (text) {},
    );

Widget buildTaskItem(Map model, context) => Dismissible(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Row(
          children: [
            CircleAvatar(
              radius: 40,
              backgroundColor: Colors.teal,
              child: Text(
                "${model['time']}",
                style: const TextStyle(color: Colors.white),
              ),
            ),
            const SizedBox(
              width: 10,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "${model['title']}",
                    style: Theme.of(context).textTheme.bodyText1,
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  Text(
                    "${model['date']}",
                    style: const TextStyle(color: Colors.grey, fontSize: 16),
                  ),
                ],
              ),
            ),
            const SizedBox(
              width: 10,
            ),
            IconButton(
                onPressed: () {
                  TodoCubit.get(context).updateDataBase(
                    status: 'done',
                    id: model['id'],
                  );
                },
                icon: const Icon(
                  Icons.check_circle,
                  color: Colors.green,
                )),
            const SizedBox(
              width: 10,
            ),
            IconButton(
                onPressed: () {
                  TodoCubit.get(context)
                      .updateDataBase(status: "archived", id: model['id']);
                },
                icon: const Icon(
                  Icons.archive_outlined,
                  color: Colors.green,
                )),
          ],
        ),
      ),
      key: Key(model['id'].toString()),
      onDismissed: (direction) {
        TodoCubit.get(context).deleteFromDataBase(id: model['id']);
      },
    ); // Dismissible => to swipe

Widget tasksBuilder({
  required newTask,
}) =>
    ConditionalBuilder(
      condition: newTask.isNotEmpty,
      builder: (context) => ListView.separated(
        itemBuilder: (context, index) => buildTaskItem(newTask[index], context),
        separatorBuilder: (context, index) => myDivider(),
        itemCount: newTask.length,
      ),
      fallback: (context) => Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.menu,
              //color: Colors.black45,
              size: 80,
            ),
            Text(
              "No Tasks yet, Please Add Some Tasks",
              style: Theme.of(context).textTheme.bodyText1,
            ),
          ],
        ),
      ),
    );

Widget myDivider() => Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        height: 1,
        width: double.infinity,
        color: Colors.grey[200],
      ),
    );

// Widget buildArticleItem(articles, context)=>InkWell(
//   onTap: (){
//     Navigator.push(context, MaterialPageRoute(builder: (context)=>WebViewScreen(url: articles['url'],)));
//   },
//   child:   Padding(
//     padding: const EdgeInsets.all(20.0),
//     child: Row(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       mainAxisAlignment: MainAxisAlignment.start,
//       children: [
//         Container(
//           height: 120,
//           width: 120,
//           decoration: BoxDecoration(
//             image: articles['urlToImage'] == 'null'?
//             const DecorationImage(
//                 image: AssetImage('assets/Images/No Image Available.JPG'),
//             ) :
//                 DecorationImage(image: NetworkImage('${articles['urlToImage']}'),
//                   fit: BoxFit.cover
//                 )
//           ),
//         ),
//         const SizedBox(width: 15,),
//         Expanded(
//           child: SizedBox(
//             height: 120,
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children:  [
//                 Expanded(
//                   child: Text(
//                     articles['title'],
//                     maxLines: 3,
//                     overflow: TextOverflow.ellipsis,
//                     style: Theme.of(context).textTheme.bodyText1
//                   ),
//                 ),
//                 Text(
//                   articles['publishedAt'],
//                   style: const TextStyle(
//                       color: Colors.grey
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ],
//     ),
//   ),
// );
//
// Widget articleBuilderItem({
//   required list,
//   isSearch=false,
// })=>ConditionalBuilder(
//   condition: list.isNotEmpty,
//   builder: (context)=>ListView.separated(
//     itemBuilder: (context, index)=>buildArticleItem(list[index],context),
//     separatorBuilder: (context, index)=>myDivider(),
//     itemCount: list.length,
//   ),
//   fallback: (context)=> isSearch? Container() : const Center(child: CircularProgressIndicator()),
// );

Widget buildArticleItem(articles, context) => InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => WebViewScreen(url: articles['url'])),
        );
      },
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                  image: articles['urlToImage'] == null
                      ? const DecorationImage(
                          image: AssetImage(
                              'assets/Images/No Image Available.JPG'),
                          fit: BoxFit.cover)
                      : DecorationImage(
                          image: NetworkImage('${articles['urlToImage']}')),
                  borderRadius: BorderRadius.circular(5)),
            ),
            const SizedBox(
              width: 10,
            ),
            Expanded(
              child: SizedBox(
                height: 120,
                child: Column(
                  children: [
                    Expanded(
                      child: Text(
                        articles['title'],
                        overflow: TextOverflow.ellipsis,
                        maxLines: 3,
                        style: Theme.of(context).textTheme.bodyText1,
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Text(
                      articles['publishedAt'],
                      style: const TextStyle(
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );

Widget articleBuilder({
  required list,
  bool isSearch = false,
}) =>
    ConditionalBuilder(
      condition: list.isNotEmpty,
      builder: (context) => ListView.separated(
        physics: const BouncingScrollPhysics(),
        itemBuilder: (context, index) => buildArticleItem(list[index], context),
        separatorBuilder: (context, index) => myDivider(),
        itemCount: list.length,
      ),
      fallback: (context) => isSearch
          ? Container()
          : const Center(child: CircularProgressIndicator()),
    );

void navigateTo(context, widget) =>
    Navigator.push(context, MaterialPageRoute(builder: (context) => widget));

void navigateFinish(context, widget) => Navigator.pushAndRemoveUntil(
    context,
    MaterialPageRoute(
      builder: (context) => widget,
    ),
    (route) => false);

Widget defaultTextButton({required Function function, required String text}) =>
    TextButton(
      onPressed: () {
        function();
      },
      child: Text(
        text,
        style: const TextStyle(fontSize: 16),
      ),
    );

void showToast({
  required String message,
  required ToastStates state,
}) =>
    Fluttertoast.showToast(
        msg: message,
        fontSize: 16,
        timeInSecForIosWeb: 5,
        backgroundColor: chooseToastColor(state),
        textColor: Colors.white,
        toastLength: Toast.LENGTH_LONG);

enum ToastStates { SUCCESS, ERROR, WARNING }

Color chooseToastColor(ToastStates state) {
  Color color;
  switch (state) {
    case ToastStates.SUCCESS:
      color = Colors.green;
      break;
    case ToastStates.ERROR:
      color = Colors.red;
      break;
    case ToastStates.WARNING:
      color = Colors.amber;
      break;
  }
  return color;
}
