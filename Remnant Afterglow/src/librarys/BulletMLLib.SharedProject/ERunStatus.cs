namespace BulletMLLib.SharedProject;

/// <summary>
/// 这些用于运行时的任务...
/// </summary>
public enum ERunStatus
{
    Continue, //继续解析此任务
    End, //此任务已完成解析
    Stop //此任务已暂停
}
