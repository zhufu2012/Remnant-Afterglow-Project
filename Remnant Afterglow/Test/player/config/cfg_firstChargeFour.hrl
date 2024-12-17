-ifndef(cfg_firstChargeFour_hrl).
-define(cfg_firstChargeFour_hrl, true).

-record(firstChargeFourCfg, {
	%% 4种档位累充版本的首充
	%% 档位ID
	%% 后台功能ID：721
	iD,
	%% 天数
	day,
	%% 索引
	index,
	%% 标签文字
	label,
	%% 累充达成额度
	%% 配置：绿钻数量
	diamonds,
	%% 奖励物品
	%% (职业，类型，ID，数量，品质，星级，是否绑定，是否显示转圈特效)
	%% 职业:
	%% 类型1=道具，ID=道具ID；
	%% 类型2=货币，ID=货币ID
	%% 类型3=装备，ID=装备ID
	%% 品质、星级：对应装备的品质和星级，其他类型无效
	%% 是否绑定：0.非绑  1.绑定
	%% 是否显示转圈特效：1.转圈  0.不显示 
	%% 职业：0=所有职业，1004=战士，1005=法师，1006=弓手，1007=魔剑
	awardItem
}).

-endif.
