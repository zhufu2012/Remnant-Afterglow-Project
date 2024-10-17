-ifndef(cfg_stump_hrl).
-define(cfg_stump_hrl, true).

-record(stumpCfg, {
	%% 残肢识别名称编号
	iD,
	%% 中文描述
	dec,
	%% 残肢血量占主体万分比
	hPPercent,
	%% 隶属残肢组别ID
	groupID,
	%% 组内对比其他残肢ID优先级
	priority,
	%% 可被攻击时机类型（0不可被攻击，填1受技能释放时间开始和结束影响）
	beHit,
	%% 可攻击时机参数（前1字段填1时生效，{skillID1，skillID1时间参数1，skillID1时间参数2}|{skillID2，skillID2时间参数1，skillID2时间参数2}）,时间为毫秒
	beHitPara,
	%% 复原方式（0不能复原，1个体复原，2残肢组复原）
	beRecover,
	%% 复原时间
	recoverTime,
	%% 生命状态定义，从0开始（{1,10000}|{2,5000}|{3,3000}）
	hPState,
	%% 复原特效路径,和蓝色开头字段一一对应
	vFXPatchBorn,
	%% 分摊主体伤害万分比(根据状态配置),和蓝色开头字段一一对应
	bodyShare,
	%% 状态改变对主体造成当前伤害万分比(根据状态配置),和蓝色开头字段一一对应
	stumpHurt,
	%% 残肢模型ID(根据状态配置),和蓝色开头字段一一对应
	modelID,
	%% 改变状态特效路径(根据状态配置),和蓝色开头字段一一对应
	stumpChangeVFX,
	%% 受击特效路径(根据状态配置),和蓝色开头字段一一对应
	vFXPatchBeHit,
	%% 残肢攻击指引特效(根据状态配置),和蓝色开头字段一一对应
	vFXPatchGuide,
	%% 残肢攻击指引特效挂点(根据状态配置),和蓝色开头字段一一对应
	vFXPatchGuideSlot,
	%% 改变状态特效镜头路径(根据状态配置),和蓝色开头字段一一对应
	cinematicsPath,
	%% 状态改变切换动作(根据状态配置),和蓝色开头字段一一对应
	stateChangeAct,
	%% 状态UI提示路径,和蓝色开头字段一一对应
	hintInformation
}).

-endif.
