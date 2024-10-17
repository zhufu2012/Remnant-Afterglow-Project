-ifndef(cfg_blessingAttribute2_hrl).
-define(cfg_blessingAttribute2_hrl, true).

-record(blessingAttribute2Cfg, {
	%% 属性库ID
	iD,
	%% （属性id，值，品质色）
	%% 属性品质色
	%% 1、蓝
	%% 2、紫
	%% 3、橙
	%% 4、红
	%% 5、粉色
	regenerateAttr,
	%% 可被调用次数
	num,
	%% 属性库ID品质色
	%% 1、蓝
	%% 2、紫
	%% 3、橙
	%% 4、红
	%% 5、粉色
	quality,
	%% 包装名称文字索引
	blessingAttributeName,
	%% 创角顺序
	%% 1、第一个角色
	%% 2、第二个角色
	%% 3、第三个角色
	role
}).

-endif.
