-ifndef(cfg_npc_hrl).
-define(cfg_npc_hrl, true).

-record(npcCfg, {
	%% 1000功能npc
	%% 2000任务npc和跟随npc
	%% 3000只做对话显示的npc
	%% 4000地图传送阵，只用名字
	iD,
	%% 游戏中显示的名字文字ID
	name,
	%% 名字文字，自己看
	namestring,
	%% 肖岚:
	%% npc触发语音动作泡泡的范围半径（米）
	range,
	%% 游戏中显示的NPC称谓的文字表ID
	title,
	%% NPC等级
	npc_level,
	%% NPC类型
	%% 0 任务NPC1 功能npc2 商店npc3 游行npc4 跟随npc
	type,
	%% 1900
	modelid,
	%% 在地图里的偏移高度（米）
	modelOffset,
	%% 模型缩放倍率，100是指100%大小
	multiple,
	%% 非游行npc：
	%% npc触发说话的随机id列表。例如：泡泡id1|语音资源名1|泡泡id2|语音资源名2
	%% 游行npc：
	%% 地图id,婚车路点,泡泡id
	commonTalk,
	%% 注意：触发随机动作和指定待机动作两个不能都配置
	%% npc触发的随机动作列表。例如：{动作名1,slot,vfx}|{动作名2,slot,vfx}|{动作名3,slot,vfx}|{动作名4,slot,vfx}
	animation,
	%% UI模型缩放
	modelscal,
	%% x轴模型位移
	xproportion,
	%% y轴（面板上下）移动
	bodyproportion,
	%% z轴模型位移
	zproportion,
	%% 模型X轴旋转参数
	xrotation,
	%% 模型旋转参数
	circle,
	%% 任务显示npc
	%% 触发的完成任务ID
	%% 0表示默认出现
	active_task,
	%% 任务隐藏npc
	%% 触发的完成任务ID
	%% 0表示不消失
	deactive_task,
	%% 跟随npc保持跟随状态的任务（包括触发显示的任务）
	follow_task,
	%% 跟随npc任务创建时npc的x坐标|z坐标|朝向
	creat_pos,
	%% 完成任务触发npc（类型4跟随类型）归位，结束跟随状态
	back_task,
	%% npc移动速度
	speed,
	%% npc移动的特殊动作，特殊动作特效
	moveanimation,
	%% 特殊动作概率百分比
	movespecial,
	%% 在与npc对话时面朝玩家角色做的动作，多个|分开，如果不需要面对玩家角色的npc填0
	facing_animation,
	%% 面对玩家动作播放次数，多个|分开
	%% 0代表持续
	animation_times
}).

-endif.
