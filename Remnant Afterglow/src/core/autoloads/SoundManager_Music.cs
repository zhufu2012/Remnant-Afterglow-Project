using Godot;
using System.Collections.Generic;

namespace Remnant_Afterglow
{
	/// <summary>
	/// 声音管理器-音乐
	/// </summary>
	public partial class SoundManager : Node
	{
		// 音乐触发条件类型
		public enum TriggerCondition
		{
			GameState = 1,      // 根据游戏状态触发
			Parameter =2,      // 根据参数值触发
			Manual = 3          // 手动触发
		}
	}
}
