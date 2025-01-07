using Godot;

namespace Remnant_Afterglow
{
    partial class MainView : Control
    {

        /// <summary>
        /// 更新日志
        /// </summary>
        public RichTextLabel updatelog;


        /// <summary>
        /// 初始化更新日志数据
        /// </summary>
        public void InitUpdateLog()
        {
            updatelog = GetNode<RichTextLabel>("Panel/ScrollContainer/updatelog");

        }





    }
}
