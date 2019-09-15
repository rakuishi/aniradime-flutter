class TabItem {
  final String id;
  final String title;

  TabItem(this.id, this.title);

  static List<TabItem> createTabItems() {
    List<TabItem> tabItems = new List<TabItem>();
    tabItems.add(TabItem('onsen', '音泉'));
    return tabItems;
  }
}
