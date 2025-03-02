// 定義柱子模型，包含名稱和盤子列表
class Tower {
  final String name; // 柱子名稱 (A, B, C)
  final List<int> disks; // 盤子列表，數字越小表示盤子越小，1 base

  Tower(this.name, this.disks);
}
