-ifndef(cfg_disassemble_hrl).
-define(cfg_disassemble_hrl, true).

-record(disassembleCfg, {
	%% 拆解装备ID
	%% 如果是人物装备（攻击装，防御装，饰品），则配置对应星级与品质
	%% 如果是魔戒，神灵装备，骑宠翼装备，佩饰（未制作，待定）对应星级与品质则配置为0
	itemID,
	%% 品质
	quality,
	%% 星级
	star,
	%% 索引
	index,
	%% 绑定拆非绑的消耗
	%% {类型，ID，数量}
	%% 类型
	%% 1道具
	%% 2货币
	consumeCoin,
	%% 拆出的道具相关
	%% {道具类型，道具ID，数量，品质，星级}
	%% 道具类型为1，为普通道具，品质与星级填0,（注：神灵装备的强化经验会传递给配置的第一个道具）
	%% 道具类型为2，为人物装备，填写品质与星级
	consumeEquip
}).

-endif.
