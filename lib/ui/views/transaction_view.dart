import 'package:cityone_driver/controllers/transaction_controller.dart';
import 'package:cityone_driver/ui/widgets/circular_loading_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:cityone_driver/repository/user_repository.dart' as userRepository;



// ignore: must_be_immutable
class TransactionView extends StatelessWidget {

  NumberFormat _money = NumberFormat.currency(
    locale: 'es',
    symbol: 'COP',
    decimalDigits: 2,
  );

  @override
  Widget build(BuildContext context) {
    return GetBuilder<TransactionController>(
        init: TransactionController(),
        builder: (model) {
          return Scaffold(
            body: model.trip == null?  CircularLoadingWidget(height: 500,) : Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SafeArea(
                        child: model.trip.type == 'uber' ? Image.asset('assets/img/taxi.png', height: 200,) : Image.asset('assets/img/delivery.png', height: 200,)
                    ),
                    SizedBox(height: 20.0,),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('Conductor:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black54),),
                        SizedBox(width: 5,),
                        Text('${model.trip.user.name}', style: TextStyle(fontSize: 18, color: Colors.black54),),
                      ],
                    ),
                    SizedBox(height: 10.0,),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('Precio:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black54),),
                        SizedBox(width: 5,),
                        Text('${_money.format(model.trip.total)}', style: TextStyle(fontSize: 18, color: Colors.black54),),
                      ],
                    ),
                    SizedBox(height: 10.0,),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('Kilometros:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black54),),
                        SizedBox(width: 5,),
                        Text(model.trip.kilometres.toStringAsFixed(2), style: TextStyle(fontSize: 18, color: Colors.black54),),
                      ],
                    ),
                    SizedBox(height: 10.0,),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        RaisedButton(
                          onPressed: model.goFromLocation,
                          child: Text('ubicación inicial'),
                          textColor: Colors.white70,
                          color: Colors.blue,
                        ),
                        RaisedButton(
                          onPressed:  model.goToLocation,
                          child: Text('ubicación destino'),
                          textColor: Colors.white70,
                          color: Colors.blue,
                        )
                      ],
                    ),

                    ...StatusTripWidget(model, context),

                  ],
                ),
              ),
            ),
          );
        }
    );
  }

  List<Widget> StatusTripWidget(TransactionController model, BuildContext context) {
    switch(model.trip.status){
      case 'PaymentDriveFailed':
      case 'Initial':
        return [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: LinearProgressIndicator(),
          ),
          SizedBox(height: 10,),
          Text('Esperando el pago', style:TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black54),),

        ];
      case 'CancelProfessional':
      case 'Cancel':
        return [
          Text('El servicio fue cancelado', style:TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.red),),
        ];
      case 'Come':
        return [
          Text('has llegado a la ubicacíon', style:TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black54),),
          SizedBox(height: 10,),
          Text('Espera el cliete', style:TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black54),),
          SizedBox(height: 10,),
          RaisedButton(
            onPressed: (){
              model.changeStatus('InDrive');

            },
            color: Colors.blue,
            child: Text(model.trip.type == 'uber' ? 'Iniciar viaje' : 'tengo el paquete'),
            textColor: Colors.white,
          )


        ];
      case 'InDrive':
        return [
          Text('Vas en camino a la dirección destino', style:TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black54),),
          SizedBox(height: 10,),
          RaisedButton(
            onPressed: (){
              model.finishTrip('Arrive');
              //model.changeStatus('Arrive');
            },
            color: Colors.blue,
            child: Text('He llegado'),
            textColor: Colors.white,
          )
        ];
      case 'Arrive':
        return [
          Text(model.trip.type == 'uber' ? 'Has llegado al destino': 'Entrega el producto', style:TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black54),),
        ];
      case 'ExpireTime':
        return [
          Text( 'Este servicio ha expirado', style:TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black54),),
        ];
      case 'PaymentDriveSuccess':
        return [
          Text( 'Dirijete a la ubicación del cliente', style:TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black54),),
          SizedBox(height: 10,),
          RaisedButton(
            onPressed: () {
               model.changeStatus('Come');
            },
            color: Colors.blue,
            child: Text('he llegado'),
            textColor: Colors.white,
          )
        ];
    }
  }
}
