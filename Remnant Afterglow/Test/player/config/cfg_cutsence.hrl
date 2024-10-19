-ifndef(cfg_cutsence_hrl).
-define(cfg_cutsence_hrl, true).

-record(cutsenceCfg, {
	%% 10000开头的是任务对话用文字                           20000开头的是剧情动画动文字                               30000开头的是副本对话用文字                           40000开头的是副本头顶泡泡用文字 
	%% 50000开头的是引导文字
	iD,
	%% 半身像ID
	%% 0代表主角半身像
	headID,
	model,
	%% 控制器
	name,
	%% 分支选项1
	branchSelection1,
	%% 分支选项2
	branchSelection2,
	%% 分支对话1
	branchDialog1,
	%% 分支对话2
	branchDialog2,
	%% 剧情动画文件
	storyAnimation,
	%% 分支对话1
	nameString,
	%% 头像弹出方向
	%% 0左
	%% 1右
	side,
	%% 类型
	%% 0对话
	%% 1剧情动画
	message,
	%% 剧情动画文件
	messageString,
	%% 配置语音资源
	sound,
	%% 配置动作序列，多个动作用|分开
	animation,
	%% 配置动作序列中每个动作的播放次数，多个动作用|分开。一直循环就填0.
	aniParam
}).

-endif.
