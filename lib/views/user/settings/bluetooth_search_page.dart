import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:lifestylescreening/healthpoint_icons.dart';
import 'package:lifestylescreening/models/firebase_user.dart';
import 'package:lifestylescreening/views/user/settings/bluetooth_device_page.dart';
import 'package:lifestylescreening/widgets/buttons/ghost_orange_button.dart';
import 'package:lifestylescreening/widgets/colors/color_theme.dart';
import 'package:lifestylescreening/widgets/text/body_text.dart';
import 'package:lifestylescreening/widgets/text/h1_text.dart';
import 'package:lifestylescreening/widgets/text/h2_text.dart';

class BluetoothSearchPage extends StatefulWidget {
  BluetoothSearchPage({required this.user});

  final AppUser user;

  @override
  _BluetoothSearchPageState createState() => _BluetoothSearchPageState();
}

class _BluetoothSearchPageState extends State<BluetoothSearchPage> {
  @override
  void initState() {
    FlutterBlue.instance.startScan();
    super.initState();
  }

  isScanning() async {
    if (!await FlutterBlue.instance.isScanning.isEmpty) {
      await FlutterBlue.instance.stopScan();
    }
  }

  @override
  void dispose() {
    isScanning();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: H1Text(text: "Vind Bluetooth apparaat"),
        backgroundColor: Colors.white,
        centerTitle: true,
        leading: StreamBuilder<bool>(
          stream: FlutterBlue.instance.isScanning,
          initialData: false,
          builder: (c, snapshot) {
            return IconButton(
              icon: Icon(HealthpointIcons.arrowLeftIcon),
              color: Theme.of(context).primaryColor,
              onPressed: () {
                if (snapshot.hasData) {
                  FlutterBlue.instance.stopScan();
                }
                Navigator.of(context).pop();
              },
            );
          },
        ),
      ),
      body: Container(
        margin: EdgeInsets.fromLTRB(10, 30, 10, 10),
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
            color: ColorTheme.extraLightGreen,
            border: Border.all(
              color: Theme.of(context).primaryColor,
            ),
            borderRadius: BorderRadius.circular(8)),
        child: StreamBuilder<BluetoothState>(
          stream: FlutterBlue.instance.state,
          initialData: BluetoothState.unknown,
          builder: (c, snapshot) {
            if (snapshot.data == BluetoothState.on) {
              return FindDevicesScreen(user: widget.user);
            }
            return BluetoothOffScreen();
          },
        ),
      ),
    );
  }
}

// CA 10 0F 01 00 | 02 B9 | 00 00 00 00 00 00 00 00 00 00 00 A5
// CA 10 0F 01 01 03 14 00 00 00 00 00 00 00 00 00 00 00 08| 788	2048/ 8		+: 796	-: 780
// CA 10 0F 01 01 03 07 00 00 00 00 00 00 00 00 00 00 00 1B| 775	6912/ 27	+: 802	-: 748
// CA 10 0F 01 01 00 FA 00 00 00 00 00 00 00 00 00 00 00 E5| 250	58624/ 229	+: 479
// CA 10 0F 01 01 03 0B 00 00 00 00 00 00 00 00 00 00 00 17| 779	5888/ 23
// CA 10 0F 01 01 03 00 00 00 00 00 00 00 00 00 00 00 00 1C| 768	7168/ 28
// CA 10 0F 01 01 00 BA 00 00 00 00 00 00 00 00 00 00 00 A5| 186	42240/ 165
// CA 10 0F 01 01 00 76 00 00 00 00 00 00 00 00 00 00 00 69| 118	26880/ 105
// CA 10 0F 01 01 03 BC 00 00 00 00 00 00 00 00 00 00 00 A0| 956	40960/ 160
// CA 10 0F 01 01 00 D3 00 00 00 00 00 00 00 00 00 00 00 CC| 211	52224/ 204
// CA 10 0F 01 01 01 03 00 00 00 00 00 00 00 00 00 00 00 1D| 259 	7424/ 29
// CA 10 0F 01 01 02 FF 00 00 00 00 00 00 00 00 00 00 00 E2| 767	53504/ 209
// CA 10 0F 01 01 03 03 00 00 00 00 00 00 00 00 00 00 00 F1| 771	61696/ 241

class BluetoothOffScreen extends StatelessWidget {
  const BluetoothOffScreen({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Icon(
            Icons.bluetooth_disabled,
            size: 200.0,
            color: ColorTheme.accentOrange,
          ),
          H2Text(
            text: 'Bluetooth is uitgeschakeld.',
          ),
        ],
      ),
    );
  }
}

