-ifndef(cfg_guardBaseNew_hrl).
-define(cfg_guardBaseNew_hrl, true).

-record(guardBaseNewCfg, {
	%% 守护ID
	iD,
	%% 类型
	%% 1.经验守护
	%% 2.防御守护
	%% 3.3阶守护
	%% 4.4阶守护
	%% ……
	type,
	%% 头像icon
	headPic,
	%% 名字（服务器用）
	name,
	%% 名字
	nameText,
	%% 底图显示
	painting,
	%% 品质
	character,
	%% 计算剩余时间所需要的对应道具ID
	guardItem
}).

-endif.
