-ifndef(cfg_mountElementAwaken_hrl).
-define(cfg_mountElementAwaken_hrl, true).

-record(mountElementAwakenCfg, {
	%% 坐骑品质
	%% 与坐骑基础配置RareType对应（+1）
	%% 例：S级坐骑品质枚举为1，其值+1，则在该字段序号为2                                                                                                                                                                                                                                                                                                                                                                                                                                                    
	mountType,
	%% 觉醒类型
	%% 1、徽记激活
	%% 2、火觉醒
	%% 3、水觉醒
	%% 4、风觉醒
	%% 5、土觉醒
	%% 6、完美觉醒
	awakenType,
	%% 索引
	index,
	%% 觉醒条件
	%% 填写该坐骑的觉醒类型枚举，需所有条件均达成
	condition,
	%% 觉醒消耗
	%% （道具id，数量）
	consume,
	%% 觉醒属性
	%% (属性ID，属性值)
	attrAdd
}).

-endif.