class FindDevicesScreen extends StatelessWidget {
  final AppUser? user;
  const FindDevicesScreen({this.user});

  List<ScanResultTile> _getDevices(List<ScanResult> devices, context) {
    List<ScanResultTile> results = [];

    devices.forEach(
      (element) {
        if (element.device.name.isNotEmpty &&
            element.advertisementData.connectable) {
          results.add(
            ScanResultTile(
              result: element,
              onTap: () => Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) {
                    element.device.connect();
                    return BluetoothDevicePage(
                      device: element.device,
                      user: user!,
                    );
                  },
                ),
              ).then((value) => Navigator.of(context).pop(value)),
            ),
          );
        }
      },
    );

    return results;
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: StreamBuilder<List<ScanResult>>(
        stream: FlutterBlue.instance.scanResults,
        initialData: [],
        builder: (c, snapshot) {
          List<ScanResultTile> results = _getDevices(snapshot.data!, context);
          return results.isNotEmpty
              ? Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: results,
                )
              : Align(
                  heightFactor: 2,
                  alignment: Alignment.center,
                  child: H1Text(
                    text: "Geen apparaten gevonden",
                  ),
                );
        },
      ),
    );
  }
}

class ScanResultTile extends StatelessWidget {
  const ScanResultTile({Key? key, this.result, this.onTap}) : super(key: key);

  final ScanResult? result;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: BodyText(text: result!.device.name),
      trailing: GhostOrangeButton(
        text: "Connect",
        onTap: (result!.advertisementData.connectable) ? onTap : null,
      ),
    );
  }
}

// import 'dart:async';
// import 'dart:math';

// import 'package:flutter/material.dart';
// import 'package:flutter_blue/flutter_blue.dart';

// class FlutterBlueApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       color: Colors.lightBlue,
//       home: StreamBuilder<BluetoothState>(
//           stream: FlutterBlue.instance.state,
//           initialData: BluetoothState.unknown,
//           builder: (c, snapshot) {
//             final state = snapshot.data;
//             if (state == BluetoothState.on) {
//               return FindDevicesScreen();
//             }
//             return BluetoothOffScreen(state: state);
//           }),
//     );
//   }
// }

// class BluetoothOffScreen extends StatelessWidget {
//   const BluetoothOffScreen({Key? key, this.state}) : super(key: key);

