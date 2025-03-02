import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../view_models/game_view_model.dart';
import '../models/tower.dart';

class GameView extends StatelessWidget {
  const GameView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Hanoi Tower Hell'),
        actions: [
          IconButton(
            icon: Icon(Icons.list),
            onPressed: () => Navigator.pushNamed(context, '/level_select'),
          ),
        ],
      ),
      body: Consumer<GameViewModel>(
        builder: (context, viewModel, child) {
          if (viewModel.currentLevel > viewModel.maxLevel) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              Navigator.pushNamed(context, '/game_over');
            });
          }
          return Column(
            children: [
              Padding(
                padding: EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('關卡: ${viewModel.currentLevel}', style: TextStyle(fontSize: 22,fontWeight:FontWeight.bold),),
                    Text('步數: ${viewModel.moveCount}', style: TextStyle(fontSize: 22,fontWeight:FontWeight.bold),),
                  ],
                ),
              ),
              if (viewModel.shuffleCount > 0 && viewModel.shuffleCount <= 3)
                Positioned(
                  top: 50, // 固定位置
                  child: Text(
                    '🔄 柱子正在隨機交換！',
                    style: TextStyle(fontSize: 18, color: Colors.red),
                  ),
                ),
              Expanded(
                child: Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: viewModel.towers.map((tower) {
                      return TowerWidget(tower: tower);
                    }).toList(),
                  ),
                ),
              ),
            ],
          );

        },
      ),
    );
  }
}

class TowerWidget extends StatefulWidget {
  final Tower tower;
  static const List<Color> diskColors = [
    Colors.red,
    Colors.green,
    Colors.blue,
    Colors.yellow,
    Colors.purple,
    Colors.orange,
    Colors.cyan,
    Colors.pink,
    Colors.teal,
    Colors.amber,
  ];

  const TowerWidget({super.key, required this.tower});

  @override
  State<TowerWidget> createState() => _TowerWidgetState();
}

class _TowerWidgetState extends State<TowerWidget>
    with SingleTickerProviderStateMixin {
  bool _isDragging = false;
  bool _isHovering = false; // 追蹤是否有 disk 正在拖曳到此塔
  AnimationController? _blinkController;
  Offset? _diskPosition;

  @override
  void initState() {
    super.initState();
    _blinkController = AnimationController(
      duration: Duration(milliseconds: 500),
      vsync: this,
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _blinkController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<GameViewModel>(context);
    final isShuffling =
        viewModel.shuffleCount > 0 && viewModel.shuffleCount <= 3;

    return DragTarget<Tower>(
      builder: (context, accepted, rejected) {
        return Draggable<Tower>(
          data: widget.tower,
          feedback: Material(
            color: Colors.transparent,
            child: Container(
              width: 100, // 確保與 TowerWidget 宽度相同
              alignment: Alignment.center,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (widget.tower.disks.isNotEmpty)
                    DiskWidget(
                      disk: widget.tower.disks.first,
                      color: TowerWidget.diskColors[widget.tower.disks.first - 1],
                    ),
                  Text(widget.tower.name, style: TextStyle(fontSize: 20)),
                ],
              ),
            ),
          ),
          onDragStarted: () {
            setState(() {
              _isDragging = true;
              if (widget.tower.disks.isNotEmpty) {
                _diskPosition = Offset.zero;
              }
            });
          },
          onDragEnd: (details) {
            setState(() {
              _isDragging = false;
              _diskPosition = null;
            });
          },
          child: Container(
            width: 100,
            height: 300,
              decoration: BoxDecoration(
                color: _isDragging
                    ? Colors.grey.withAlpha((0.3 * 255).toInt())
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(8),
              ),
            child:Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Expanded(
                    child: Stack(
                      alignment: Alignment.bottomCenter,
                      children: [
                         Container(
                            width: 10,
                            height: 200,
                            color: Colors.grey,
                          ),
                        // ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: widget.tower.disks.map((disk) {
                            return DiskWidget(
                              disk: disk,
                              color: TowerWidget.diskColors[disk - 1],
                            );
                          }).toList(),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 18,width: 16),
                  Container(
                    width: 36,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: _isHovering ? Colors.lightGreen.withAlpha(160) : Colors.transparent, // 當有 disk 拖曳到此塔時，背景變成淺綠色
                      borderRadius: BorderRadius.circular(8), // 設定圓角
                    ),
                    // padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    child: isShuffling
                        ? FadeTransition(
                      opacity: _blinkController!,
                      child: Text(
                        widget.tower.name,
                        style: TextStyle(fontSize: 20, color: Colors.red),
                      ),
                    )
                        : Text(
                      widget.tower.name,
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                ],
              )



          ),
        );
      },
      onWillAcceptWithDetails: (DragTargetDetails<Tower> details) {
        final incomingTower = details.data;
        if (incomingTower.disks.isEmpty) return false;
        final movingDisk = incomingTower.disks.first;
        bool canAccept = widget.tower.disks.isEmpty || movingDisk < widget.tower.disks.last;

        if (canAccept && widget.tower.name != incomingTower.name) {
          setState(() {
            _isHovering = true; // 當拖曳到此塔上時，背景變成淺綠色
          });
        }

        return canAccept;
      },
      onAcceptWithDetails: (DragTargetDetails<Tower> details) {
        final incomingTower = details.data;
        viewModel.moveDisk(incomingTower.name, widget.tower.name);
        setState(() {
          _isHovering = false; // 放下後恢復背景顏色
        });
      },
      onLeave: (data) {
        setState(() {
          _isHovering = false; // 當拖曳的 disk 離開此塔時，背景顏色恢復
        });
      },
    );
  }
}

class DiskWidget extends StatelessWidget {
  final int disk;
  final Color color;

  const DiskWidget({super.key, required this.disk, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: disk * 20.0,
      height: 20.0,
      margin: EdgeInsets.symmetric(vertical: 2.0),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(4.0),
      ),
    );
  }
}
