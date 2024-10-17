-ifndef(cfg_guildTreasuryAcquire_hrl).
-define(cfg_guildTreasuryAcquire_hrl, true).

-record(guildTreasuryAcquireCfg, {
	%% 枚举ID
	iD,
	%% 填具体参数
	%% 枚举1=炎魔试炼的公会排名，参数=具体名次（需要小于等于这个名次）
	%% 枚举2=战盟BOSS的公会排名，参数=具体名次（需要小于等于这个名次）
	%% 枚举3=领地战的评价等级，参数=
	%% 1.S赛区
	%% 2.A赛区
	%% 3.B赛区
	%% 4.C赛区
	%% 5.D赛区（需要小于等于这个名次）
	%% 枚举4=参与超级BOSS击杀的公会排名名次，参数=具体名次（需要小于等于这个名次）
	getRedBagWay,
	%% 获得的积分点数
	giveRedBag
}).

-endif.
