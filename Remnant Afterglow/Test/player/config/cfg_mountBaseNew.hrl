-ifndef(cfg_mountBaseNew_hrl).
-define(cfg_mountBaseNew_hrl, true).

-record(mountBaseNewCfg, {
	%% 坐骑ID
	iD,
	%% 是否生效
	open,
	%% 名字
	name,
	%% 初始星数
	starIniti,
	%% 新增
	%% 对应品质
	%% 0 N白
	%% 1 R蓝
	%% 2 SR紫
	%% 3 SSR橙
	%% 4 SP 红
	%% 5 UR 粉
	rareType,
	%% 作者:
	%% 坐骑的idle时候对应主角播放什么动作
	idle,
	%% 作者:
	%% 坐骑的Run时候对应主角播放什么动作
	run,
	%% 作者:
	%% 坐骑的Show时候对应主角播放什么动作
	show,
	%% 上坐骑时的坐骑冲刺技能的修正技能ID
	rollSkill,
	%% 飞行坐骑模型在原高度基础上偏离的高度。没有填0
	modelOffset,
	%% 坐骑对应不同职业的缩放以及对应主角头顶HUD偏移
	%% 主角角色ID
	%% 1004、战士
	%% 1005、法师（缩放、HUD偏移为战士的0.95）
	%% 1006、弓手（缩放、HUD偏移为战士的0.9）
	%% 1007、圣职（缩放、HUD偏移为战士的0.75）
	%% 填写方法
	%% {职业ID1,缩放倍率,头顶HD偏移}|{职业ID2,缩放倍率,头顶HD偏移}
	%% 举例
	%% {1001,1.5,0.7}|{1002,1.5,0.7}|{1003,1.5,0.7}|{1004,1.5,0.7}|{1005,1.2,0.7}
	modleData,
	%% 任何地图骑乘坐骑后镜头距离的修正，正为加，负为减
	cameraDistance,
	%% 任何地图骑乘坐骑后镜头偏移的修正，正为加，负为减
	cameraYoff,
	%% 任何地图骑乘坐骑后镜头角度的修正，正为加，负为减
	cameraPitch,
	%% 作者:
	%% 坐骑show时的音效
	%% （show是读mod表里的随机语音，该字段不生效）
	showSound,
	%% 坐骑在石板路面移动的音效
	runSound,
	%% 作者:
	%% 坐骑冲锋音效
	chargeSound,
	%% 作者:
	%% 上马音效
	upSound,
	%% 下马音效
	downSound,
	%% user:上马特效
	upSpecial,
	%% 作者:
	%% 下马特效
	downSpecial,
	%% 基础属性
	%% {属性ID，属性值}
	attrBase,
	%% 坐骑骑乘预览界面整体缩放
	scale,
	%% 预览坐骑骑乘界面角度
	rotation,
	%% 排序ID
	orderId,
	%% 提升系统中需要用到的评价该系统养成进度的依据值
	evaluate,
	%% 激活消耗道具
	%% (消耗道具，消耗数量)
	consume,
	%% 升星消耗道具ID
	consumeStar
}).

-endif.
