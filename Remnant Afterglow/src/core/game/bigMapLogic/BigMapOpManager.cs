using Godot;

namespace Remnant_Afterglow
{
    /// <summary>
    /// 大地图玩家操作管理器
    /// </summary>
    public partial class BigMapOpManager : Node2D
    {
        /// <summary>
        /// 当前拖动的塔
        /// </summary>
        private TowerBase heldTower { get; set; }
        /// <summary>
        /// 当前选中的塔
        /// </summary>
        private TowerBase selectedTower { get; set; }
        public override void _UnhandledInput(InputEvent @event)
        {
            base._UnhandledInput(@event);
        }

        public override void _Input(InputEvent ev)
        {
            if (IsInstanceValid(heldTower))
            {
            }
        }

        /// <summary>
        /// 删除选中
        /// </summary>
        private void DeselectTower()
        {
            if (IsInstanceValid(heldTower))
                heldTower.QueueFree();
            if (!IsInstanceValid(selectedTower))
                return;
            selectedTower.isSelected = false;
            selectedTower.QueueRedraw();
            selectedTower = null;
            GetNode<Control>("HUD/SelectedTowerPanel").Hide();
        }

        private void SelectTower(TowerBase tower)
        {
            if (selectedTower is not null)
            {
                selectedTower.isSelected = false;
                selectedTower.QueueRedraw();
            }
            selectedTower = tower;
            tower.isSelected = true;
            selectedTower.QueueRedraw();
        }
    }
}
