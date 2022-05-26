import 'package:cityone_driver/controllers/profile_controller.dart';
import 'package:cityone_driver/ui/widgets/circular_loading_widget.dart';
import 'package:cityone_driver/ui/widgets/profile_avatar_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';


class ProfileView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
   // final theme = Theme.of(context).copyWith(dividerColor: Colors.transparent);
    return GetBuilder<ProfileController>(
      init: ProfileController(),
      builder: (_) =>
         Scaffold(
          appBar: AppBar(

            automaticallyImplyLeading: false,
            backgroundColor: Theme.of(context).accentColor,
            elevation: 0,
            centerTitle: true,
            title: Text(
              'Perfil',
              style: Theme.of(context).textTheme.title.merge(TextStyle(letterSpacing: 1.3, color: Theme.of(context).primaryColor)),
            ),
            actions: <Widget>[
              //new ShoppingCartButtonWidget(iconColor: Theme.of(context).primaryColor, labelColor: Theme.of(context).hintColor),
            ],
          ),
         // key: _con.scaffoldKey,
          body: _.user.apiToken == null
              ? CircularLoadingWidget(height: 500)
              : SingleChildScrollView(
//              padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 10),
               child: Column(
                children: <Widget>[
                  ProfileAvatarWidget(user: _.user),
                  ListTile(
                    contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    leading: Icon(
                      Icons.person,
                      color: Theme.of(context).hintColor,
                    ),
                    title: Text(
                      'sobre nosotros',
                      style: Theme.of(context).textTheme.display1,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Text(
                      _.user.bio,
                      style: Theme.of(context).textTheme.body1,
                    ),
                  ),
                  ListTile(
                    onTap: (){
                      _.salir();
                    },
                    contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    leading: Icon(
                      Icons.exit_to_app,
                      color: Theme.of(context).hintColor,
                    ),
                    title: Text(
                      'Salir',
                      style: Theme.of(context).textTheme.display1,
                    ),
                  )

              ],
            ),
          ),

        )
        );
      }


}
