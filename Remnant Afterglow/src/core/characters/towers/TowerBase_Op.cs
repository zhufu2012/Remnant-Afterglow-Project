
namespace Remnant_Afterglow
{
    /// <summary>
    /// 炮塔，这里处理炮塔的 操作逻辑
    /// </summary>
    public partial class TowerBase : BaseObject, ITower
    {

        /// <summary>
        /// 是否被选中
        /// </summary>
        public bool isSelected = true;
        /// <summary>
        /// 是否已被放置-没放置无法攻击
        /// </summary>
        public bool hasBeenPlaced = false;




        /// <summary>
        /// 设置选中状态
        /// </summary>
        /// <param name="isSelect"></param>
        public void SetSelect(bool isSelect)
        {
            isSelected = isSelect;
            for (int i = 0; i < WeaponList.Count; i++)
            {

            }
        }
    }
}
