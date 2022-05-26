import 'package:cityone_driver/const/route_names.dart';
import 'package:cityone_driver/controllers/orders_conductor_controller.dart';
import 'package:cityone_driver/models/order.dart';
import 'package:cityone_driver/ui/widgets/circular_loading_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';


class OrdersConductor extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context, width: 750, height: 1300, allowFontScaling: true);

    return GetBuilder<OrdersConductorController>(
      init: OrdersConductorController(),
      builder: (_) {
        return Scaffold(
          body: SingleChildScrollView(
            child: Column(
              children: [
                Obx(() => _.userFirebase.value.id  == null ? CircularLoadingWidget(height: 500) :
                   ClipPath(
                    clipper: WaveClipperTwo(),
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topRight,
                          end: Alignment.bottomLeft,
                          colors: [
                            Theme.of(context).accentColor,
                            Theme.of(context).accentColor,
                            Theme.of(context).accentColor,
                          ]
                        )
                      ),
                      height: ScreenUtil().setHeight(500),
                      width: ScreenUtil().setWidth(750),
                      child: SafeArea(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                SizedBox(
                                  width: ScreenUtil().setWidth(30),
                                ),
                                Text('Activo', style: Theme.of(context).textTheme.title.merge(TextStyle(letterSpacing: 1.3, fontSize: ScreenUtil().setSp(40) , color: Theme.of(context).primaryColor)),),
                                Switch(
                                  value: _.userFirebase.value.turn,
                                  onChanged: (value) {
                                    _.changeTurn();
                                  },
                                  activeTrackColor: Colors.lightGreenAccent,
                                  activeColor: Colors.green,
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Text('Tipo de usuario:', style: Theme.of(context).textTheme.title.merge(TextStyle(letterSpacing: 1.3, fontSize: ScreenUtil().setSp(80) , color: Theme.of(context).primaryColor)),),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Text(_userRole(_), style: Theme.of(context).textTheme.title.merge(TextStyle(letterSpacing: 1.3, fontSize: ScreenUtil().setSp(80) , color: Theme.of(context).primaryColor)),),
                              ],
                            ),
                            SizedBox(
                              height: ScreenUtil().setHeight(20),
                            ),
                            SizedBox(
                              height: ScreenUtil().setHeight(20),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                GetBuilder<OrdersConductorController>(
                  id: 'listOrder',
                  builder: (__) {
                    return __.orders != null ? ListView(
                      padding: EdgeInsets.symmetric(horizontal: ScreenUtil().setWidth(20)),
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      children: __.orders.map((e) {
                        return _tripCard(e, context);
                      }).toList()
                    ):  CircularLoadingWidget(height: 500);
                  }
                ),

              ],
            ),
          ),
        );
      }
    );
  }

  Widget _tripCard(Order order, BuildContext context) {
    String _estado = '';
    Color _color = Colors.white;
    Color _colorText= Colors.black54;
    switch(order.status){
      case  'Cancel':
      case 'CancelProfessional':
        _estado = 'Cancelado';
        _color = Colors.red;
        _colorText = Colors.white;
        break;
      case 'ExpireTime':
        _estado = 'Tiempo expirado';
        _color = Colors.red;
        _colorText = Colors.white;
        break;
      case 'PaymentDriveFailed':
      case 'Initial':
        _estado = 'Esperando el pago';
        _color = Colors.red;
        _colorText = Colors.white;
        break;
      case 'PaymentDriveSuccess':
        _estado = 'Ve a la ubicación del cliente';
        _color = Colors.white;
        _colorText = Colors.black54;
        break;
      case 'Come':
        _estado = 'Has llegado a la ubicación';
        _color = Colors.white;
        _colorText = Colors.black54;
        break;
      case 'InDrive':
        _estado = 'Vas en viaje';
        _color = Colors.white;
        _colorText = Colors.black54;
        break;
      case 'Arrive':
        _estado = 'Viaje finalizado';
        _color = Colors.white;
        _colorText = Colors.black54;
        break;
      default :
        _estado = 'Sin especificar';
        Color _color = Colors.white;
        Color _colorText= Colors.black54;
    }
    return Card(
      color: _color,
      elevation: 2,
      child: ListTile(
        onTap: (){
          //Navigator.of(context).pushNamed('/TransactionCab', arguments: RouteArgument(id: trip.id));
          Get.toNamed(TransactionViewRoute, arguments: order.id);
        },
        title: Text('Estado: $_estado', style: TextStyle(color: _colorText, fontSize: ScreenUtil().setSp(30)),),
        subtitle: Text('Distancia ${order.kilometres.toDouble().toStringAsFixed(1)} kilometros', style: TextStyle(color: _colorText, fontSize: ScreenUtil().setSp(30)) ),
      ),
    );
  }

  String _userRole(OrdersConductorController _) {
    return _.userFirebase.value.role == 'uber' ? 'Conductor' : 'Mensajero';
  }
}
