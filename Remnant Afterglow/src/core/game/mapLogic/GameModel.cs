namespace Remnant_Afterglow
{
    //地图游戏模式-各类模式都继承于此
    public class GameModel
    {
        //模式的每帧刷新逻辑
        public virtual void PostUpdate()
        {
        }

        //开始模式的逻辑
        public virtual void StartModel()
        {
            InitData();//初始化数据
        }

        //结束模式的逻辑
        public virtual void EndModel()
        {
        }

        //初始化数据
        public virtual void InitData()
        {
        }
    }
}