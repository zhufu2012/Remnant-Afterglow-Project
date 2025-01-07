-ifndef(cfg_buffObject_hrl).
-define(cfg_buffObject_hrl, true).

-record(buffObjectCfg, {
	%% buff球id
	iD,
	%% 策划用
	name,
	%% 模型路径
	model,
	%% 特效路径
	vFX,
	%% 功能类型
	%% 1：添加buff
	%% 2：修罗战场增加复活次数
	%% 3:可储蓄buff（最多3个）
	type,
	%% 可储存buff使用CD 
	%% （Type为3时生效）
	cDTime,
	%% 根据Type类型确定参数作用
	%% 1:buffID
	%% 2:增加复活次数
	parm,
	%% BUFF球拾取距离
	distance,
	%% BUFF球存留时长，毫秒
	time
}).

-endif.