//   final BluetoothState? state;

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.lightBlue,
//       body: Center(
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: <Widget>[
//             Icon(
//               Icons.bluetooth_disabled,
//               size: 200.0,
//               color: Colors.white54,
//             ),
//             Text(
//               'Bluetooth Adapter is ${state != null ? state.toString().substring(15) : 'not available'}.',
//               style: Theme.of(context)
//                   .primaryTextTheme
//                   .subhead
//                   ?.copyWith(color: Colors.white),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// class FindDevicesScreen extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Find Devices'),
//       ),
//       body: RefreshIndicator(
//         onRefresh: () =>
//             FlutterBlue.instance.startScan(timeout: Duration(seconds: 4)),
//         child: SingleChildScrollView(
//           child: Column(
//             children: <Widget>[
//               StreamBuilder<List<BluetoothDevice>>(
//                 stream: Stream.periodic(Duration(seconds: 2))
//                     .asyncMap((_) => FlutterBlue.instance.connectedDevices),
//                 initialData: [],
//                 builder: (c, snapshot) => Column(
//                   children: snapshot.data!
//                       .map((d) => ListTile(
//                             title: Text(d.name),
//                             subtitle: Text(d.id.toString()),
//                             trailing: StreamBuilder<BluetoothDeviceState>(
//                               stream: d.state,
//                               initialData: BluetoothDeviceState.disconnected,
//                               builder: (c, snapshot) {
//                                 if (snapshot.data ==
//                                     BluetoothDeviceState.connected) {
//                                   return RaisedButton(
//                                     child: Text('OPEN'),
//                                     onPressed: () => Navigator.of(context).push(
//                                         MaterialPageRoute(
//                                             builder: (context) =>
//                                                 DeviceScreen(device: d))),
//                                   );
//                                 }
//                                 return Text(snapshot.data.toString());
//                               },
//                             ),
//                           ))
//                       .toList(),
//                 ),
//               ),
//               StreamBuilder<List<ScanResult>>(
//                 stream: FlutterBlue.instance.scanResults,
//                 initialData: [],
//                 builder: (c, snapshot) => Column(
//                   children: snapshot.data!
//                       .map(
//                         (r) => ScanResultTile(
//                           result: r,
//                           onTap: () => Navigator.of(context)
//                               .push(MaterialPageRoute(builder: (context) {
//                             r.device.connect();
//                             return DeviceScreen(device: r.device);
//                           })),
//                         ),
//                       )
//                       .toList(),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//       floatingActionButton: StreamBuilder<bool>(
//         stream: FlutterBlue.instance.isScanning,
//         initialData: false,
//         builder: (c, snapshot) {
//           if (snapshot.data!) {
//             return FloatingActionButton(
//               child: Icon(Icons.stop),
//               onPressed: () => FlutterBlue.instance.stopScan(),
//               backgroundColor: Colors.red,
//             );
//           } else {
//             return FloatingActionButton(
//                 child: Icon(Icons.search),
//                 onPressed: () => FlutterBlue.instance
//                     .startScan(timeout: Duration(seconds: 4)));
//           }
//         },
//       ),
//     );
//   }
// }

// class DeviceScreen extends StatelessWidget {
//   const DeviceScreen({Key? key, required this.device}) : super(key: key);

//   final BluetoothDevice device;

//   List<int> _getRandomBytes() {
//     final math = Random();
//     return [
//       math.nextInt(255),
//       math.nextInt(255),
//       math.nextInt(255),
//       math.nextInt(255)
//     ];
//   }

//   List<Widget> _buildServiceTiles(List<BluetoothService> services) {
//     return services
//         .map(
//           (s) => ServiceTile(
//             service: s,
//             characteristicTiles: s.characteristics
//                 .map(
//                   (c) => CharacteristicTile(
//                     characteristic: c,
//                     onReadPressed: () => c.read(),
//                     onWritePressed: () async {
//                       await c.write(_getRandomBytes(), withoutResponse: true);
//                       await c.read();
//                     },
//                     onNotificationPressed: () async {
//                       await c.setNotifyValue(!c.isNotifying);
//                     },
//                     descriptorTiles: c.descriptors
//                         .map(
//                           (d) => DescriptorTile(
//                             descriptor: d,
//                             onReadPressed: () => d.read(),
//                             onWritePressed: () => d.write(_getRandomBytes()),
//                           ),
//                         )
//                         .toList(),
//                   ),
//                 )
//                 .toList(),
//           ),
//         )
//         .toList();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(device.name),
//         actions: <Widget>[
//           StreamBuilder<BluetoothDeviceState>(
//             stream: device.state,
//             initialData: BluetoothDeviceState.connecting,
//             builder: (c, snapshot) {
//               VoidCallback? onPressed;
//               String text;
//               switch (snapshot.data) {
//                 case BluetoothDeviceState.connected:
//                   onPressed = () => device.disconnect();
//                   text = 'DISCONNECT';
//                   break;
//                 case BluetoothDeviceState.disconnected:
//                   onPressed = () => device.connect();
//                   text = 'CONNECT';
//                   break;
//                 default:
//                   onPressed = null;
//                   text = snapshot.data.toString().substring(21).toUpperCase();
//                   break;
//               }
//               return FlatButton(
//                   onPressed: onPressed,
//                   child: Text(
//                     text,
//                     style: Theme.of(context)
//                         .primaryTextTheme
//                         .button
//                         ?.copyWith(color: Colors.white),
//                   ));
//             },
//           )
//         ],
//       ),
//       body: SingleChildScrollView(
//         child: Column(
//           children: <Widget>[
//             StreamBuilder<BluetoothDeviceState>(
//               stream: device.state,
//               initialData: BluetoothDeviceState.connecting,
//               builder: (c, snapshot) => ListTile(
//                 leading: (snapshot.data == BluetoothDeviceState.connected)
//                     ? Icon(Icons.bluetooth_connected)
//                     : Icon(Icons.bluetooth_disabled),
//                 title: Text(
//                     'Device is ${snapshot.data.toString().split('.')[1]}.'),
//                 subtitle: Text('${device.id}'),
//                 trailing: StreamBuilder<bool>(
//                   stream: device.isDiscoveringServices,
//                   initialData: false,
//                   builder: (c, snapshot) => IndexedStack(
//                     index: snapshot.data! ? 1 : 0,
//                     children: <Widget>[
//                       IconButton(
//                         icon: Icon(Icons.refresh),
//                         onPressed: () => device.discoverServices(),
//                       ),
//                       IconButton(
//                         icon: SizedBox(
//                           child: CircularProgressIndicator(
//                             valueColor: AlwaysStoppedAnimation(Colors.grey),
//                           ),
//                           width: 18.0,
//                           height: 18.0,
//                         ),
//                         onPressed: null,
//                       )
//                     ],
//                   ),
//                 ),
//               ),
//             ),
//             StreamBuilder<int>(
//               stream: device.mtu,
//               initialData: 0,
//               builder: (c, snapshot) => ListTile(
//                 title: Text('MTU Size'),
//                 subtitle: Text('${snapshot.data} bytes'),
//                 trailing: IconButton(
//                   icon: Icon(Icons.edit),
//                   onPressed: () => device.requestMtu(223),
//                 ),
//               ),
//             ),
//             StreamBuilder<List<BluetoothService>>(
//               stream: device.services,
//               initialData: [],
//               builder: (c, snapshot) {
//                 return Column(
//                   children: _buildServiceTiles(snapshot.data!),
//                 );
//               },
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// class ScanResultTile extends StatelessWidget {
//   const ScanResultTile({Key? key, required this.result, this.onTap})
//       : super(key: key);

//   final ScanResult result;
//   final VoidCallback? onTap;

//   Widget _buildTitle(BuildContext context) {
//     if (result.device.name.length > 0) {
//       return Column(
//         mainAxisAlignment: MainAxisAlignment.start,
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: <Widget>[
//           Text(
//             result.device.name,
//             overflow: TextOverflow.ellipsis,
//           ),
//           Text(
//             result.device.id.toString(),
//             style: Theme.of(context).textTheme.caption,
//           )
//         ],
//       );
//     } else {
//       return Text(result.device.id.toString());
//     }
//   }

//   Widget _buildAdvRow(BuildContext context, String title, String value) {
//     return Padding(
//       padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
//       child: Row(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: <Widget>[
//           Text(title, style: Theme.of(context).textTheme.caption),
//           SizedBox(
//             width: 12.0,
//           ),
//           Expanded(
//             child: Text(
//               value,
//               style: Theme.of(context)
//                   .textTheme
//                   .caption
//                   ?.apply(color: Colors.black),
//               softWrap: true,
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   String getNiceHexArray(List<int> bytes) {
//     return '[${bytes.map((i) => i.toRadixString(16).padLeft(2, '0')).join(', ')}]'
//         .toUpperCase();
//   }

//   String getNiceManufacturerData(Map<int, List<int>> data) {
//     if (data.isEmpty) {
//       return 'N/A';
//     }
//     List<String> res = [];
//     data.forEach((id, bytes) {
//       res.add(
//           '${id.toRadixString(16).toUpperCase()}: ${getNiceHexArray(bytes)}');
//     });
//     return res.join(', ');
//   }

//   String getNiceServiceData(Map<String, List<int>> data) {
//     if (data.isEmpty) {
//       return 'N/A';
//     }
//     List<String> res = [];
//     data.forEach((id, bytes) {
//       res.add('${id.toUpperCase()}: ${getNiceHexArray(bytes)}');
//     });
//     return res.join(', ');
//   }

//   @override
//   Widget build(BuildContext context) {
//     return ExpansionTile(
//       title: _buildTitle(context),
//       leading: Text(result.rssi.toString()),
//       trailing: RaisedButton(
//         child: Text('CONNECT'),
//         color: Colors.black,
//         textColor: Colors.white,
//         onPressed: (result.advertisementData.connectable) ? onTap : null,
//       ),
//       children: <Widget>[
//         _buildAdvRow(
//             context, 'Complete Local Name', result.advertisementData.localName),
//         _buildAdvRow(context, 'Tx Power Level',
//             '${result.advertisementData.txPowerLevel ?? 'N/A'}'),
//         _buildAdvRow(context, 'Manufacturer Data',
//             getNiceManufacturerData(result.advertisementData.manufacturerData)),
//         _buildAdvRow(
//             context,
//             'Service UUIDs',
//             (result.advertisementData.serviceUuids.isNotEmpty)
//                 ? result.advertisementData.serviceUuids.join(', ').toUpperCase()
//                 : 'N/A'),
//         _buildAdvRow(context, 'Service Data',
//             getNiceServiceData(result.advertisementData.serviceData)),
//       ],
//     );
//   }
// }

// class ServiceTile extends StatelessWidget {
//   final BluetoothService service;
//   final List<CharacteristicTile> characteristicTiles;

//   const ServiceTile(
//       {Key? key, required this.service, required this.characteristicTiles})
//       : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     if (characteristicTiles.length > 0) {
//       return ExpansionTile(
//         title: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: <Widget>[
//             Text('Service'),
//             Text('0x${service.uuid.toString().toUpperCase().substring(4, 8)}',
//                 style: Theme.of(context).textTheme.body1?.copyWith(
//                     color: Theme.of(context).textTheme.caption?.color))
//           ],
//         ),
//         children: characteristicTiles,
//       );
//     } else {
//       return ListTile(
//         title: Text('Service'),
//         subtitle:
//             Text('0x${service.uuid.toString().toUpperCase().substring(4, 8)}'),
//       );
//     }
//   }
// }

// class CharacteristicTile extends StatelessWidget {
//   final BluetoothCharacteristic characteristic;
//   final List<DescriptorTile> descriptorTiles;
//   final VoidCallback? onReadPressed;
//   final VoidCallback? onWritePressed;
//   final VoidCallback? onNotificationPressed;

//   const CharacteristicTile(
//       {Key? key,
//       required this.characteristic,
//       required this.descriptorTiles,
//       this.onReadPressed,
//       this.onWritePressed,
//       this.onNotificationPressed})
//       : super(key: key);

//   convertToHext(List<int> list) {
//     List<String> stringList = [];

//     list.forEach((element) {
//       stringList.add(element.toRadixString(16));
//     });
//     return stringList;
//   }

//   @override
//   Widget build(BuildContext context) {
//     return StreamBuilder<List<int>>(
//       stream: characteristic.value,
//       initialData: characteristic.lastValue,
//       builder: (c, snapshot) {
//         final value = convertToHext(snapshot.data!);
//         return ExpansionTile(
//           title: ListTile(
//             title: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: <Widget>[
//                 Text('Characteristic'),
//                 Text(
//                     '0x${characteristic.uuid.toString().toUpperCase().substring(4, 8)}',
//                     style: Theme.of(context).textTheme.body1?.copyWith(
//                         color: Theme.of(context).textTheme.caption?.color))
//               ],
//             ),
//             subtitle: Text(value.toString()),
//             contentPadding: EdgeInsets.all(0.0),
//           ),
//           trailing: Row(
//             mainAxisSize: MainAxisSize.min,
//             children: <Widget>[
//               IconButton(
//                 icon: Icon(
//                   Icons.file_download,
//                   color: Theme.of(context).iconTheme.color?.withOpacity(0.5),
//                 ),
//                 onPressed: onReadPressed,
//               ),
//               IconButton(
//                 icon: Icon(Icons.file_upload,
//                     color: Theme.of(context).iconTheme.color?.withOpacity(0.5)),
//                 onPressed: onWritePressed,
//               ),
//               IconButton(
//                 icon: Icon(
//                     characteristic.isNotifying
//                         ? Icons.sync_disabled
//                         : Icons.sync,
//                     color: Theme.of(context).iconTheme.color?.withOpacity(0.5)),
//                 onPressed: onNotificationPressed,
//               )
//             ],
//           ),
//           children: descriptorTiles,
//         );
//       },
//     );
//   }
// }

// class DescriptorTile extends StatelessWidget {
//   final BluetoothDescriptor descriptor;
//   final VoidCallback? onReadPressed;
//   final VoidCallback? onWritePressed;

//   const DescriptorTile(
//       {Key? key,
//       required this.descriptor,
//       this.onReadPressed,
//       this.onWritePressed})
//       : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return ListTile(
//       title: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: <Widget>[
//           Text('Descriptor'),
//           Text('0x${descriptor.uuid.toString().toUpperCase().substring(4, 8)}',
//               style: Theme.of(context)
//                   .textTheme
//                   .body1
//                   ?.copyWith(color: Theme.of(context).textTheme.caption?.color))
//         ],
//       ),
//       subtitle: StreamBuilder<List<int>>(
//         stream: descriptor.value,
//         initialData: descriptor.lastValue,
//         builder: (c, snapshot) => Text(snapshot.data.toString()),
//       ),
//       trailing: Row(
//         mainAxisSize: MainAxisSize.min,
//         children: <Widget>[
//           IconButton(
//             icon: Icon(
//               Icons.file_download,
//               color: Theme.of(context).iconTheme.color?.withOpacity(0.5),
//             ),
//             onPressed: onReadPressed,
//           ),
//           IconButton(
//             icon: Icon(
//               Icons.file_upload,
//               color: Theme.of(context).iconTheme.color?.withOpacity(0.5),
//             ),
//             onPressed: onWritePressed,
//           )
//         ],
//       ),
//     );
//   }
// }

// class AdapterStateTile extends StatelessWidget {
//   const AdapterStateTile({Key? key, required this.state}) : super(key: key);

//   final BluetoothState state;

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       color: Colors.redAccent,
//       child: ListTile(
//         title: Text(
//           'Bluetooth adapter is ${state.toString().substring(15)}',
//           style: Theme.of(context).primaryTextTheme.subhead,
//         ),
//         trailing: Icon(
//           Icons.error,
//           color: Theme.of(context).primaryTextTheme.subhead?.color,
//         ),
//       ),
//     );
//   }
// }
