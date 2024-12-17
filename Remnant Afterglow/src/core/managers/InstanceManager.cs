
namespace Remnant_Afterglow
{
    //单例管理器
    public class InstanceManager
    {
        //清除 地图单例
        //在大地图系统并且，没有开关卡时运行
        public static void ClearMapInstance()
        {
            MapCopy.Instance = null;//关卡
            FlowFieldSystem.Instance = null;//导航系统
            ObjectManager.Instance = null;//实体管理器
        }

        //清除 大地图单例
        //回到主界面，或者其他界面，不使用存档时运行
        public static void ClearBigMapInstance()
        {

        }
    }
}