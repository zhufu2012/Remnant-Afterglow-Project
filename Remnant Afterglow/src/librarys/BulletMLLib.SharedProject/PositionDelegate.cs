using Godot;

namespace BulletMLLib.SharedProject;

/// <summary>
/// 这是一个用于获取位置的回调方法
/// 用于解除依赖关系
/// </summary>
/// <returns>一个获取位置的方法。</returns>
public delegate Vector2 PositionDelegate();

/// <summary>
/// 从某处获取浮点数的方法
/// 与委托分开
/// </summary>
/// <returns>从某处获取浮点数</returns>
public delegate float FloatDelegate();
