-ifndef(cfg_firstTowerStrengthen_hrl).
-define(cfg_firstTowerStrengthen_hrl, true).

-record(firstTowerStrengthenCfg, {
	%% 翅膀品质ID
	%% 每拥有一个对应稀有度的翅膀，职业塔内属性获得对应加成。
	%% WingBaseNew（RareType）
	%% 1000：品质0
	%% 1001：品质1
	%% 1002：品质2
	%% 1003：品质3
	%% 1004：品质4
	%% 1005：品质5
	iD,
	%% 加成数(起始数量，单位加成，最大加成）
	%% 加成数=MIN(INT(Max((当前数量-起始数量),0)/单位加成),最大加成)
	%% 有多少个加成数，就提供多少个buff
	%% 当前数量：当前已激活的对应品质翅膀数量
	%% 单位加成：多少个翅膀提供一层加成
	%% 最大加成：最多提供的加成个数
	quantity,
	%% BUFFID
	bUFF
}).

-endif.
