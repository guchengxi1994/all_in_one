import 'package:all_in_one/layout/components/sidebar_item.dart';
import 'package:all_in_one/layout/notifiers/sidebar_notifier.dart';
import 'package:all_in_one/layout/styles.dart';
import 'package:all_in_one/styles/app_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AnimatedSidebar extends ConsumerStatefulWidget {
  const AnimatedSidebar({super.key, required this.outerController});
  final AnimationController outerController;

  @override
  ConsumerState<AnimatedSidebar> createState() => _AnimatedSidebarState();
}

class _AnimatedSidebarState extends ConsumerState<AnimatedSidebar>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    duration: Duration(milliseconds: LayoutStyle.duration),
    vsync: this,
  );
  late final Animation<double> _animation = Tween<double>(
          begin: LayoutStyle.sidebarCollapse, end: LayoutStyle.sidebarExpand)
      .animate(_controller);

  late double width = _animation.value;

  @override
  void initState() {
    super.initState();
    _controller.addListener(() {
      setState(() {
        width = _animation.value;
      });
      if (width == LayoutStyle.sidebarExpand) {
        ref.read(sidebarProvider.notifier).changeStatus(true);
      }

      if (width == LayoutStyle.sidebarCollapse) {
        ref.read(sidebarProvider.notifier).changeStatus(false);
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: _animation.value,
      child: MouseRegion(
        onEnter: (event) {
          _controller.forward();
          widget.outerController.forward();
        },
        onExit: (event) {
          _controller.reverse();
          widget.outerController.reverse();
        },
        child: SizeTransition(
          sizeFactor: _animation,
          axis: Axis.horizontal,
          child: Container(
            height: double.infinity,
            width: _animation.value,
            // color: Colors.red,
            decoration: const BoxDecoration(color: Colors.white, boxShadow: [
              BoxShadow(
                color: AppStyle.black,
                offset: Offset(0, 4),
                blurRadius: 10,
                spreadRadius: 3,
              )
            ]),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SidebarItemWidget(
                    item: SidebarItem(
                        icon: "assets/icons/dashboard.png",
                        index: 0,
                        name: "Dashboard",
                        inActiveIcon: "assets/icons/idashboard.png")),
                SidebarItemWidget(
                    item: SidebarItem(
                        icon: "assets/icons/toolbox.png",
                        index: 1,
                        name: "Toolbox",
                        inActiveIcon: "assets/icons/itoolbox.png"))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
