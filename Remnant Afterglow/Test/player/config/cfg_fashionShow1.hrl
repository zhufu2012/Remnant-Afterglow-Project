-ifndef(cfg_fashionShow1_hrl).
-define(cfg_fashionShow1_hrl, true).

-record(fashionShow1Cfg, {
	%% 时装ID
	%% 备注：初始时装ID不要改动
	iD,
	%% 默认是否开启
	%% 1，开启
	%% 0，不开启(如果激活了，就自动开启)
	open,
	%% 所属职业
	%% 1004战士
	%% 1005法师
	%% 1006弓箭手
	character,
	%% 分类
	%% 1、初始时装
	%% 2、其他
	sort,
	%% 时装部位
	%% 1、武器
	%% 2、头部
	%% 3、身体
	%% 4、副武
	%% 5、整套
	position,
	%% 主题ID
	themeID,
	%% 时装名称
	name,
	%% 时装ICON
	icon,
	%% 时装升星满后，提供的衣橱升级经验
	itemExp,
	%% 模型ID
	model,
	%% 时装可染色通道ID
	%%  0，不可染色
	%% 1、通道1
	%% 2、通道2
	layer
}).

-endif.
