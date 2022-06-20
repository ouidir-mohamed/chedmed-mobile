import 'package:chedmed/blocs/home_bloc.dart';
import 'package:chedmed/ui/common/app_theme.dart';
import 'package:chedmed/utils/language_helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class RangeSelection extends StatefulWidget {
  const RangeSelection({Key? key}) : super(key: key);

  @override
  State<RangeSelection> createState() => _RangeSelectionState();
}

class _RangeSelectionState extends State<RangeSelection> {
  double _maxDistance = 60;
  bool _moreThan100 = false;

  @override
  void initState() {
    homeBloc.getMaxDistance.listen((event) {
      if (mounted) handleDistanceChange(event);
    });
    super.initState();
  }

  handleDistanceChange(double distance) {
    setState(() {
      _maxDistance = distance;
      _moreThan100 = distance > 100;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 20),
        child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 3),
                child: Text(getTranslation.distance,
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              ),
              Container(
                width: double.infinity,
                child: CupertinoSlider(
                  // inactiveColor: AppTheme.secondaryColor(context).withAlpha(5),
                  activeColor: AppTheme.secondaryColor(context),
                  thumbColor: AppTheme.secondaryColor(context),
                  value: _maxDistance,
                  min: 10,
                  max: 110,
                  divisions: 10,
                  //label: _maxDistance.toInt().toString() + " Km",
                  onChanged: (d) {
                    homeBloc.setMaxDistance(d);
                    handleDistanceChange(d);
                  },
                ),
              ),
              Text(
                _moreThan100
                    ? getTranslation.more_than_100
                    : getTranslation.km_var(_maxDistance.toInt().toString()),
                style: TextStyle(fontSize: 15),
              ),
            ]));
  }
}
