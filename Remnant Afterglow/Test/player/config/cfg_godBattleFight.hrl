-ifndef(cfg_godBattleFight_hrl).
-define(cfg_godBattleFight_hrl, true).

-record(godBattleFightCfg, {
	%% 挑战波数
	%% 玩家打完最后1波，就“胜利面”结束，不再进入下一波
	iD,
	%% 镜像属性难度系数
	%% 用于计算玩家积分
	imageAttrScale,
	%% 镜像加成属性
	%% （属性ID,属性加成万分比,加成方式）
	%% 加成方式：1加值,2加比例
	%% 未配置的属性，不加成
	imageAddAttr,
	%% 对应神位等级
	%% 挑战成功后获得
	%% 0为无等级
	godLevel,
	%% 首通奖励
	%% （职业，类型，类型ID，掉落是否绑定,掉落数量）
	%% 没有填0
	%% 取挑战结束时的首通波数奖励
	%% 类型1：道具，类型ID为道具ID
	%% 类型2：货币，类型ID为货币ID
	%% 掉落是否绑定：0为非绑 1为绑定（货币没有绑定或非绑的说法）
	%% 掉落数量：奖励道具的数量
	firstAward,
	%% 结算奖励
	%% （奖励序号，职业，掉落ID，是否绑定，掉落数量，掉落概率）
	%% 没有填0
	%% 取挑战结束时的最高胜利波数奖励
	%% 奖励序号：配置表【GodBattleBase_1_神力战场基础】的字段AwardOrder
	%% 掉落是否绑定：0为非绑 1为绑定
	%% 暂时只支持倒计奖励，装备需要添加传输展示协议
	awardItem
}).

-endif.
