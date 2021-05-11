import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:lifestylescreening/healthpoint_icons.dart';
import 'package:lifestylescreening/models/firebase_user.dart';
import 'package:lifestylescreening/widgets/buttons/confirm_grey_button.dart';
import 'package:lifestylescreening/widgets/buttons/confirm_orange_button.dart';
import 'package:lifestylescreening/widgets/colors/color_theme.dart';
import 'package:lifestylescreening/widgets/text/h1_text.dart';

class BluetoothDevicePage extends StatefulWidget {
  BluetoothDevicePage({Key? key, required this.device, required this.user})
      : super(key: key);
  final BluetoothDevice device;
  final AppUser user;

  @override
  _BluetoothDevicePageState createState() => _BluetoothDevicePageState();
}

class _BluetoothDevicePageState extends State<BluetoothDevicePage> {
  bool weightConfirmed = false;
  bool isNotifying = false;
  bool connected = false;
  List<String> values = [];
  double? weight;

  void dispose() {
    widget.device.disconnect();
    super.dispose();
  }

  _setNotify(BluetoothCharacteristic characteristic, bool value) async {
    await characteristic.setNotifyValue(value).then((v) {
      isNotifying = value;
    });
  }

  _getValue(List<BluetoothService> serviceList) {
    List<BluetoothCharacteristic> characteristics = [];
    BluetoothCharacteristic? _characteristic;

    if (serviceList.isEmpty) {
      return Container(
        height: MediaQuery.of(context).size.height / 2.5,
        child: Card(child: Center(child: CircularProgressIndicator())),
      );
    }

    for (var i = 0; i < serviceList.length; i++) {
      characteristics.addAll(serviceList[i].characteristics);
    }

    for (var i = 0; i < characteristics.length; i++) {
      if (characteristics[i].properties.notify) {
        _characteristic = characteristics[i];
        break;
      }
    }

    if (_characteristic == null) {
      return Text("Kan data niet uitlezen");
    } else {
      return StreamBuilder<List<int>>(
        stream: _characteristic.value,
        initialData: _characteristic.lastValue,
        builder: (context, snapshot) {
          if (!_characteristic!.isNotifying) {
            _setNotify(_characteristic, true);
          }
          return Container(
            height: MediaQuery.of(context).size.height / 2.5,
            width: MediaQuery.of(context).size.width,
            child: Card(
              child: getWeight(snapshot.data!),
            ),
          );
        },
      );
    }
  }

  Widget getWeight(List<int> package) {
    if (package.isNotEmpty) {
      values = [];
      package.forEach((element) {
        values.add(element.toRadixString(16));
      });

      if (values[4] == '1') {
        weightConfirmed = true;
        weight = int.parse(values[5] + values[6], radix: 16) / 10;
      }
    }

    if (isNotifying) {
      return Container(
        margin: EdgeInsets.only(left: 50, right: 50),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            weight != null
                ? H1Text(
                    text: weight.toString() + " KG",
                  )
                : LinearProgressIndicator(
                    backgroundColor: ColorTheme.lightOrange,
                  ),
            SizedBox(height: 50),
            weight != null
                ? ConfirmOrangeButton(
                    onTap: () => Navigator.of(context).pop(weight),
                    text: "Bevestig",
                  )
                : ConfirmGreyButton(text: "Bevestig", onTap: null),
          ],
        ),
      );
    } else {
      return Container();
    }
  }

  Widget build(BuildContext context) {
    List<BluetoothService> services = [];

    return Scaffold(
      appBar: AppBar(
        title: H1Text(text: widget.device.name),
        backgroundColor: Colors.white,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(HealthpointIcons.arrowLeftIcon),
          color: Theme.of(context).primaryColor,
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: StreamBuilder<BluetoothDeviceState>(
          stream: widget.device.state,
          initialData: BluetoothDeviceState.connecting,
          builder: (context, snapshot) {
            if (snapshot.data == BluetoothDeviceState.connected ||
                weightConfirmed == true) {
              connected = snapshot.data == BluetoothDeviceState.connected;
              return FutureBuilder<List<BluetoothService>>(
                future: widget.device.discoverServices(),
                initialData: [],
                builder: (context, snapshot) {
                  if (snapshot.data != null) {
                    services = snapshot.data!;
                  }
                  return Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          padding: EdgeInsets.all(15.0),
                          alignment: Alignment.bottomLeft,
                          child: H1Text(
                            text: 'Uw resultaat',
                          ),
                        ),
                        _getValue(services),
                      ],
                    ),
                  );
                },
              );
            }
            return Center(child: CircularProgressIndicator());
          }),
    );
  }
}
