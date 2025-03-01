import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../view_models/game_view_model.dart';
import 'package:hanoi_tower/models/tower.dart';

class GameView extends StatelessWidget {
  const GameView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tower of Hanoi'),
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
                    Text('關卡: ${viewModel.currentLevel}'),
                    Text('步數: ${viewModel.moveCount}'),
                  ],
                ),
              ),
              Expanded(
                child: Center(
                  // 使用 Center 確保垂直居中
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children:
                        viewModel.towers.map((tower) {
                          return TowerWidget(tower: tower);
                        }).toList(),
                  ),
                ),
              ),

              if (viewModel.shuffleCount > 0 && viewModel.shuffleCount <= 3)
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    '🔄 柱子正在隨機交換！',
                    style: TextStyle(fontSize: 18, color: Colors.red),
                  ),
                ),
              Spacer(flex: 1), // 添加彈性空間在頂部
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
    print(widget.tower);
    return DragTarget<Tower>(
      builder: (context, accepted, rejected) {
        return Draggable<Tower>(
          data: widget.tower,
          feedback: Material(
            color: Colors.transparent,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                if (widget.tower.disks.isNotEmpty)
                  DiskWidget(
                    disk: widget.tower.disks.first,
                    color: TowerWidget.diskColors[widget.tower.disks.first],
                  ),
                SizedBox(height: 100),
                Text(widget.tower.name, style: TextStyle(fontSize: 20)),
              ],
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
            color:
                _isDragging
                    ? Colors.grey.withAlpha((0.3 * 255).toInt())
                    : Colors.transparent,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Expanded(
                  child: Stack(
                    alignment: Alignment.bottomCenter,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children:
                            widget.tower.disks.map((disk) {
                              return DiskWidget(
                                disk: disk,
                                color: TowerWidget.diskColors[disk - 1],
                              );
                            }).toList(),
                      ),
                      if (_isDragging &&
                          _diskPosition != null &&
                          widget.tower.disks.isNotEmpty)
                        Positioned(
                          bottom: _diskPosition!.dy,
                          child: DiskWidget(
                            disk: widget.tower.disks.last,
                            color:
                                TowerWidget.diskColors[widget.tower.disks.last -
                                    1],
                          ),
                        ),
                    ],
                  ),
                ),
                Container(width: 10, height: 100, color: Colors.grey),
                if (isShuffling)
                  FadeTransition(
                    opacity: _blinkController!,
                    child: Text(
                      widget.tower.name,
                      style: TextStyle(fontSize: 20, color: Colors.red),
                    ),
                  )
                else
                  Text(widget.tower.name, style: TextStyle(fontSize: 20)),
              ],
            ),
          ),
        );
      },
      onWillAcceptWithDetails: (DragTargetDetails<Tower> details) {
        final incomingTower = details.data;
        if (incomingTower.disks.isEmpty) return false;
        final movingDisk = incomingTower.disks.last;
        return widget.tower.disks.isEmpty ||
            movingDisk < widget.tower.disks.last;
      },
      onAcceptWithDetails: (DragTargetDetails<Tower> details) {
        final incomingTower = details.data;
        viewModel.moveDisk(incomingTower.name, widget.tower.name);
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
    return AnimatedContainer(
      duration: Duration(milliseconds: 500),
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
