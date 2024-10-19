using System.Collections.Generic;
using Godot;
namespace Remnant_Afterglow
{
    /// <summary>
    /// 自动生成的配置类 CameraAssemblyBase 用于 相机组件表,拓展请在expand_class文件下使用partial拓展
    /// </summary>
    public partial class CameraAssemblyBase
    {
        #region 参数及初始化
        /// <summary>        
        /// 相机组件id
        /// </summary>
        public int AssemblyId { get; set; }
        /// <summary>        
        /// 组件类型1
        ///0 显示帧数
        ///1 噪声编辑器 有一个就够了
        ///2 图片组 ParamPosLIst是后面图片的坐标
        ///3 打开某界面的按钮 有具体类型2（具体某按钮），组件参数1表示 cfg_ViewBase_界面基础配置表的ViewId 
        ///
        ///51 在线玩家列表
        /// </summary>
        public int Type1 { get; set; }
        /// <summary>        
        /// 组件具体类型2
        ///1 默认配置按钮 
        ///2 科技树按钮
        ///3 数据库按钮
        ///4 返回存档界面的按钮
        /// </summary>
        public int Type2 { get; set; }
        /// <summary>        
        /// 组件参数1
        ///当组件类型1为3 常规按钮时，
        ///表示打开某界面，这个参数表示界面id
        /// </summary>
        public int Param1 { get; set; }
        /// <summary>        
        /// 组件参数2
        /// </summary>
        public int Param2 { get; set; }
        /// <summary>        
        /// 组件参数1_字符串
        /// </summary>
        public string ParamStr1 { get; set; }
        /// <summary>        
        /// 组件参数_图片坐标列表
        /// </summary>
        public int ParamPosLIst { get; set; }
        /// <summary>        
        /// 组件参数_图片1
        /// </summary>
        public Texture2D ParamPng1 { get; set; }
        /// <summary>        
        /// 组件参数_图片2
        /// </summary>
        public Texture2D ParamPng2 { get; set; }
        /// <summary>        
        /// 组件参数_图片3
        /// </summary>
        public Texture2D ParamPng3 { get; set; }
        /// <summary>        
        /// 组件参数_图片4
        /// </summary>
        public Texture2D ParamPng4 { get; set; }
        /// <summary>        
        /// 组件是否
        ///默认显示
        /// </summary>
        public bool IsDefineShow { get; set; }
        /// <summary>        
        /// 组件大小
        ///(横轴长度，纵轴长度)
        /// </summary>
        public Vector2 Size { get; set; }
        /// <summary>        
        /// 组件位置
        ///(横轴X，纵轴Y)
        /// </summary>
        public Vector2 Pos { get; set; }

        public CameraAssemblyBase(int id)
        {
            Dictionary<string, object> dict = ConfigLoadSystem.GetCfgIndex(ConfigConstant.Config_CameraAssemblyBase, id);//public const string Config_CameraAssemblyBase = "cfg_CameraAssemblyBase"; 
			AssemblyId = (int)dict["AssemblyId"];
			Type1 = (int)dict["Type1"];
			Type2 = (int)dict["Type2"];
			Param1 = (int)dict["Param1"];
			Param2 = (int)dict["Param2"];
			ParamStr1 = (string)dict["ParamStr1"];
			ParamPosLIst = (int)dict["ParamPosLIst"];
			ParamPng1 = (Texture2D)dict["ParamPng1"];
			ParamPng2 = (Texture2D)dict["ParamPng2"];
			ParamPng3 = (Texture2D)dict["ParamPng3"];
			ParamPng4 = (Texture2D)dict["ParamPng4"];
			IsDefineShow = (bool)dict["IsDefineShow"];
			Size = (Vector2)dict["Size"];
			Pos = (Vector2)dict["Pos"];
			InitData();
        }

        
        public CameraAssemblyBase(string cfg_id)
        {
            Dictionary<string, object> dict = ConfigLoadSystem.GetCfgIndex(ConfigConstant.Config_CameraAssemblyBase, cfg_id);//public const string Config_CameraAssemblyBase = "cfg_CameraAssemblyBase"; 
			AssemblyId = (int)dict["AssemblyId"];
			Type1 = (int)dict["Type1"];
			Type2 = (int)dict["Type2"];
			Param1 = (int)dict["Param1"];
			Param2 = (int)dict["Param2"];
			ParamStr1 = (string)dict["ParamStr1"];
			ParamPosLIst = (int)dict["ParamPosLIst"];
			ParamPng1 = (Texture2D)dict["ParamPng1"];
			ParamPng2 = (Texture2D)dict["ParamPng2"];
			ParamPng3 = (Texture2D)dict["ParamPng3"];
			ParamPng4 = (Texture2D)dict["ParamPng4"];
			IsDefineShow = (bool)dict["IsDefineShow"];
			Size = (Vector2)dict["Size"];
			Pos = (Vector2)dict["Pos"];
			InitData();
        }

        public CameraAssemblyBase(Dictionary<string, object> dict)
        {
			AssemblyId = (int)dict["AssemblyId"];
			Type1 = (int)dict["Type1"];
			Type2 = (int)dict["Type2"];
			Param1 = (int)dict["Param1"];
			Param2 = (int)dict["Param2"];
			ParamStr1 = (string)dict["ParamStr1"];
			ParamPosLIst = (int)dict["ParamPosLIst"];
			ParamPng1 = (Texture2D)dict["ParamPng1"];
			ParamPng2 = (Texture2D)dict["ParamPng2"];
			ParamPng3 = (Texture2D)dict["ParamPng3"];
			ParamPng4 = (Texture2D)dict["ParamPng4"];
			IsDefineShow = (bool)dict["IsDefineShow"];
			Size = (Vector2)dict["Size"];
			Pos = (Vector2)dict["Pos"];
			InitData();
        }
        #endregion
    }
}
