using GameLog;
using Godot;
using System;
using System.Collections.Generic;

namespace Remnant_Afterglow
{
	/// <summary>
	/// UI音效-管理器
	/// </summary>
	public partial class SoundManager : Node
	{
		public static SoundManager Instance { get; private set; }
		public bool AutoBindEnabled { get; set; } = true;
		public Dictionary<string, Type> SfxType = new Dictionary<string, Type>();
		public Dictionary<string, UISoundSfx> SfxDict = new Dictionary<string, UISoundSfx>();

		// 使用对象池管理 AudioStreamPlayer 实例
		private List<AudioStreamPlayer> audioPlayers = new List<AudioStreamPlayer>();
		private Queue<AudioStreamPlayer> availablePlayers = new Queue<AudioStreamPlayer>();

		// 缓存 Meta 字符串以避免重复创建
		private Dictionary<string, string> metaStringCache = new Dictionary<string, string>();

		[Export]
		public int MaxAudioPlayers { get; set; } = 5; // 最大同时播放音效数

		public override void _EnterTree()
		{
			Instance = this;
			GetTree().NodeAdded += OnSceneChanged;
			InitializeAudioPlayers();
			LoadSoundConfigurations();
		}

		/// <summary>
		/// 初始化音频播放器池
		/// </summary>
		private void InitializeAudioPlayers()
		{
			for (int i = 0; i < MaxAudioPlayers; i++)
			{
				var player = new AudioStreamPlayer();
				AddChild(player);
				audioPlayers.Add(player);
				availablePlayers.Enqueue(player);
			}
		}

		/// <summary>
		/// 加载音效配置
		/// </summary>
		private void LoadSoundConfigurations()
		{
			List<UISoundSfx> uiSoundSfxList = ConfigCache.GetAllUISoundSfx();
			foreach (UISoundSfx uiSoundSfx in uiSoundSfxList)
			{
				switch (uiSoundSfx.UIType)
				{
					case 0:
						SfxType[uiSoundSfx.UIName] = null;
						break;
					case 1:
						SfxType[uiSoundSfx.UIName] = typeof(Button);
						break;
					case 2:
						SfxType[uiSoundSfx.UIName] = typeof(TextureButton);
						break;
					default:
						break;
				}
				SfxDict[uiSoundSfx.UIName] = uiSoundSfx;
			}
		}

		private void OnSceneChanged(Node node)
		{
			Callable.From(() =>
			{
				if (!AutoBindEnabled)
					return;
				AutoBindUiElements(node);
			}).CallDeferred();
		}

		/// <summary>
		/// 自动绑定UI元素的音效
		/// </summary>
		private void AutoBindUiElements(Node node)
		{
			foreach (string group in node.GetGroups())// 遍历节点的组，找出需要绑定音效的组
			{
				if (SfxDict.TryGetValue(group, out UISoundSfx sfx))
				{
					if (SfxType.TryGetValue(group, out var type))
					{
						if (type == null || type.IsInstanceOfType(node))
						{
							BindSfxToNode(sfx, node);
						}
					}
				}
			}
		}

		/// <summary>
		/// 获取缓存的 Meta 字符串
		/// </summary>
		private string GetMetaString(string uiName)
		{
			if (!metaStringCache.TryGetValue(uiName, out string metaStr))
			{
				metaStr = "sfx_" + uiName;
				metaStringCache[uiName] = metaStr;
			}
			return metaStr;
		}

		/// <summary>
		/// 为单个节点绑定音效
		/// </summary>
		private void BindSfxToNode(UISoundSfx sfx, Node node)
		{
			string metaStr = GetMetaString(sfx.UIName);

			// 防止重复绑定
			if (node.HasMeta(metaStr))
				return;

			// 使用统一的事件绑定方法
			if (BindEventsForControl(node, sfx))
			{
				node.SetMeta(metaStr, true);
			}
			else
			{
				GD.PrintErr($"不支持的节点类型: {node.GetType().Name}，无法为 {sfx.UIName} 绑定音效");
			}
		}

		/// <summary>
		/// 为控件绑定事件
		/// </summary>
		private bool BindEventsForControl(Node node, UISoundSfx sfx)
		{
			bool bound = false;

			foreach (int eventId in sfx.EventIdList)
			{
				switch (node)
				{
					case BaseButton button:
						bound = true;
						switch (eventId)
						{
							case 1: // 按下事件
								button.ButtonDown += () => OnUiElementActivated(sfx);
								break;
							case 2: // 获得焦点
								button.FocusEntered += () => OnUiElementActivated(sfx);
								break;
							case 3: // 失去焦点
								button.FocusExited += () => OnUiElementActivated(sfx);
								break;
							case 4: // 鼠标进入
								button.MouseEntered += () => OnUiElementActivated(sfx);
								break;
							case 5: // 鼠标离开
								button.MouseExited += () => OnUiElementActivated(sfx);
								break;
						}
						break;
				}
			}

			return bound;
		}

		/// <summary>
		/// UI元素激活时播放音效
		/// </summary>
		private void OnUiElementActivated(UISoundSfx sfx)
		{
			if (sfx?.audio_stream == null)
			{
				GD.PrintErr($"音效资源为空: {sfx?.SfxName ?? "Unknown"}");
				return;
			}

			// 从池中获取可用的播放器
			if (availablePlayers.Count > 0)
			{
				var player = availablePlayers.Dequeue();
				player.Stream = sfx.audio_stream;
				player.Play();

				// 播放完成后将播放器返回池中
				//player.Connect(AudioStreamPlayer.SignalName.Finished, new Callable(this, nameof(OnAudioFinished)).Bind(player));
			}
			else
			{
				GD.Print($"音效播放器池已满，无法播放音效: {sfx.SfxName}");
			}
		}

		/// <summary>
		/// 音效播放完成回调
		/// </summary>
		private void OnAudioFinished(AudioStreamPlayer player)
		{
			availablePlayers.Enqueue(player);
		}

		/// <summary>
		/// 播放指定音效（手动调用接口）
		/// </summary>
		public void PlaySound(string soundName)
		{
			if (SfxDict.TryGetValue(soundName, out UISoundSfx sfx))
			{
				OnUiElementActivated(sfx);
			}
			else
			{
				GD.PrintErr($"未找到音效配置: {soundName}");
			}
		}

		/// <summary>
		/// 播放指定音效（直接传入配置）
		/// </summary>
		public void PlaySound(UISoundSfx sfx)
		{
			if (sfx != null)
			{
				OnUiElementActivated(sfx);
			}
		}

		public override void _ExitTree()
		{
			// 清理事件订阅
			GetTree().NodeAdded -= OnSceneChanged;

			// 清理音频播放器连接
			foreach (var player in audioPlayers)
			{
				if (player.IsConnected(AudioStreamPlayer.SignalName.Finished, new Callable(this, nameof(OnAudioFinished))))
				{
					player.Disconnect(AudioStreamPlayer.SignalName.Finished, new Callable(this, nameof(OnAudioFinished)));
				}
			}
		}
	}
}
