-ifndef(cfg_artifactCreate_hrl).
-define(cfg_artifactCreate_hrl, true).

-record(artifactCreateCfg, {
	%% ID不大于2000
	iD,
	%% {属性ID,属性万分比}
	%% 属性ID：AttrList中属性ID
	%% 属性值=属性万分比*AttrList最大值/10^4
	%% 若没有为0
	ensureList,
	%% {随机事件1,权值1,属性ID}
	%% 1.当属性ID为0时，及为空
	%% 2.若对应属性ID中AttrList没有，也为空
	%% 3.创建属性最多为6条（如果EnsureList中属性已配置3条，则该字段随机事件最多配3个）
	%% 4.同一事件的权值之和必须等于10000.(程序要求）
	randAttrID,
	%% {随机事件1,权值1,属性万分比1,属性万分比2}
	%% 随机中的事件中，再从属性万分比1到属性万分比2随机一个值,为该属性的万分比
	%% 当序号为0时，及为空
	%% 同一事件的权值之和必须等于10000.(程序要求）
	randAttrVal,
	%% 全队属性序列
	%% {属性ID,最大值}
	%% 属性ID
	%% 最大值
	attrList
}).

-endif.
