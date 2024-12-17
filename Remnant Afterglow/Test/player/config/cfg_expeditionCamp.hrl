-ifndef(cfg_expeditionCamp_hrl).
-define(cfg_expeditionCamp_hrl, true).

-record(expeditionCampCfg, {
	%% 阵营编号
	%% 1红色阵营
	%% 2蓝色阵营
	%% 3绿色阵营
	iD,
	%% 各阶段的阵营基地
	%% 填写城池id【ExpeditionCity_1_城池】
	%% ID
	%% 1阶段城池ID|2阶段城池ID|3阶段城池ID|4阶段城池ID
	base,
	%% 阵营名字
	name,
	%% 强阵营-浮空岛
	%% 填写城池id【ExpeditionCity_1_城池】ID
	island,
	%% 强阵营-各阵营前往浮空岛的城池-单向
	%% （阵营编号，城池ID）
	%% 填写城池id【ExpeditionCity_1_城池】ID
	landCity
}).

-endif.
