import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

///Scrollable bottom bar widget
class ScrollableBottomBar extends StatefulWidget {
  final Widget child;
  final ScrollController? scrollController;
  final bool showButtonOverride;
  final double kBottomNavigationBarCustomHeight;
  const ScrollableBottomBar(
      {super.key,
      required this.child,
      this.scrollController,
      this.showButtonOverride = false,
      this.kBottomNavigationBarCustomHeight = 60});

  @override
  State<ScrollableBottomBar> createState() => _ScrollableBottomBarState();
}

class _ScrollableBottomBarState extends State<ScrollableBottomBar> {
  bool _isVisible = false;
  bool _isBottomBarAnimated = false;
  bool _isScrolling = false;

  @override
  void initState() {
    _isBottomBarAnimated = widget.scrollController != null;
    if (widget.scrollController != null &&
        widget.scrollController!.positions.length > 0) {
      // widget.scrollController.
      //checking the positions iterable makes sure that the scrollController is not attached when
      //UI is loading the data. Ex. Sitediary > Timesheets
      widget.scrollController!.addListener(_listen);
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (widget.scrollController!.position.maxScrollExtent <= 0 ||
            widget.showButtonOverride) {
          setState(() {
            _isBottomBarAnimated = false;
          });
        } else {
          if (widget.scrollController!.offset <=
                  widget.scrollController!.position.minScrollExtent &&
              widget.scrollController!.position.outOfRange) {
            setState(() {
              _isBottomBarAnimated = false;
            });
          } else {
            setState(() {
              _isBottomBarAnimated = true;
            });
          }
        }
      });
    } else {
      setState(() {
        _isBottomBarAnimated = false;
      });
    }
    super.initState();
  }

  @override
  void didUpdateWidget(covariant ScrollableBottomBar oldWidget) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_isScrolling) {
        if (widget.scrollController != null &&
            widget.scrollController!.positions.length > 0) {
          if (widget.scrollController!.position.maxScrollExtent <= 0 ||
              widget.showButtonOverride) {
            setState(() {
              _isBottomBarAnimated = false;
            });
          } else {
            setState(() {
              _isBottomBarAnimated = true;
            });
          }
        } else {
          setState(() {
            _isBottomBarAnimated = false;
          });
        }
      }
    });
    super.didUpdateWidget(oldWidget);
  }

  void _listen() {
    final _direction = widget.scrollController?.position.userScrollDirection;

    if (_direction == ScrollDirection.forward) {
      _isScrolling = true;
      _hide();
    } else if (_direction == ScrollDirection.reverse) {
      _isScrolling = true;
      _show();
    }
  }

  void _show() {
    if (!_isVisible)
      setState(() {
        _isVisible = true;
      });
  }

  void _hide() {
    if (_isVisible) {
      setState(() {
        _isVisible = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return _isBottomBarAnimated
        ? AnimatedContainer(
            duration: const Duration(milliseconds: 500),
            color: Colors.white,
            alignment: Alignment.center,
            height: _isVisible ? widget.kBottomNavigationBarCustomHeight : 0.0,
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            // margin: const EdgeInsets.only(bottom: 0),
            child: widget.child,
          )
        : Container(
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.25),
                  blurRadius: 16,
                  offset: const Offset(0, 2), // changes position of shadow
                ),
              ],
            ),
            height: widget.kBottomNavigationBarCustomHeight + 10,
            alignment: Alignment.center,
            padding: const EdgeInsets.symmetric(horizontal: 15),
            // margin: const EdgeInsets.only(bottom: 8),
            child: widget.child,
          );
  }

  @override
  void dispose() {
    widget.scrollController?.removeListener(_listen);
    super.dispose();
  }
}
