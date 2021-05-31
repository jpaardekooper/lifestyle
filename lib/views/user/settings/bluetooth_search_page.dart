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
