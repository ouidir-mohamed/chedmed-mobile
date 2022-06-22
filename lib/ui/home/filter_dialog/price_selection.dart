import 'package:chedmed/blocs/home_bloc.dart';
import 'package:flutter/material.dart';

import '../../common/inputs.dart';

class PriceSelection extends StatefulWidget {
  const PriceSelection({Key? key}) : super(key: key);

  @override
  State<PriceSelection> createState() => _PriceSelectionState();
}

class _PriceSelectionState extends State<PriceSelection> {
  TextEditingController minPriceController = TextEditingController();
  TextEditingController maxPriceController = TextEditingController();

  @override
  void initState() {
    homeBloc.getMinPrice.listen((event) {
      minPriceController.text = event != null ? event.toInt().toString() : "";
    });
    homeBloc.getMaxPrice.listen((event) {
      maxPriceController.text = event != null ? event.toInt().toString() : "";
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5),
                  child: Text("Prix min (DA)",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                ),
                TextFormField(
                  keyboardType: TextInputType.number,
                  onChanged: homeBloc.setMinPrice,
                  controller: minPriceController,
                  decoration: MyInputDecoration(title: "", context: context),
                ),
              ],
            ),
          ),
          Padding(padding: EdgeInsets.symmetric(horizontal: 20)),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5),
                  child: Text("Prix max (DA)",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                ),
                TextFormField(
                  onChanged: homeBloc.setMaxPrice,
                  controller: maxPriceController,
                  keyboardType: TextInputType.number,
                  decoration: MyInputDecoration(title: "", context: context),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
