-ifndef(cfg_expeditionBase2_hrl).
-define(cfg_expeditionBase2_hrl, true).

-record(expeditionBase2Cfg, {
	%% 城战奖励
	iD,
	%% 边境城池战中，攻击城池boss获得功勋：{累计伤害值，奖励功勋值}
	%% boss死亡时，给所有造成伤害的玩家奖励功勋值=INT(玩家伤害总值/累积伤害值)*奖励功勋值
	expeditionHurtMertial,
	%% 边境城池战中，攻击城池boss获得战功：{累计伤害值，货币ID，奖励战功}
	%% boss死亡时，给所有造成伤害的玩家奖励功勋值=INT(玩家伤害总值/累积伤害值)*奖励战功
	expeditionHurtMertial1,
	%% 边境城池战中，攻击城池boss获得征服点：{累计伤害值，奖励征服点}
	%% boss死亡时，给所有造成伤害的玩家奖励功勋值=INT(玩家伤害总值/累积伤害值)*奖励征服点
	expeditionHurtMertial2,
	%% 边境城池战中，攻击城池boss获得荣誉点：{累计伤害值，奖励荣誉点}
	%% boss死亡时，给所有造成伤害的玩家奖励功勋值=INT(玩家伤害总值/累积伤害值)*奖励荣誉点
	expeditionHurtMertial3,
	%% 边境城池战中，攻击城池boss获得【功勋、战功(货币30)、征服点、荣誉点】
	%% 根据对BOSS造成的伤害排名给奖励：
	%% ·单个城池BOSS进行统计
	%% ·后面字段的“攻击城池boss获得上限”对该字段配置生效.
	%% {排名段，功勋、战功(货币30)、征服点、荣誉点}
	%% {1,10,10,10,10}|{2,9,9,9,9}|{5,8,8,8,8}|{10,5,5,5,5}
	%% 伤害第1名，获得：10点功勋、10点战功(货币30)、10点征服点、10点荣誉点；
	%% 伤害第2-4名，获得：9点功勋、9点战功(货币30)、9点征服点、9点荣誉点；
	%% 伤害第5-9名，获得：8点功勋、8点战功(货币30)、8点征服点、8点荣誉点；
	%% 伤害第10名及以后，获得：5点功勋、5点战功(货币30)、5点征服点、5点荣誉点；
	%% 该字段处理好后，以下字段不再使用：
	%% ExpeditionHurtMertial
	%% ExpeditionHurtMertial1
	%% ExpeditionHurtMertial2
	%% ExpeditionHurtMertial3
	expeditionHurt,
	%% 边境远征城池战中（含皇城战），玩家能量点消耗：
	%% {每x时间扣除能量点，时间(秒)，每击杀1名玩家扣除能量点，每死亡1次扣除能量点}
	%% 例{1,20,2,1}:
	%% 每20秒扣除1点能量点，每击杀1名玩家扣除2点能量点，每死亡1次扣除1点能量点
	expedition_UrbanWarfare1,
	%% 边境远征城池战中（含皇城战），单场活动，功勋获得上限：
	%% {单场活动获得总上限，击杀获得上限，助攻获得上限，死亡获得上限，攻击城池boss获得上限}，总上限可控制后面4个途径的.
	%% ·填0表示：无限制
	%% 例：
	%% {1200,600,200,200,0}：击杀上限600，助攻上限200，死亡上限200，boss伤害无上限；总上限1200。如果已经达到1200，那么不在获得。
	%% {0,600,200,200,200,0}：击杀上限600，助攻上限200，死亡上限200，boss伤害无上限；无总上限。那么boss伤害可以一直获得。
	expedition_UrbanWarfare2,
	%% 边境远征城池战中（含皇城战），单场活动，击杀获得功勋：
	%% {击杀人数区间1，击杀人数区间2，每击杀1人获得}
	%% ·区间2配置0时，表示无线大；整体配置0表示不通过这个途径获得
	%% 例
	%% {1,20,20}|{21,50,10}|{51,0,1}:
	%% 击杀1-20人，每击杀1人获得20点；
	%% 击杀21-50人，每击杀1人获得10点；
	%% 击杀51人及以上，每击杀1人获得1点.
	expedition_UrbanWarfare2_1,
	%% 边境远征城池战中（含皇城战），单场活动，助攻获得功勋：
	%% {助攻人数区间1，助攻人数区间2，每助攻1次获得}
	%% ·区间2配置0时，表示无线大；整体配置0表示不通过这个途径获得
	%% 例
	%% {1,20,5}|{21,50,3}|{51,0,1}:
	%% 助攻1-20人，每助攻1人获得5点；
	%% 助攻21-50人，每助攻1人获得3点；
	%% 助攻51人及以上，每助攻1人获得1点.
	expedition_UrbanWarfare2_2,
	%% 边境远征城池战中（含皇城战），单场活动，死亡获得功勋：
	%% {次数区间1，次数区间2，每死亡1次获得}
	%% ·区间2配置0时，表示无线大；整体配置0表示不通过这个途径获得
	%% 例
	%% {1,20,5}|{21,50,3}|{51,0,1}:
	%% 死亡1-20人，每死亡1次获得5点；
	%% 死亡21-50人，每死亡1次获得3点；
	%% 死亡51人及以上，每死亡1次获得1点.
	expedition_UrbanWarfare2_3,
	%% 边境远征城池战中（含皇城战），单场活动，战功获得上限：
	%% {单场活动获得总上限，击杀获得上限，助攻获得上限，死亡获得上限，攻击城池boss获得上限}，总上限可控制后面4个途径的.
	%% ·填0表示：无限制
	%% 例：
	%% {1200,600,200,200,0}：击杀上限600，助攻上限200，死亡上限200，boss伤害无上限；总上限1200。如果已经达到1200，那么不在获得。
	%% {0,600,200,200,200,0}：击杀上限600，助攻上限200，死亡上限200，boss伤害无上限；无总上限。那么boss伤害可以一直获得。
	expedition_UrbanWarfare3,
	%% 边境远征城池战中（含皇城战），单场活动，击杀获得战功：
	%% {击杀人数区间1，击杀人数区间2，每击杀1人获得}
	%% ·区间2配置0时，表示无线大；整体配置0表示不通过这个途径获得
	%% 例
	%% {1,20,20}|{21,50,10}|{51,0,1}:
	%% 击杀1-20人，每击杀1人获得20点；
	%% 击杀21-50人，每击杀1人获得10点；
	%% 击杀51人及以上，每击杀1人获得1点.
	expedition_UrbanWarfare3_1,
	%% 边境远征城池战中（含皇城战），单场活动，助攻获得战功：
	%% {助攻人数区间1，助攻人数区间2，每助攻1次获得}
	%% ·区间2配置0时，表示无线大；整体配置0表示不通过这个途径获得
	%% 例
	%% {1,20,5}|{21,50,3}|{51,0,1}:
	%% 助攻1-20人，每助攻1人获得5点；
	%% 助攻21-50人，每助攻1人获得3点；
	%% 助攻51人及以上，每助攻1人获得1点.
	expedition_UrbanWarfare3_2,
	%% 边境远征城池战中（含皇城战），单场活动，死亡获得战功：
	%% {次数区间1，次数区间2，每死亡1次获得}
	%% ·区间2配置0时，表示无线大；整体配置0表示不通过这个途径获得
	%% 例
	%% {1,20,5}|{21,50,3}|{51,0,1}:
	%% 死亡1-20人，每死亡1次获得5点；
	%% 死亡21-50人，每死亡1次获得3点；
	%% 死亡51人及以上，每死亡1次获得1点.
	expedition_UrbanWarfare3_3,
	%% 边境远征城池战中（含皇城战），单场活动，征服点获得上限：
	%% {单场活动获得总上限，击杀获得上限，助攻获得上限，死亡获得上限，攻击城池boss获得上限}，总上限可控制后面4个途径的.
	%% ·填0表示：无限制
	%% 例：
	%% {1200,600,200,200,0}：击杀上限600，助攻上限200，死亡上限200，boss伤害无上限；总上限1200。如果已经达到1200，那么不在获得。
	%% {0,600,200,200,200,0}：击杀上限600，助攻上限200，死亡上限200，boss伤害无上限；无总上限。那么boss伤害可以一直获得。
	expedition_UrbanWarfare4,
	%% 边境远征城池战中（含皇城战），单场活动，击杀获得征服点：
	%% {击杀人数区间1，击杀人数区间2，每击杀1人获得}
	%% ·区间2配置0时，表示无线大；整体配置0表示不通过这个途径获得
	%% 例
	%% {1,20,20}|{21,50,10}|{51,0,1}:
	%% 击杀1-20人，每击杀1人获得20点；
	%% 击杀21-50人，每击杀1人获得10点；
	%% 击杀51人及以上，每击杀1人获得1点.
	expedition_UrbanWarfare4_1,
	%% 边境远征城池战中（含皇城战），单场活动，助攻获得征服点：
	%% {助攻人数区间1，助攻人数区间2，每助攻1次获得}
	%% ·区间2配置0时，表示无线大；整体配置0表示不通过这个途径获得
	%% 例
	%% {1,20,5}|{21,50,3}|{51,0,1}:
	%% 助攻1-20人，每助攻1人获得5点；
	%% 助攻21-50人，每助攻1人获得3点；
	%% 助攻51人及以上，每助攻1人获得1点.
	expedition_UrbanWarfare4_2,
	%% 边境远征城池战中（含皇城战），单场活动，死亡获得征服点：
	%% {次数区间1，次数区间2，每死亡1次获得}
	%% ·区间2配置0时，表示无线大；整体配置0表示不通过这个途径获得
	%% 例
	%% {1,20,5}|{21,50,3}|{51,0,1}:
	%% 死亡1-20人，每死亡1次获得5点；
	%% 死亡21-50人，每死亡1次获得3点；
	%% 死亡51人及以上，每死亡1次获得1点.
	expedition_UrbanWarfare4_3,
	%% 边境远征城池战中（含皇城战），单场活动，荣誉点获得上限：
	%% {单场活动获得总上限，击杀获得上限，助攻获得上限，死亡获得上限，攻击城池boss获得上限}，总上限可控制后面4个途径的.
	%% ·填0表示：无限制
	%% 例：
	%% {1200,600,200,200,0}：击杀上限600，助攻上限200，死亡上限200，boss伤害无上限；总上限1200。如果已经达到1200，那么不在获得。
	%% {0,600,200,200,200,0}：击杀上限600，助攻上限200，死亡上限200，boss伤害无上限；无总上限。那么boss伤害可以一直获得。
	expedition_UrbanWarfare5,
	%% 边境远征城池战中（含皇城战），单场活动，击杀获得荣誉点：
	%% {击杀人数区间1，击杀人数区间2，每击杀1人获得}
	%% ·区间2配置0时，表示无线大；整体配置0表示不通过这个途径获得
	%% 例
	%% {1,20,20}|{21,50,10}|{51,0,1}:
	%% 击杀1-20人，每击杀1人获得20点；
	%% 击杀21-50人，每击杀1人获得10点；
	%% 击杀51人及以上，每击杀1人获得1点.
	expedition_UrbanWarfare5_1,
	%% 边境远征城池战中（含皇城战），单场活动，助攻获得荣誉点：
	%% {助攻人数区间1，助攻人数区间2，每助攻1次获得}
	%% ·区间2配置0时，表示无线大；整体配置0表示不通过这个途径获得
	%% 例
	%% {1,20,5}|{21,50,3}|{51,0,1}:
	%% 助攻1-20人，每助攻1人获得5点；
	%% 助攻21-50人，每助攻1人获得3点；
	%% 助攻51人及以上，每助攻1人获得1点.
	expedition_UrbanWarfare5_2,
	%% 边境远征城池战中（含皇城战），单场活动，死亡获得荣誉点：
	%% {次数区间1，次数区间2，每死亡1次获得}
	%% ·区间2配置0时，表示无线大；整体配置0表示不通过这个途径获得
	%% 例
	%% {1,20,5}|{21,50,3}|{51,0,1}:
	%% 死亡1-20人，每死亡1次获得5点；
	%% 死亡21-50人，每死亡1次获得3点；
	%% 死亡51人及以上，每死亡1次获得1点.
	expedition_UrbanWarfare5_3,
	%% 边境远征强阵营突袭中，单场活动，功勋获得上限：
	%% {单场活动获得总上限，击杀获得上限，助攻获得上限，死亡获得上限，攻击城池boss获得上限}，总上限可控制后面4个途径的.
	%% ·填0表示：无限制
	%% 例：
	%% {1200,600,200,200,0}：击杀上限600，助攻上限200，死亡上限200，boss伤害无上限；总上限1200。如果已经达到1200，那么不在获得。
	%% {0,600,200,200,200,0}：击杀上限600，助攻上限200，死亡上限200，boss伤害无上限；无总上限。那么boss伤害可以一直获得。
	expedition_UrbanWarfare6,
	%% 边境远征强阵营突袭中，单场活动，击杀获得功勋：
	%% {击杀人数区间1，击杀人数区间2，每击杀1人获得}
	%% ·区间2配置0时，表示无线大；整体配置0表示不通过这个途径获得
	%% 例
	%% {1,20,20}|{21,50,10}|{51,0,1}:
	%% 击杀1-20人，每击杀1人获得20点；
	%% 击杀21-50人，每击杀1人获得10点；
	%% 击杀51人及以上，每击杀1人获得1点.
	expedition_UrbanWarfare6_1,
	%% 边境远征强阵营突袭中，单场活动，助攻获得功勋：
	%% {助攻人数区间1，助攻人数区间2，每助攻1次获得}
	%% ·区间2配置0时，表示无线大；整体配置0表示不通过这个途径获得
	%% 例
	%% {1,20,5}|{21,50,3}|{51,0,1}:
	%% 助攻1-20人，每助攻1人获得5点；
	%% 助攻21-50人，每助攻1人获得3点；
	%% 助攻51人及以上，每助攻1人获得1点.
	expedition_UrbanWarfare6_2,
	%% 边境远征强阵营突袭中，单场活动，死亡获得功勋：
	%% {次数区间1，次数区间2，每死亡1次获得}
	%% ·区间2配置0时，表示无线大；整体配置0表示不通过这个途径获得
	%% 例
	%% {1,20,5}|{21,50,3}|{51,0,1}:
	%% 死亡1-20人，每死亡1次获得5点；
	%% 死亡21-50人，每死亡1次获得3点；
	%% 死亡51人及以上，每死亡1次获得1点.
	expedition_UrbanWarfare6_3
}).

-endif.