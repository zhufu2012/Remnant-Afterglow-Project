using Godot;
using System;
using System.Collections.Generic;

namespace Remnant_Afterglow
{
    /// <summary>
    /// 窗口管理器可管理的-子窗口父类
    /// </summary>
    public partial class SubScene : Control
    {
        /// <summary>
        /// 在这里处理参数初始化
        /// </summary>
        /// <param name="parameters"></param>
        public virtual void Initialize(Dictionary<string, object> parameters)
        {
        }

        /// <summary>
        /// 窗口激活时调用
        /// </summary>
        public virtual void OnEnter()
        {
        }

        /// <summary>
        /// 窗口失活时调用
        /// </summary>
        public virtual void OnExit()
        {
        }
    }
}
