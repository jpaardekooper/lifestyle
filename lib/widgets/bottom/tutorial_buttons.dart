import 'package:flutter/material.dart';
import 'package:lifestylescreening/healthpoint_icons.dart';
import 'package:lifestylescreening/widgets/buttons/confirm_orange_button.dart';
import 'package:lifestylescreening/widgets/text/h2_text.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class TutorialButtons extends StatelessWidget {
  const TutorialButtons(
      {this.onPressedBack,
      required this.onPressedNext,
      required this.canGoBack,
      this.enabled,
      this.spacing});
  final VoidCallback? onPressedBack;
  final VoidCallback onPressedNext;
  final bool canGoBack;
  final bool? enabled;
  final bool? spacing;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(
      alignment: Alignment.bottomCenter,
      padding: EdgeInsets.symmetric(
          vertical: kIsWeb && size.width < 900 ? 10 : 40,
          horizontal: size.width * 0.08),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(
            width: kIsWeb ? 200 : MediaQuery.of(context).size.width / 4,
            child: canGoBack
                ? ListTile(
                    autofocus: false,
                    contentPadding: const EdgeInsets.all(0),
                    onTap: onPressedBack,
                    title: Row(
                      children: [
                        Icon(
                          HealthpointIcons.arrowLeftIcon,
                          size: 18,
                          color: Theme.of(context).primaryColor,
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        H2Text(text: "terug"),
                      ],
                    ),
                  )
                : Container(),
          ),
          ConfirmOrangeButton(
            text: "Volgende",
            onTap: onPressedNext,
          ),
        ],
      ),
    );
  }
}
