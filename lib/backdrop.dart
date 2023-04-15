import 'package:flutter/material.dart';
import 'login.dart';
import 'model/product.dart';
 const double _kFlingVelocity = 2.0;

class Backdrop extends StatefulWidget{
  final Category currentCategory;
  final Widget frontLayer;
  final Widget backLayer;
  final Widget frontTitle;
  final Widget backTitle;

  Backdrop({
    required this.currentCategory,
    required this.frontLayer,
    required this.backLayer,
    required this.frontTitle,
    required this.backTitle,
    Key? key,
  }) : super(key:key);


  @override
  _BackdropState createState() => _BackdropState();
}

class _BackdropState extends State<Backdrop> with SingleTickerProviderStateMixin
     {
    final GlobalKey _backdropKey = GlobalKey(debugLabel: 'Backdrop');

    late AnimationController _controller;

    @override
    void didUpdateWidget(Backdrop old) {
      super.didUpdateWidget(old);

      if (widget.currentCategory != old.currentCategory) {
        _toggleBackdropLayerVisibility();
      } else if (!_frontLayerVisible) {
        _controller.fling(velocity: _kFlingVelocity);
      }
    }

    @override
    void initState() {
      super.initState();
      _controller = AnimationController(
          duration: const Duration(milliseconds: 300),
          value: 1.0,
          vsync: this,
      );
     }

     @override
     void dispose() {
      _controller.dispose();
      super.dispose();
     }

    bool get _frontLayerVisible {
      final AnimationStatus status = _controller.status;
      return status == AnimationStatus.completed ||
          status == AnimationStatus.forward;
    }

    void _toggleBackdropLayerVisibility() {
      _controller.fling(
          velocity: _frontLayerVisible ? -_kFlingVelocity : _kFlingVelocity);
    }

    // Widget _buildStack() {
    //   return Stack(
    //   key: _backdropKey,
    //   children: <Widget>[
    //     ExcludeSemantics(
    //         child: widget.backLayer
    //     ),
    //     _FrontLayer(child: widget.frontLayer),
    //   ],
    //   );
    //  }

    // TODO: Add BuildContext and BoxConstraints parameters to _buildStack (104)
    Widget _buildStack(BuildContext context, BoxConstraints constraints) {
      const double layerTitleHeight = 48.0;
      final Size layerSize = constraints.biggest;
      final double layerTop = layerSize.height - layerTitleHeight;

      // TODO: Create a RelativeRectTween Animation (104)
      Animation<RelativeRect> layerAnimation = RelativeRectTween(
        begin: RelativeRect.fromLTRB(
            0.0, layerTop, 0.0, layerTop - layerSize.height),
        end: const RelativeRect.fromLTRB(0.0, 0.0, 0.0, 0.0),
      ).animate(_controller.view);

      PositionedTransition(
        rect: layerAnimation,
        child: _FrontLayer(
          // TODO: Implement onTap property on _BackdropState (104)
          onTap: _toggleBackdropLayerVisibility,
          child: widget.frontLayer,
        ),
      );

      return Stack(
        key: _backdropKey,
        children: <Widget>[
          // TODO: Wrap backLayer in an ExcludeSemantics widget (104)
          ExcludeSemantics(
            child: widget.backLayer,
            excluding: _frontLayerVisible,
          ),
          // TODO: Add a PositionedTransition (104)
          PositionedTransition(
            rect: layerAnimation,
            child: _FrontLayer(
              // TODO: Implement onTap property on _BackdropState (104)
              child: widget.frontLayer,
            ),
          ),
        ],
      );
    }

  @override
  Widget build(BuildContext context) {
     var appBar = AppBar(
      elevation: 0.0,
      titleSpacing: 0.0,
       leading: IconButton(
         icon: const Icon(Icons.menu),
         onPressed: _toggleBackdropLayerVisibility,
       ),
       title:  _BackdropTitle(
       listenable: _controller.view,
       onPress: _toggleBackdropLayerVisibility,
       frontTitle: widget.frontTitle,
       backTitle: widget.backTitle,
     ),
         actions: [
          IconButton(onPressed: (){
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (BuildContext context) => LoginPage()),
            );
          },
          icon: Icon(Icons.search,
           semanticLabel: 'login',
         ),
          ),
        IconButton(onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (BuildContext context) => LoginPage()),
          );
        },
        icon: Icon(Icons.tune,
         semanticLabel: 'login',)
        )
     ],
     );
      return Scaffold(
       appBar: appBar,
        body: LayoutBuilder(builder: _buildStack),
  );
  }
}

class _FrontLayer extends StatelessWidget {
   const _FrontLayer ({
   Key? key,
     this.onTap,
     required this.child,
}) : super(key: key);
   final VoidCallback? onTap; // New code
   final Widget child;

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 16.0,
      shape: BeveledRectangleBorder(
        borderRadius: BorderRadius.only(topLeft: Radius.circular(47.0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          // TODO: Add a GestureDetector (104)
          GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: onTap,
            child: Container(
              height: 40.0,
              alignment: AlignmentDirectional.centerStart,
            ),
          ),
          Expanded(
            child: child,
          ),
        ],
      ),
      // Column(
      //   crossAxisAlignment: CrossAxisAlignment.stretch,
      //   children: <Widget>[
      //     Expanded(child: child,
      //     ),
      //   ],
      // ),
    );
  }
}


// TODO: Add _BackdropTitle class (104)
class _BackdropTitle extends AnimatedWidget {
  final void Function() onPress;
  final Widget frontTitle;
  final Widget backTitle;

  const _BackdropTitle({
    Key? key,
    required Animation<double> listenable,
    required this.onPress,
    required this.frontTitle,
    required this.backTitle,
  }) : _listenable = listenable,
        super(key: key, listenable: listenable);

  final Animation<double> _listenable;

  @override
  Widget build(BuildContext context) {
    final Animation<double> animation = _listenable;

    return DefaultTextStyle(
      style: Theme.of(context).textTheme.headline6!,
      softWrap: false,
      overflow: TextOverflow.ellipsis,
      child: Row(children: <Widget>[
        // branded icon
        SizedBox(
          width: 72.0,
          child: IconButton(
            padding: const EdgeInsets.only(right: 8.0),
            onPressed: this.onPress,
            icon: Stack(children: <Widget>[
              Opacity(
                opacity: animation.value,
                child: const ImageIcon(AssetImage('assets/slanted_menu.png')),
              ),
              FractionalTranslation(
                translation: Tween<Offset>(
                  begin: Offset.zero,
                  end: const Offset(1.0, 0.0),
                ).evaluate(animation),
                child: const ImageIcon(AssetImage('assets/diamond.png')),
              )]),
          ),
        ),
        // Here, we do a custom cross fade between backTitle and frontTitle.
        // This makes a smooth animation between the two texts.
        Stack(
          children: <Widget>[
            Opacity(
              opacity: CurvedAnimation(
                parent: ReverseAnimation(animation),
                curve: const Interval(0.5, 1.0),
              ).value,
              child: FractionalTranslation(
                translation: Tween<Offset>(
                  begin: Offset.zero,
                  end: const Offset(0.5, 0.0),
                ).evaluate(animation),
                child: backTitle,
              ),
            ),
            Opacity(
              opacity: CurvedAnimation(
                parent: animation,
                curve: const Interval(0.5, 1.0),
              ).value,
              child: FractionalTranslation(
                translation: Tween<Offset>(
                  begin: const Offset(-0.25, 0.0),
                  end: Offset.zero,
                ).evaluate(animation),
                child: frontTitle,
              ),
            ),
          ],
        )
      ]),
    );
  }
}