import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nextbussg/components/more/rename_favorites/bottom_sheets.dart';
import 'package:nextbussg/components/core/mrt_stations.dart';
import 'package:nextbussg/utils/extensions.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:nextbussg/components/core/buttons/back_button.dart';
import 'package:nextbussg/components/core/buttons/button.dart';
import 'package:nextbussg/components/home/bus_stop_expansion_tile.dart';
import 'package:nextbussg/components/search/stop_page/stop_servies_overview.dart';
import 'package:nextbussg/components/core/title_text.dart';
import 'package:nextbussg/services/renameFavorites.dart';
import 'package:nextbussg/styles/values.dart';
import 'package:nextbussg/utils/url.dart';
import 'package:nextbussg/components/core/page_template.dart';
import 'package:nextbussg/components/core/space.dart';
import 'package:url_launcher/url_launcher.dart';

class StopOverviewPage extends StatelessWidget {
  final String code;
  StopOverviewPage({this.code});

  @override
  Widget build(BuildContext context) {
    // var data =
    // final String name =

    return Scaffold(
      body: FutureBuilder(
        future: _getStopData(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            String name = snapshot.data['name'];
            String road = snapshot.data['road'];
            List services = snapshot.data['services'];
            List mrtStations = snapshot.data['mrt_stations'];
            double lat = snapshot.data['coords']['lat'];
            double lon = snapshot.data['coords']['lon'];

            return PageTemplate(
              showBackButton: true,
              children: [
                // name of bus stop
                TitleText(
                  title: name,
                ).sliverToBoxAdapter(),

                // road and stop code
                Text("$road – $code").sliverToBoxAdapter(),

                if (mrtStations.isNotEmpty)
                  Spacing(height: Values.marginBelowTitle).sliver(),

                if (mrtStations.isNotEmpty)
                  MRTStations(
                    stations: mrtStations,
                  ).sliverToBoxAdapter(),

                Spacing(height: Values.marginBelowTitle * 1.5).sliver(),

                // showing all services
                StopServicesOverview(
                  services: services,
                ).sliverToBoxAdapter(),
                // Text('mrt stations').sliverToBoxAdapter(),

                Spacing(height: Values.marginBelowTitle * 1.5).sliver(),

                // timings panel
                Text("Bus arrival timings:").sliverToBoxAdapter(),
                BusStopExpansionPanel(
                  name: name,
                  code: code,
                  services: services,
                  initialyExpanded: false,
                  mrtStations: [],
                ).sliverToBoxAdapter(),

                Spacing(height: Values.marginBelowTitle * 2).sliver(),

                // button to allow rename
                Button(
                  text: "Rename",
                  // iconData: FontAwesomeIcons.directions,
                  // onTap: () => RenameFavoritesService.rename(context, code, newName),
                  onTap: () => RenameFavoritesBottomSheets.bs(context, code, name),
                ).sliverToBoxAdapter(),

                Spacing(height: Values.marginBelowTitle).sliver(),

                // showing directions
                Button(
                  text: "Directions to bus stop",
                  fill: true,
                  // iconData: FontAwesomeIcons.directions,
                  onTap: () {
                    String url = "https://maps.apple.com/?q=$lat,$lon";
                    openUrl(url);
                  },
                ).sliverToBoxAdapter()
              ],
            );
          } else {
            return Text('Loading');
          }
        },
      ),
    );
  }

  _getStopData() async {
    String jsonString = await rootBundle.loadString('assets/bus_stops.json');
    Map stopData = json.decode(jsonString)[code];

    // print(stopData);
    return stopData;
  }
}