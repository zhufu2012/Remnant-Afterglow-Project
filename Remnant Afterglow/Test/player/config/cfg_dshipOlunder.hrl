-ifndef(cfg_dshipOlunder_hrl).
-define(cfg_dshipOlunder_hrl, true).

-record(dshipOlunderCfg, {
	%% 商船品质
	%% 0为普通白
	%% 1为优秀蓝
	%% 2为史诗紫
	%% 3为传说橙
	%% 4为神话红
	%% 5为粉色
	%% 6为神装
	iD,
	%% 玩法模式(0.协助夺回、1.自主夺回、2.抢夺)
	mode,
	%% 序号
	num,
	%% 索引
	index,
	%% P1玩家最终结算血量百分比(下限万分比，上限万分比)万分比；填0即为死亡；(该玩法的主玩家)
	characterhp1,
	%% P2玩家最终结算血量百分比(下限万分比，上限万分比)；填0即为死亡(该玩家的对立玩家)
	characterhp2,
	%% 当Mode字段=1时，该奖励获得数量实际受到最多可获得的奖励总数影响
	%% 参与玩法的主玩家获得奖励(类型，ID，数量)
	%% 类型：1.道具；
	%% 2.货币;
	playerRewards1,
	%% 该奖励获得数量实际受到最多可获得的奖励总数影响
	%% 协助夺回玩法下，发起求助的玩家获得奖励(类型，ID，数量)
	%% 类型：1.道具；
	%% 2.货币;
	playerRewards2,
	%% 夺回、协助夺回成功情况对应奖励比例（万分比）
	awardProportion
}).

-endif.
