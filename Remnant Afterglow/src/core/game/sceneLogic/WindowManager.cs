using System.Collections.Generic;
using GameLog;
using Godot;
namespace Remnant_Afterglow
{
	/// <summary>
	/// 管理子窗口的控制类，负责窗口的打开、关闭、历史记录和导航
	/// </summary>
	public partial class WindowManager : Control
	{
		#region 数据结构
		/// <summary>
		/// 窗口配置类，包含场景路径和启动参数
		/// </summary>
		public class WindowConfig
		{
			/// <summary> 子窗口场景路径 </summary>
			public string ScenePath;
			/// <summary> 启动时传递的参数字典 </summary>
			public Dictionary<string, object> Parameters;
		}
		#endregion

		#region 单例模式
		/// <summary>
		/// 窗口管理器的单例实例，确保全局唯一访问
		/// </summary>
		public static WindowManager Instance { get; private set; }
		#endregion

		#region 核心数据结构
		/// <summary>
		/// 历史栈，保存已关闭的窗口用于返回功能
		/// </summary>
		private Stack<SubScene> _historyStack = new Stack<SubScene>();
		/// <summary>
		/// 前进栈，保存通过返回操作移除的窗口
		/// </summary>
		private Stack<SubScene> _forwardStack = new Stack<SubScene>();
		/// <summary>
		/// 当前显示的活动窗口
		/// </summary>
		public SubScene _currentWindow;
		/// <summary>
		/// 全局上下文数据，所有窗口可共享的基础参数
		/// </summary>
		private Dictionary<string, object> _contextData = new Dictionary<string, object>();
		#endregion

		#region 生命周期方法
		/// <summary>
		/// 节点进入场景树时初始化单例
		/// </summary>
		public override void _EnterTree()
		{
			// 确保单例在场景切换时更新
			if (Instance != null && !IsInstanceValid(Instance))
			{
				Instance = null; // 清除已释放的实例
			}

			if (Instance == null)
			{
				Instance = this;
			}
		}
		public override void _ExitTree()
		{
			if (Instance == this)
			{
				CloseAllWindows(); // 清理资源
				Instance = null;
			}
		}

		#endregion

		#region 初始化方法
		/// <summary>
		/// 初始化全局上下文数据
		/// </summary>
		/// <param name="contextData">所有窗口共享的基础参数</param>
		public void Initialize(Dictionary<string, object> contextData)
		{
			_contextData = contextData;
		}
		#endregion

		#region 窗口操作
		/// <summary>
		/// 打开指定类型的子窗口
		/// </summary>
		/// <typeparam name="T">继承自SubScene的窗口类型</typeparam>
		/// <param name="parameters">窗口启动参数</param>
		/// <param name="clearHistory">是否清空历史记录</param>
		public void OpenWindow<T>(Dictionary<string, object> parameters = null, bool clearHistory = false) where T : SubScene
		{
			// 构建窗口配置
			var config = new WindowConfig
			{
				ScenePath = $"res://src/core/game/sceneLogic/subscene/{typeof(T).Name}.tscn",
				Parameters = MergeParameters(parameters) // 合并上下文和传入参数
			};
			LoadWindow(config, clearHistory); // 加载并显示新窗口
		}




		/// <summary>
		/// 返回上一个窗口
		/// </summary>
		public void GoBack()
		{
			if (_historyStack.Count == 0) return; // 没有历史记录时终止

			var previous = _historyStack.Pop(); // 获取上一个窗口
			_forwardStack.Push(_currentWindow); // 将当前窗口推入前进栈
			RemoveChild(_currentWindow);
			TransitionWindows(previous, true); // 切换到前一个窗口
		}

		/// <summary>
		/// 前进到下一个窗口
		/// </summary>
		public void GoForward()
		{
			if (_forwardStack.Count == 0) return; // 没有前进记录时终止

			var next = _forwardStack.Pop(); // 获取下一个窗口
			_historyStack.Push(_currentWindow); // 将当前窗口推入历史栈
			RemoveChild(_currentWindow);
			TransitionWindows(next, false); // 切换到下一个窗口
		}

