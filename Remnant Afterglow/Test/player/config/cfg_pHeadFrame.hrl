-ifndef(cfg_pHeadFrame_hrl).
-define(cfg_pHeadFrame_hrl, true).

-record(pHeadFrameCfg, {
	%% 头像框ID
	iD,
	%% 所属职业
	%% 0所有职业
	%% 1004战士
	%% 1005法师
	%% 1006弓箭手
	%% 填了职业ID的是默认头像框，不会显示在列表里
	character,
	%% 头像框名称
	name,
	%% 动态头像框判断
	%% 填0表示是静态头像
	%% 非0表示是动图头像，这里则是帧动画信息在表情信息文件夹中的ID（1000~1999为头像，2000~2999为头像框）
	gif,
	%% 头像框icon
	icon,
	%% 默认是否开启
	%% 1，开启
	%% 0，不开启(如果激活了，就自动开启)
	open,
	%% 激活道具
	%% (道具ID，数量)
	%% 填“0”表示创建角色的时候默认激活的
	itemId,
	%% 基础属性
	%% (属性ID，值)
	attribute,
	%% 组ID
	%% 对应PHeadFrameStar_1_头像框升星
	pHeadFrameID
}).

-endif.
