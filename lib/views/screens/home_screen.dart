import 'package:custom_refresh_indicator/custom_refresh_indicator.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:resonate/controllers/rooms_controller.dart';

import '../../utils/enums/room_state.dart';
import '../widgets/room_tile.dart';

class HomeScreen extends StatelessWidget {
  RoomsController roomsController = Get.find<RoomsController>();

  @override
  Widget build(BuildContext context) {
    return GetBuilder<RoomsController>(
        builder: (roomsController) => (!roomsController.isLoading.value)
            ? SingleChildScrollView(
              child: CustomRefreshIndicator(
                  builder: MaterialIndicatorDelegate(
                    builder: (context, controller) {
                      return const Icon(
                        Icons.ac_unit,
                        color: Colors.amber,
                        size: 30,
                      );
                    },
                  ),
                  onRefresh: () async {
                    await roomsController.getRooms();
                  },
                  child: Column(
                    children: [
                      SizedBox(
                        height: Get.height * 0.015,
                      ),
                      ListView.builder(
                          shrinkWrap: true,
                          itemCount: roomsController.rooms.length,
                          itemBuilder: (ctx, index) {
                            var room = roomsController.rooms[index];
                            return RoomTile(
                              roomName: room["name"],
                              roomId: room["\$id"],
                              roomState: RoomState.live,
                              totalActiveMembers: room["totalParticipants"],
                              tags: room["tags"],
                              memberAvatarUrls: [
                                "https://avatars.githubusercontent.com/u/58695010?s=96&v=4",
                                "https://avatars.githubusercontent.com/u/41890434?v=4",
                                "https://avatars.githubusercontent.com/u/43133646?s=96&v=4",
                              ],
                            );
                          })
                    ],
                  ),
                ),
            )
            : Center(
                child: LoadingAnimationWidget.threeRotatingDots(color: Colors.amber, size: Get.pixelRatio*20),
              ));
  }
}
