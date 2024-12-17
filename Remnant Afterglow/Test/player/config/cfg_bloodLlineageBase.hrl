-ifndef(cfg_bloodLlineageBase_hrl).
-define(cfg_bloodLlineageBase_hrl, true).

-record(bloodLlineageBaseCfg, {
	%% 血脉ID
	iD,
	%% 名字
	%% 使用道具名
	name,
	%% 是否默认开放
	open,
	%% 血脉激活条件
	%% （条件类型,参数,激活是否公告)
	%% 类型1：角色等级，参数为玩家等级
	%% 激活是否公告：0不公告，1公告
	%% 填0表示无条件，不公告
	condition,
	%% 血脉激活消耗
	%% （消耗类型,参数1,参数2)
	%% 类型1：道具激活，参数1为道具id，参数2为数量
	consume,
	%% 激活初始血脉等级
	levelIniti,
	%% 升级材料经验
	%% （道具id，经验值，是否默认不显示)
	%% 每个道具对应的经验值
	%% 是否默认不显示：0默认显示，1默认不显示，需要玩家拥有该道具才会显示出来
	levelMaterial,
	%% 血脉技能
	%% （序号，解锁需血脉等级，初始技能等级，解锁是否公告)
	%% 解锁是否公告：0不公告，1公告
	skill,
	%% 对应功能开关和FS
	openAndFs
}).

-endif.