		/// <summary>
		/// 关闭当前窗口并返回上一个窗口（如果存在）
		/// </summary>
		public void CloseCurrentWindow()
		{
			if (_currentWindow == null)
			{
				GD.Print("没有可关闭的窗口");
				return;
			}

			// 释放当前窗口
			var closingWindow = _currentWindow;
			closingWindow.OnExit();
			RemoveChild(closingWindow);
			closingWindow.QueueFree();

			// 恢复上一个窗口（如果存在）
			if (_historyStack.Count > 0)
			{
				var previousWindow = _historyStack.Pop();
				_currentWindow = previousWindow;
				_currentWindow.Visible = true;
				_currentWindow.OnEnter();

				// 清空前进记录
				_forwardStack.Clear();
			}
			else
			{
				// 没有历史记录时完全关闭
				_currentWindow = null;
				GD.Print("所有窗口已关闭");
			}
		}

		/// <summary>
		/// 关闭所有窗口并清空栈
		/// </summary>
		public void CloseAllWindows()
		{
			// 释放历史栈中的所有窗口
			foreach (var window in _historyStack)
				window.QueueFree();
			_historyStack.Clear();

			// 释放前进栈中的所有窗口
			foreach (var window in _forwardStack)
				window.QueueFree();
			_forwardStack.Clear();
			// 释放当前窗口
			if (_currentWindow != null)
			{
				_currentWindow.QueueFree();
				_currentWindow = null;
			}
		}
		#endregion

		#region 核心逻辑方法
		/// <summary>
		/// 加载并显示新窗口
		/// </summary>
		private void LoadWindow(WindowConfig config, bool clearHistory)
		{
			// 实例化新窗口
			var newWindow = ResourceLoader.Load<PackedScene>(config.ScenePath).Instantiate<SubScene>();

			if (clearHistory)
				ClearHistory(); // 清空历史记录

			// 处理当前窗口状态
			if (_currentWindow != null)
			{
				_historyStack.Push(_currentWindow); // 将当前窗口推入历史栈
				_currentWindow.OnExit(); // 调用退出逻辑
				RemoveChild(_currentWindow);
			}

			// 切换到新窗口
			_currentWindow = newWindow;
			_currentWindow.Initialize(config.Parameters); // 初始化新窗口
			AddChild(_currentWindow);
			_currentWindow.OnEnter(); // 调用进入逻辑
			_currentWindow.Visible = true; // 显示新窗口

			_forwardStack.Clear(); // 清空前进栈
		}

		/// <summary>
		/// 窗口切换动画逻辑
		/// </summary>
		private void TransitionWindows(SubScene targetWindow, bool isBack)
		{
			targetWindow.Visible = true; // 显示目标窗口
			targetWindow.OnEnter(); // 调用进入逻辑

			_currentWindow.OnExit(); // 调用当前窗口退出逻辑
			_currentWindow.Visible = false; // 隐藏当前窗口

			_currentWindow = targetWindow; // 更新当前窗口引用
		}

		/// <summary>
		/// 合并全局上下文与传入参数
		/// </summary>
		private Dictionary<string, object> MergeParameters(Dictionary<string, object> parameters)
		{
			if (parameters != null)
			{
				foreach (var kvp in parameters)
					_contextData[kvp.Key] = kvp.Value; // 覆盖参数
			}
			return _contextData;
		}

		/// <summary>
		/// 清空历史记录并释放资源
		/// </summary>
		private void ClearHistory()
		{
			foreach (var window in _historyStack)
				window.QueueFree(); // 释放历史窗口
			_historyStack.Clear();
			_forwardStack.Clear(); // 同时清空前进栈
		}
		#endregion

		#region 输入事件处理

		public override void _UnhandledInput(InputEvent @event)
		{
			// 返回键处理
			if (@event.IsActionPressed("Esc"))
				GoBack();
			// 右键点击关闭所有窗口（调试用途）
			if (@event is InputEventMouseButton mouseEvent &&
				mouseEvent.ButtonIndex == MouseButton.Right &&
				mouseEvent.Pressed)
			{
				CloseAllWindows();
                MapOpManager.Instance.SetOp();
			}
		}


		/// <summary>
		/// 静态调用返回上一个窗口
		/// </summary>
		public static void Window_GoBack()
		{
			Instance.GoBack();
		}

		/// <summary>
		/// 静态调用，关闭所有窗口
		/// </summary>
		public static void Window_CloseAllWindows()
		{
			Instance.CloseAllWindows();
		}

		/// <summary>
		/// 静态调用 前进到下一个窗口
		/// </summary>
		public static void Window_GoForward()
		{
			Instance.GoForward();
		}

		public static void Window_CloseCurrentWindow()
		{
			Instance.CloseCurrentWindow();
		}
		#endregion
	}
}
