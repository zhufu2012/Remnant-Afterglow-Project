using Godot;

namespace Remnant_Afterglow
{
    /// <summary>
    /// 地图游戏模式-各类模式都继承于此
    /// </summary>
    public partial class GameModel : Node2D
	{

		/// <summary>
		/// 是否已开始逻辑
		/// </summary>
		public bool IsStart = false;
		/// <summary>
		/// 是否已刷怪结束
		/// </summary>
		public bool IsEnd = false;	

		/// <summary>
		/// 模式的每帧刷新逻辑
		/// </summary>
		public virtual void PostUpdate(double delta)
		{
		}

		/// <summary>
		/// 开始模式的逻辑
		/// </summary>
		public virtual void StartModel()
		{
            IsStart = true;
			InitData();//初始化数据
		}

		/// <summary>
		/// 结束模式的逻辑
		/// </summary>
		public virtual void EndModel()
		{
		}

		/// <summary>
		/// 初始化数据
		/// </summary>
		public virtual void InitData()
		{
		}

        /// <summary>
        /// 是否关卡结束
        /// </summary>
        /// <returns></returns>
        public bool IsCopyEnd()
        {
            if (IsEnd)//是否已刷新完所有波次敌人
            {
                if (ObjectManager.Instance.unitDict.Count == 0)//所有单位都死亡
                {
                    return true;
                }
            }
            return false;
        }
    }
}
