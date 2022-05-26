import 'package:cityone_driver/const/route_names.dart';
import 'package:cityone_driver/controllers/history_controller.dart';
import 'package:cityone_driver/models/order.dart';
import 'package:cityone_driver/ui/widgets/circular_loading_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class OrdersHistoryConductor extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context, width: 750, height: 1300, allowFontScaling: true);
    return GetBuilder<HistoryController>(
      init: HistoryController(),
      builder: (_) {
        return Scaffold(
          appBar: AppBar(
            backgroundColor: Theme.of(context).accentColor,
            title: Text('Historial', style: Theme.of(context).textTheme.title.merge(TextStyle(color: Theme.of(context).primaryColor)),),
            centerTitle: true,
          ),
          body: Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: SingleChildScrollView(
              child:  GetBuilder<HistoryController>(
                  id: 'listHistory',
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
          Get.toNamed(TransactionViewRoute, arguments: order.id);
          //Navigator.of(context).pushNamed('/TransactionCab', arguments: RouteArgument(id: trip.id));
        },
        title: Text('Estado: $_estado', style: TextStyle(color: _colorText, fontSize: ScreenUtil().setSp(30)),),
        subtitle: Text('Distancia ${order.kilometres.toDouble().toStringAsFixed(1)} kilometros', style: TextStyle(color: _colorText, fontSize: ScreenUtil().setSp(30)) ),
      ),
    );
  }

}
