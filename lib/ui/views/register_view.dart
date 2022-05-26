import 'package:cityone_driver/const/route_names.dart';
import 'package:cityone_driver/controllers/register_controller.dart';
import 'package:cityone_driver/ui/widgets/block_button_widget.dart';
import 'package:flutter/material.dart';
import 'package:cityone_driver/helpers/app_config.dart' as config;
import 'package:get/get.dart';


class RegisterView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<RegisterController>(
      init: RegisterController(),
      builder: (_) {
        return Scaffold(
          key: _.scaffoldKey,
          resizeToAvoidBottomPadding: false,
          body: Stack(
            alignment: AlignmentDirectional.topCenter,
            children: <Widget>[
              Positioned(
                top: 0,
                child: Container(
                  width: config.App(context).appWidth(100),
                  height: config.App(context).appHeight(29.5),
                  decoration: BoxDecoration(color: Theme.of(context).accentColor),
                ),
              ),
              Positioned(
                top: config.App(context).appHeight(29.5) - 140,
                child: Container(
                  width: config.App(context).appWidth(84),
                  height: config.App(context).appHeight(29.5),
                  child: Text(
                    '¡Comencemos con el registro!',
                    style: Theme.of(context).textTheme.display3.merge(TextStyle(color: Theme.of(context).primaryColor)),
                  ),
                ),
              ),
              Positioned(
                top: config.App(context).appHeight(29.5) - 50,
                child: Container(
                  decoration: BoxDecoration(color: Theme.of(context).primaryColor, borderRadius: BorderRadius.all(Radius.circular(10)), boxShadow: [
                    BoxShadow(
                      blurRadius: 50,
                      color: Theme.of(context).hintColor.withOpacity(0.2),
                    )
                  ]),
                  margin: EdgeInsets.symmetric(
                    horizontal: 20,
                  ),
                  padding: EdgeInsets.symmetric(vertical: 50, horizontal: 27),
                  width: config.App(context).appWidth(88),
//              height: config.App(context).appHeight(55),
                  child: Form(
                    key: _.registerFormKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        TextFormField(
                          keyboardType: TextInputType.text,
                          onSaved: (input) => _.user.name = input,
                          validator: (input) => input.length < 3 ? 'Debe tener un minimo de 3 caracteres' : null,
                          decoration: InputDecoration(
                            labelText: 'Nombre completo',
                            labelStyle: TextStyle(color: Theme.of(context).accentColor),
                            contentPadding: EdgeInsets.all(12),
                            hintText: 'jhon doe',
                            hintStyle: TextStyle(color: Theme.of(context).focusColor.withOpacity(0.7)),
                            prefixIcon: Icon(Icons.person_outline, color: Theme.of(context).accentColor),
                            border: OutlineInputBorder(borderSide: BorderSide(color: Theme.of(context).focusColor.withOpacity(0.2))),
                            focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Theme.of(context).focusColor.withOpacity(0.5))),
                            enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Theme.of(context).focusColor.withOpacity(0.2))),
                          ),
                        ),
                        SizedBox(height: 30),
                        TextFormField(
                          keyboardType: TextInputType.emailAddress,
                          onSaved: (input) => _.user.email = input,
                          validator: (input) => !input.contains('@') ? 'Debe ser email' : null,
                          decoration: InputDecoration(
                            labelText: 'Correo electrónico',
                            labelStyle: TextStyle(color: Theme.of(context).accentColor),
                            contentPadding: EdgeInsets.all(12),
                            hintText: 'johndoe@gmail.com',
                            hintStyle: TextStyle(color: Theme.of(context).focusColor.withOpacity(0.7)),
                            prefixIcon: Icon(Icons.alternate_email, color: Theme.of(context).accentColor),
                            border: OutlineInputBorder(borderSide: BorderSide(color: Theme.of(context).focusColor.withOpacity(0.2))),
                            focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Theme.of(context).focusColor.withOpacity(0.5))),
                            enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Theme.of(context).focusColor.withOpacity(0.2))),
                          ),
                        ),
                        SizedBox(height: 30),
                        Obx(() => TextFormField(
                            obscureText: _.hidePassword.value,
                            onSaved: (input) => _.user.password = input,
                            validator: (input) => input.length < 6 ? 'Debe tener un minimo de 6 caracteres' : null,
                            decoration: InputDecoration(
                              labelText: 'Contraseña',
                              labelStyle: TextStyle(color: Theme.of(context).accentColor),
                              contentPadding: EdgeInsets.all(12),
                              hintText: '••••••••••••',
                              hintStyle: TextStyle(color: Theme.of(context).focusColor.withOpacity(0.7)),
                              prefixIcon: Icon(Icons.lock_outline, color: Theme.of(context).accentColor),
                              suffixIcon: IconButton(
                                onPressed: () {
                                  _.changeHidePassword();
                                },
                                color: Theme.of(context).focusColor,
                                icon: Icon(_.hidePassword.value ? Icons.visibility : Icons.visibility_off),
                              ),
                              border: OutlineInputBorder(borderSide: BorderSide(color: Theme.of(context).focusColor.withOpacity(0.2))),
                              focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Theme.of(context).focusColor.withOpacity(0.5))),
                              enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Theme.of(context).focusColor.withOpacity(0.2))),
                            ),
                          ),
                        ),
                        SizedBox(height: 30),
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 10.0),
                          child: DropdownButton(
                            isDense: true,
                            underline: Text('Tipo:', style: TextStyle(color: Theme.of(context).accentColor, fontWeight: FontWeight.bold, fontSize: 16),),
                            isExpanded: true,
                            value: _.user.role,
                            items: [
                              DropdownMenuItem(
                                child: Center(
                                  child: Text('Conductor', style: TextStyle(color: Theme.of(context).accentColor),),
                                ),
                                value: 'uber',
                              ),
                              DropdownMenuItem(
                                child: Center(
                                  child: Text('Mensajero', style: TextStyle(color: Theme.of(context).accentColor)),
                                ),
                                value: 'messenger',
                              )
                            ],
                            onChanged:_.changeRole,
                          ),
                        ),
                        SizedBox(height: 30),
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 10.0),
                          child: _.vehicles != null && _.vehicles.length > 0 ? DropdownButton(
                            isDense: true,
                            underline: Text('Vehiculo:', style: TextStyle(color: Theme.of(context).accentColor, fontWeight: FontWeight.bold, fontSize: 16),),
                            isExpanded: true,
                            value: _.user.typeId,
                            items:_.vehicles.map((e) {
                              return DropdownMenuItem(
                                child: Center(
                                  child: Text(e.name, style: TextStyle(color: Theme.of(context).accentColor),),
                                ),
                                value: e.id,
                              );
                            }).toList(),
                            onChanged:(value){
                              _.changeVehicle(value);
                            },
                          ): SizedBox(),
                        ),
                        SizedBox(height: 30,),
                        BlockButtonWidget(
                          text: Text(
                            'Registrarse',
                            style: TextStyle(color: Theme.of(context).primaryColor),
                          ),
                          color: Theme.of(context).accentColor,
                          onPressed: () {
                           // _con.register();
                            _.register();
                          },
                        ),
                        SizedBox(height: 25),
                      ],
                    ),
                  ),
                ),
              ),
              Positioned(
                bottom: 10,
                child: FlatButton(
                  onPressed: () {
                    Get.offNamed(LoginViewRoute);
                  },
                  textColor: Theme.of(context).hintColor,
                  child: Text('ingresar'),
                ),
              )
            ],
          ),
        );
      }
    );
  }
}

