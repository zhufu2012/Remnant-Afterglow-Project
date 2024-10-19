-ifndef(cfg_blessingAttribute1_hrl).
-define(cfg_blessingAttribute1_hrl, true).

-record(blessingAttribute1Cfg, {
	%% 章节
	iD,
	%% 小章节
	oder,
	%% 索引
	index,
	%% 随机位置1
	%% （属性库，权重）
	%% 1、Attribute1[BlessingAttribute3_1_祝福章节]
	%% 2、Attribute2[BlessingAttribute3_1_祝福章节]
	%% 3、Attribute3[BlessingAttribute3_1_祝福章节]
	%% 、、、
	%% 12、Attribute12[BlessingAttribute3_1_祝福章节]
	%% 随机位置1、2、3随机的属性库ID优先不重复
	%% 如果剩余库ID数量不足时，才可以重复。
	weight1,
	%% 随机位置2
	%% （属性品质，权重）
	weight2,
	%% 随机位置3
	%% （属性品质，权重）
	weight3
}).

-endif.
