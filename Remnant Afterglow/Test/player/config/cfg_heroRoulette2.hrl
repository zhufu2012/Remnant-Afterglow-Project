-ifndef(cfg_heroRoulette2_hrl).
-define(cfg_heroRoulette2_hrl, true).

-record(heroRoulette2Cfg, {
	%% 奖励库ID
	iD,
	%% (奖励序号，初始权值)
	dropPro,
	%% 心愿单选中物品时，增加的权重
	%% (奖励序号，增加的权重)
	%% 最终权重=初始权重+增加的权重
	%% 配置0或无对应序号的配置，表示：不在心愿单列表.
	dropPro2,
	%% 奖励物品
	%% (奖励序号,物品ID,物品数量)
	dropItem,
	%% 奖励货币
	%% (奖励序号，货币类型，货币数量)
	%% 货币类型：
	dropCoin,
	%% 加入奖励库的条件
	%% （序号，条件类型，参数1，参数2，参数3）
	%% ·如果对应序号这里有配置，那么需要满足条件才加入到奖励库中，不然即使在奖励库中配置了的实际获得也不出现；
	%% ·如果对应序号没配置，那么说明该序号的物品没限制条件；
	%% 条件类型1：玩家等级，参数1=等级，其他参数配置0；
	%% 条件类型2：激活英雄，参数1=英雄ID(【PetBase_1_基础和模型】表的ID），其他参数配置0；
	%% 条件类型3：激活英雄参数1/2/3配置的3个英雄之一，参数1=英雄ID，参数2=英雄ID，参数3=英雄ID；
	%% (参数1/2/3是“或”的关系，配置了几个就算几个，即配置2个表示激活2个中的1个，配置1个表示激活这1个）
	%% 条件类型4：开服天数，参数1=开服第几天，其他参数=0.
	dropCondition,
	%% 奖励预览时，加入哪个品质的列表中进行预览
	%% （序号，品质）
	%% 品质：
	%% 0、白、N
	%% 1、蓝、R
	%% 2、紫、SR
	%% 3、橙、SSR
	%% 4、红、SP
	%% 5、粉、UR
	qualityShow
}).

-endif.