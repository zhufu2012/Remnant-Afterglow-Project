%%%-------------------------------------------------------------------
%%% @author xiexiaobo
%%% @copyright (C) 2018, Double Game
%%% @doc 属性公式定义
%%% @end
%%% Created : 2018-05-08 15:50
%%%-------------------------------------------------------------------
-ifndef(attribute_hrl).
-define(attribute_hrl, true).


-define(PlayerProp, player_prop).

-define(Type_1, 1).            %% 1：类型1-基础伤害值
-define(Type_2, 2).            %% 2：类型2-基础系数
-define(Type_3, 3).            %% 3：类型3-部分基础系数
-define(Type_4, 4).            %% 4：类型4-部分技能系数
-define(Type_5, 5).            %% 5：类型5-部分伤害值
-define(Type_6, 6).            %% 6：类型6-转系数值
-define(Type_7, 7).            %% 7：类型7-最终系数
-define(Type_8, 8).            %% 8：类型8-依附系数
-define(Type_9, 9).            %% 9：类型9-最终系数
-define(Type_10, 10).        %% 10：系数额外类型1-系数附带固定战力
-define(Type_11, 11).        %% 11：系数额外类型2-系数附带固定战力
-define(Type_12, 12).        %% 12：系数额外类型3-系数附带固定战力
-define(Type_13, 13).        %% 13：其他战力类型-战力属性
-define(DEFAULT_ATTR_PARAM, #{?Type_1 => 0, ?Type_2 => 0, ?Type_3 => 0, ?Type_4 => 0, ?Type_5 => 0, ?Type_6 => 0,
	?Type_7 => 0, ?Type_8 => 0, ?Type_9 => 0, ?Type_10 => 0, ?Type_11 => 0, ?Type_12 => 0, ?Type_13 => 0}).

%% 属性
-record(prop, {
	index = 0,            %% 属性id
	base = 0,                %% 基础值
	add = 0,                %% 加法值
	multi = 0                %% 乘法值(万分比)
}).

%% 玩家属性
-record(attr_part, {
	attr = [],                    %% 最终属性
	base_role = [],            %% 角色基础属性
	eq = [],                    %% 装备属性(不包括强化的属性  下同)
	eq_intensify = [],        %% 装备强化属性   [{Index, Value}] 所有的加成属性保持此格式
	eq_suit = [],               %% 装备套装加成属性   攻击、防御、生命、破甲
	gem_base = [],                %% 宝石基础属性       攻击、防御、生命、破甲
	yiling = [],                %% 翼灵属性
	shouling = []            %% 兽灵属性
}).

%% 分战力类型
-define(BattleValue_Start, 1).          %%  开始序号
-define(BattleValue_Rune, 1).           %%	1. 龙印
-define(BattleValue_Pet, 2).            %%	2. 宠物
-define(BattleValue_Wing, 3).           %%	3. 翅膀
-define(BattleValue_Mount, 4).          %%	4. 坐骑
-define(BattleValue_Gd, 5).             %%	5. 龙神
-define(BattleValue_Card, 6).           %%	6. 图鉴（卡片）
-define(BattleValue_Honor, 7).          %%	7. 头衔
-define(BattleValue_EqIntensify, 8).    %%	8. 装备强化
-define(BattleValue_EqGem, 9).          %%	9. 宝石镶嵌
-define(BattleValue_Skill, 10).         %%	10. 技能
-define(BattleValue_Relic, 11).         %%	11. 圣物
-define(BattleValue_Cup, 12).           %%	12. 奖杯
-define(BattleValue_Fashion, 13).       %%	13. 时装
-define(BattleValue_Title, 14).         %%	14. 称号
-define(BattleValue_DressUp, 15).       %%	15. 装扮
-define(BattleValue_Constellation, 16). %%	16. 泰坦（星座）
-define(BattleValue_Weapon, 17).        %%	17. 神兵
-define(BattleValue_Astrolabe, 18).     %%	18. 神灵（黄金契约）
-define(BattleValue_HolyShield, 19).     %% 19. 神盾
-define(BattleValue_ShengJia, 20).      %%	20. 神甲
-define(BattleValue_ShengWen, 21).      %%	21. 神纹
-define(BattleValue_PlayerRing, 23).     %%	23. 信物
-define(BattleValue_End, 23).           %%  结束序号
-define(BattleValue_Other, 99).         %%	99. 其他

%% 服务器使用的分战力类型（当需要用某系统分战力但不在策划规划分战力中）
-define(ServerBattleValue_Start, 1000).       %% 	开始序号
-define(ServerBattleValue_Eq, 1000).          %%	1000. 装备
-define(ServerBattleValue_EqSuit, 1001).      %%	1001. 装备套装
-define(ServerBattleValue_EqBase, 1002).      %%	1002. 装备基础
-define(ServerBattleValue_EqAdd, 1003).       %%	1003. 装备追加
-define(ServerBattleValue_EqCollect, 1004).   %%	1004. 装备收藏
-define(ServerBattleValue_Guard, 1005).       %%	1005. 守护
-define(ServerBattleValue_GodOrnament, 1006). %%	1006. 神饰
-define(ServerBattleValue_Ring, 1007).        %%	1007. 魔戒
-define(ServerBattleValue_Pill, 1008).        %%	1008. 果实
-define(ServerBattleValue_BloodLine, 1009).   %%	1009. 血脉
-define(ServerBattleValue_Fazhen, 1010).      %%	1010. 符文
-define(ServerBattleValue_End, 1010).         %%	结束序号
%% 客户端也要用这些
-define(SendClientListEx, [?ServerBattleValue_EqSuit, ?ServerBattleValue_EqBase, ?ServerBattleValue_EqAdd, ?ServerBattleValue_EqCollect,
	?ServerBattleValue_Guard, ?ServerBattleValue_GodOrnament, ?ServerBattleValue_Ring, ?ServerBattleValue_Pill, ?ServerBattleValue_BloodLine, ?ServerBattleValue_Fazhen]).

-define(FixExpType_0, 0).    %%  所有渠道经验加成万分比
-define(FixExpType_1, 1).    %%  杀怪掉落经验加成万分比
-define(FixExpType_2, 2).    %%  挂机产出经验加成万分比
-define(FixExpType_3, 3).    %%  精英本经验加成万分比
-define(FixExpType_4, 4).    %%  主线副本经验加成万分比
-define(FixExpType_5, 5).    %%  主线任务经验加成万分比
-define(FixExpType_6, 6).    %%  支线任务经验加成万分比
-define(FixExpType_7, 7).    %%  赏金任务经验加成万分比
-define(FixExpType_8, 8).    %%  使用经验丹经验加成万分比
-define(FixExpType_9, 9).    %%  祈福经验加成万分比
-define(FixExpType_10, 10).    %%   竞技场经验加成万分比
-define(FixExpType_11, 11).    %%   炎魔试炼每分钟经验产出加成万分比
-define(FixExpType_12, 12).    %%   万神殿每分钟经验产出加成万分比
-define(FixExpType_13, 13).    %%   日常经验产出加成万分比


-define(AddExpType_1, 1).    %% 打怪获得经验
-define(AddExpType_2, 2).    %% 每X秒获得经验
-define(AddExpType_3, 3).    %% 结婚获得经验
-define(AddExpType_4, 4).    %% 战盟


%% 属性类型 1. 固定属性 2. 成长属性加成 3. 针对某系统进行属性加成  4. 针对全局单一属性加成  5 .多属性加成
-define(MAP(Map, Key), maps:get(Key, Map, 0)).

-define(P_ObjectType, -1).          %%	object type  不是ID类型  注意
-define(P_ObjectID, -2).            %%	object id	注意不能用 0
-define(P_RoleId, -3).            %%	role id	注意不能用 0
-define(P_PetElem, -4).            %%	英雄类型 %% 1风-暗影 2火-审批 3土-黎明 4-幻兽
-define(P_ShengMing, 1).            %%	生命
-define(P_ShengMingP, 2).           %%	最大生命万分比
-define(P_GongJi, 3).               %%	攻击
-define(P_FangYu, 4).               %%	防御
-define(P_PoJia, 5).                %%	破甲
-define(P_HuJia, 6).                %%	护甲
-define(P_YuanSuGJ1, 7).            %%	元素攻击1
-define(P_YuanSuGJ2, 8).            %%	元素攻击2
-define(P_YuanSuGJ3, 9).            %%	元素攻击3
-define(P_YuanSuGJ4, 10).           %%	元素攻击4
-define(P_YuanSuFY1, 11).           %%	元素防御1
-define(P_YuanSuFY2, 12).           %%	元素防御2
-define(P_YuanSuFY3, 13).           %%	元素防御3
-define(P_YuanSuFY4, 14).           %%	元素防御4
-define(P_MingZhong, 15).           %%	命中值
-define(P_ShanBi, 16).              %%	闪避值
-define(P_MingZhongLv, 17).         %%	命中率
-define(P_ShanBiLv, 18).            %%	闪避率
-define(P_BaoJi, 19).               %%	暴击值
-define(P_RenXing, 20).             %%	韧性值
-define(P_BaoJiLv, 21).             %%	暴击率
-define(P_RenXingLv, 22).           %%	韧性率
-define(P_BaoShangJiaChen, 23).     %%	暴伤加成  TODO 和一个global里面的初始值想加
-define(P_BaoShangJianMian, 24).    %%	暴伤减免
-define(P_HuiXinLv, 25).            %%	会心率
-define(P_HuiXinDiKangLv, 26).      %%	抗会率
-define(P_HuiShangJiaChen, 27).     %%	会伤加成  TODO  和一个global里面的初始值想加
-define(P_HuiShangJianMian, 28).    %%	会伤减免
-define(P_ZhuoYueLv, 29).           %%	卓越率
-define(P_ZhuoYueDiKangLv, 30).     %%	抗卓率
-define(P_ZhiMingLv, 31).           %%	致命率
-define(P_ZhiMingDiKangLv, 32).     %%	抗致率
-define(P_GeDangLv, 33).            %%	格挡率
-define(P_GeDangDiKangLv, 34).      %%	抗格率
-define(P_GeMianJiaChen, 35).       %%	格免加成   TODO  和一个global里面的初始值想加
-define(P_GeMianJianMian, 36).      %%	格免减免
-define(P_ShangHaiJiaChen, 37).     %%	伤害加成
-define(P_ShangHaiJianMian, 38).    %%	伤害减免
-define(P_PVPJiaChen, 39).          %%	PVP伤害加成
-define(P_PVPJianMian, 40).         %%	PVP伤害减免
-define(P_PVEJiaChen, 41).          %%	PVE伤害加成
-define(P_PVEJianMian, 42).         %%	PVE伤害减免
-define(P_PVMJiaChen, 43).          %%	小怪伤害加成
-define(P_PVMJianMian, 44).         %%	小怪伤害减免
-define(P_PVBJiaChen, 45).          %%	精英伤害加成
-define(P_PVBJianMian, 46).         %%	精英伤害减免
-define(P_JiNengJiaChen, 47).       %%	技能伤害加成
-define(P_JiNengJianMian, 48).      %%	技能伤害减免
-define(P_JiYunJiaChen, 49).        %%	技能击晕加成
-define(P_JiYunJianMian, 50).       %%	技能击晕减免
-define(P_JiFeiJiaChen, 51).        %%	技能击飞加成
-define(P_JiFeiJianMian, 52).       %%	技能击飞减免
-define(P_JiDaoJiaChen, 53).        %%	技能击倒加成
-define(P_JiDaoJianMian, 54).       %%	技能击倒减免
-define(P_JiNengShangHai, 55).      %%	技能伤害值
-define(P_JiNengJianShang, 56).     %%	技能减伤值
-define(P_JiYunShangHai, 57).       %%	技能击晕伤害值
-define(P_JiYunJianShang, 58).      %%	技能击晕减伤值
-define(P_JiFeiShangHai, 59).       %%	技能击飞伤害值
-define(P_JiFeiJianShang, 60).      %%	技能击飞减伤值
-define(P_JiDaoShangHai, 61).       %%	技能击倒伤害值
-define(P_JiDaoJianShang, 62).      %%	技能击倒减伤值
-define(P_PVAJiaChen, 63).          %%	最终伤害加成
-define(P_PVAJianMian, 64).         %%	最终伤害减免
-define(P_ShengMingW, 65).          %%	生命万分比
-define(P_GongJiW, 66).             %%	攻击万分比
-define(P_FangYuW, 67).             %%	防御万分比
-define(P_PoJiaW, 68).              %%	破甲万分比
-define(P_YuanSuGJW1, 69).          %%	元素攻击1万分比
-define(P_YuanSuGJW2, 70).          %%	元素攻击2万分比
-define(P_YuanSuGJW3, 71).          %%	元素攻击3万分比
-define(P_YuanSuGJW4, 72).          %%	元素攻击4万分比
-define(P_YuanSuFYW1, 73).          %%	元素防御1万分比
-define(P_YuanSuFYW2, 74).          %%	元素防御2万分比
-define(P_YuanSuFYW3, 75).          %%	元素防御3万分比
-define(P_YuanSuFYW4, 76).          %%	元素防御4万分比
-define(P_MingZhongW, 77).          %%	命中值万分比
-define(P_ShanBiW, 78).             %%	闪避值万分比
-define(P_BaoJiW, 79).              %%	暴击值万分比
-define(P_RenXingW, 80).            %%	韧性值万分比
-define(P_XingYunZhi, 81).          %%	幸运值万分比
-define(P_CSGuDingGj, 82).            %%	承受固定攻击
-define(P_JZSHXiuZheng, 83).      %%	节奏伤害修正
-define(P_ZhiLiaoXiuZheng, 84).     %%	最终治疗修正
-define(P_GuDingZhanDouLi, 85).     %%	固定战斗力
-define(P_YiDongSuDu, 86).          %%	移动速度
-define(P_ShengMing3Ji, 87).        %%  每3级提升生命值XX点
-define(P_GongJi3Ji, 88).            %% 	每3级提升攻击XX点
-define(P_FangYu3Ji, 89).            %% 	每3级提升防御XX点
-define(P_PoJia3Ji, 90).            %% 	每3级提升破甲XX点
-define(P_YuanSuGJ, 91).            %% 	元素攻击
-define(P_YuanSuFY, 92).            %% 	元素防御
-define(P_YuanSuGJW, 93).            %% 	元素攻击万分比
-define(P_YuanSuFYW, 94).           %% 	元素防御万分比
-define(P_XingYunZhiP, 95).         %% 	幸运值
-define(P_RenWuJiChuSMW, 96).       %% 	人物基础生命万分比
-define(P_RenWuJiChuGJW, 97).       %% 	人物基础攻击万分比
-define(P_RenWuJiChuFYW, 98).       %% 	人物基础防御万分比
-define(P_RenWuJiChuPJW, 99).       %% 	人物基础破甲万分比
-define(P_ZhuangBeiJiChuSMW, 100).  %% 	装备基础生命万分比
-define(P_ZhuangBeiJiChuGJW, 101).  %% 	装备基础攻击万分比
-define(P_ZhuangBeiJiChuFYW, 102).  %% 	装备基础防御万分比
-define(P_ZhuangBeiJiChuPJW, 103).  %% 	装备基础破甲万分比
-define(P_ZhuangBeiQHW, 104).       %% 	装备强化加成万分比
-define(P_MoLingW, 105).            %% 	魔灵属性加成万分比
-define(P_YiLingW, 106).            %% 	翼灵属性加成万分比
-define(P_ShouLingW, 107).            %% 	兽灵属性加成万分比
-define(P_ShengLi1W, 108).            %% 	圣灵之雷1灵属性加成万分比
-define(P_ShengLi2W, 109).            %% 	圣灵之水2灵属性加成万分比
-define(P_ShengLi3W, 110).            %% 	圣灵之火3灵属性加成万分比
-define(P_ShengLi4W, 111).            %% 	圣灵之土4灵属性加成万分比
-define(P_ShengHuiW, 112).            %% 	圣徽属性加成万分比
-define(P_ZhongJiLv, 113).            %% 	技能重击率
-define(P_XuRuoLv, 114).            %% 	技能虚弱率
-define(P_ShenQiSMW, 115).                        %%  当前神祗激活属性生命加成万分比
-define(P_ShenQIGJW, 116).                        %%  当前神祗激活属性攻击加成万分比
-define(P_ShenQiFYW, 117).                        %%  当前神祗激活属性防御加成万分比
-define(P_ShenQiPJW, 118).                        %%  当前神祗激活属性破甲加成万分比
-define(P_ShenQiZBSMW, 119).                    %%  当前神祗装备属性生命加成万分比
-define(P_ShenQiZBGJW, 120).                    %%  当前神祗装备属性攻击加成万分比
-define(P_ShenQiZBFYW, 121).                    %%  当前神祗装备属性防御加成万分比
-define(P_ShenQiZBPJW, 122).                    %%  当前神祗装备属性破甲加成万分比
-define(P_QuanTiShenQiSMW, 123).                %%  全体神祗激活属性生命加成万分比
-define(P_QuanTiShenQiGJW, 124).                %%  全体神祗激活属性攻击加成万分比
-define(P_QuanTiShenQiFYW, 125).                %%  全体神祗激活属性防御加成万分比
-define(P_QuanTiShenQiPJW, 126).                %%  全体神祗激活属性破甲加成万分比
-define(P_QuanTiShenQiZBSMW, 127).                %%  全体神祗装备属性生命加成万分比
-define(P_QuanTiShenQiZBGJW, 128).                %%  全体神祗装备属性攻击加成万分比
-define(P_QuanTiShenQiZBFYW, 129).                %%  全体神祗装备属性防御加成万分比
-define(P_QuanTiShenQiZBPJW, 130).                %%  全体神祗装备属性破甲加成万分比
-define(P_NuQi, 131).                        %% 	怒气
-define(P_CSNuQi, 132).                    %% 	初始怒气
-define(P_SSNuQi, 133).                    %% 	受伤比恢复怒气
-define(P_SSNuQiJiaC, 134).                %% 	受伤获得怒气加成
-define(P_JNNuQiJiaC, 135).                %% 	技能获得怒气加成
-define(P_JianSuQH, 136).                %% 减速强化
-define(P_DingShengQH, 137).            %% 定身强化
-define(P_SuoZuQH, 138).                %% 锁足强化
-define(P_RuanKongQH, 139).            %% 软控强化
-define(P_YingKongQH, 140).            %% 硬控强化
-define(P_JianSuDK, 141).                %% 减速抵抗
-define(P_DingShengDK, 142).            %% 定身抵抗
-define(P_SuoZuDK, 143).                %% 锁足抵抗
-define(P_RuanKongDK, 144).            %% 软控抵抗
-define(P_YingKongDK, 145).            %% 硬控抵抗
-define(P_SCGDGJ, 146).                %% 承受固定攻击
-define(P_TaoZhuangJCW, 147).            %% 套装基础属性万分比
-define(P_BaoShiJCW, 148).            %% 宝石基础属性万分比
-define(P_HaishenJCW, 149).             %% 海神套装基础加成万分比
-define(P_HaishenJPW, 150).             %% 海神套装极品加成万分比
-define(P_HunlingSJW, 151).             %% 魂灵(器灵)升级属性加成万分比
-define(P_ZhuiMingW, 152).                %% 追命一击触发几率
-define(P_JueShanW, 153).                %% 绝对闪避触发几率
-define(P_BinghunSJW, 154).             %% 兵魂升级属性加成万分比
-define(P_ShengDun, 155).                %% 圣盾值
-define(P_ShengDunSMZH, 156).            %% 圣盾生命转化
-define(P_ShengDunB, 157).                %% 圣盾比
-define(P_ShengDunHFB, 158).            %% 非战斗圣盾恢复比
-define(P_ShengDunZHFB, 159).            %% 战斗圣盾恢复比
-define(P_ShengDunXSB, 160).            %% 圣盾吸伤比
-define(P_ShengDunCSB, 161).            %% 圣盾穿伤比
-define(P_ShengDunSHJM, 162).            %% 圣盾伤害减免
-define(P_ShengDunSHJC, 163).            %% 圣盾伤害加成


-define(P_MAXINDEX, 163).           %%	属性最大索引值  目前只在计算全局战力的时候使用一下
-define(P_HaiShengZhuangBeiShengMing, 164).     %% 海神装备基础生命加成万分比
-define(P_HaiShengZhuangBeiGongJi, 165).        %% 海神装备基础攻击加成万分比
-define(P_HaiShengZhuangBeiFangYu, 166).        %% 海神装备基础防御加成万分比
-define(P_HaiShengZhuangBeiPoJia, 167).         %% 海神装备基础破甲加成万分比
-define(P_ZuoQiZhuangBeiShengMing, 168).        %% 坐骑装备基础生命加成万分比
-define(P_ZuoQiZhuangBeiGongJi, 169).           %% 坐骑装备基础攻击加成万分比
-define(P_ZuoQiZhuangBeiFangYu, 170).           %% 坐骑装备基础防御加成万分比
-define(P_ZuoQiZhuangBeiPoJia, 171).            %% 坐骑装备基础破甲加成万分比
-define(P_ChongWuZhuangBeiShengMing, 172).      %% 宠物装备基础生命加成万分比
-define(P_ChongWuZhuangBeiGongJi, 173).         %% 宠物装备基础攻击加成万分比
-define(P_ChongWuZhuangBeiFangYu, 174).         %% 宠物装备基础防御加成万分比
-define(P_ChongWuZhuangBeiPoJia, 175).          %% 宠物装备基础破甲加成万分比
-define(P_ChiBangZhuangBeiShengMing, 176).      %% 翅膀装备基础生命加成万分比
-define(P_ChiBangZhuangBeiGongJi, 177).         %% 翅膀装备基础攻击加成万分比
-define(P_ChiBangZhuangBeiFangYu, 178).         %% 翅膀装备基础防御加成万分比
-define(P_ChiBangZhuangBeiPoJia, 179).          %% 翅膀装备基础破甲加成万分比
-define(P_BaoShiZhuangBeiShengMing, 180).       %% 宝石装备基础生命加成万分比
-define(P_BaoShiZhuangBeiGongJi, 181).          %% 宝石装备基础攻击加成万分比
-define(P_BaoShiZhuangBeiFangYu, 182).          %% 宝石装备基础防御加成万分比
-define(P_BaoShiZhuangBeiPoJia, 183).           %% 宝石装备基础破甲加成万分比
-define(P_GushenShengZhuang_JiChu, 184).        %% 古神基础属性
-define(P_GushenShengZhuang_JiPin, 185).        %% 古神极品属性
-define(P_GushenShengZhuang_TongWeiJiChu, 186).           %% 同位普装基础属性
-define(P_GushenShengZhuang_TongWeiQHFangYu, 187).        %% 同位普装强化每提升5段，角色基础防御
-define(P_GushenShengZhuang_TongWeiQHGongJi, 188).        %% 同位普装强化每提升5段，角色基础攻击
-define(P_GushenShengZhuang_TongWeiBSGFangYu, 189).       %% 同位普装每镶嵌1颗7级或以上宝石，角色基础防御
-define(P_GushenShengZhuang_TongWeiBSGongJi, 190).        %% 同位普装每镶嵌1颗7级或以上宝石，角色基础攻击

%% 经济属性
-define(P_Economic_Start, 200).
-define(P_QuanJuDLW, 200).                %%   全局掉落加成万分比
-define(P_ChongWuDLW, 201).                %%   宠物及碎片掉落加成万分比
-define(P_ChiBangDLW, 202).                %%   翅膀及碎片掉落加成万分比
-define(P_ZuoQiDLW, 203).                    %%   坐骑及碎片掉落加成万分比
-define(P_ShengWuDLW, 204).                %%   圣物及碎片掉落加成万分比
-define(P_LongShenDLW, 205).                %%   龙神及碎片掉落加成万分比
-define(P_JLLongShenDLW, 206).            %%   精灵龙神及碎片掉落加成万分比
-define(P_LongShenWQDLW, 207).            %%   龙神武器及碎片掉落加成万分比
-define(P_RenWuCZDLW, 208).                %%   人物橙装以上掉落加成万分比
-define(P_RenWuHZDLW, 209).                %%   人物红装以上掉落加成万分比
-define(P_FZHeChengShiDLW, 210).            %%   粉色装备合成石掉落加成万分比
-define(P_ChongWuZBDLW, 211).                %%   宠物装备掉落加成万分比
-define(P_ChibangZBDLW, 212).                %%   翅膀装备掉落加成万分比
-define(P_ZuoQiZBDLW, 213).                %%   坐骑装备掉落加成万分比
-define(P_ShenShouCZDLW, 214).            %%   神兽橙装以上掉落加成万分比
-define(P_ShenShouHZDLW, 215).            %%   神兽红装以上掉落加成万分比
-define(P_ShenShouFZHeChengShiDLW, 216).    %%   神兽粉装合成石掉落加成万分比
-define(P_PeiShiCZDLW, 217).                %%   佩饰橙装以上掉落加成万分比
-define(P_ShengZh2LW, 218).                 %%   圣装材料2及以上掉落加成
-define(P_TongQianDLW, 250).                %%   铜钱掉落数量加成
-define(P_QuanBuJingYanW, 300).            %%   所有渠道经验加成万分比
-define(P_ShaGuaiJingYanW, 301).            %%   杀怪掉落经验加成万分比
-define(P_GuaJiJingYanW, 302).            %%   挂机产出经验加成万分比
-define(P_JingYingJingYanW, 303).            %%   精英本经验加成万分比
-define(P_ZhuFBJingYanW, 304).            %%   主线副本经验加成万分比
-define(P_ZhuRWJingYanW, 305).            %%   主线任务经验加成万分比
-define(P_ZhiRWJingYanW, 306).            %%   支线任务经验加成万分比
-define(P_ShangRWJingYanW, 307).            %%   赏金任务经验加成万分比
-define(P_JingYanDanW, 308).                %%   使用经验丹经验加成万分比
-define(P_QiFuJingYanW, 309).                %%   祈福经验加成万分比
-define(P_JJCJingYanW, 310).                %%   竞技场经验加成万分比
-define(P_YMSLFenZhongJingYanW, 311).        %%   炎魔试炼每分钟经验产出加成万分比
-define(P_WSDFenZhongJingYanW, 312).        %%   万神殿每分钟经验产出加成万分比
-define(P_GHMeiCiJingYanW, 313).        %%   篝火每次经验产出加成万分比
-define(P_RiChangJingYanW, 315).        %%   日常产出加成万分比
-define(P_Economic_End, 315).

-define(P_JZCSXiuZheng, 326).                %%   节奏承伤修正

-define(P_MountBaseSRW, 191).                %%   SR坐骑基础加成万分比
-define(P_MountBaseSSRW, 192).                %%   SSR坐骑基础加成万分比
-define(P_MountBaseSPW, 193).                %%   SP坐骑基础加成万分比
-define(P_MountBaseURW, 194).                %%   UR坐骑基础加成万分比
-define(P_PetBaseAW, 195).                %%   A宠物基础加成万分比
-define(P_PetBaseSW, 196).                %%   S宠物基础加成万分比
-define(P_PetBaseSSW, 197).                %%   SS宠物基础加成万分比
-define(P_PetBaseSSSW, 198).                %%   SSS宠物基础加成万分比
-define(P_WingBaseSRW, 501).                %%   SR翅膀基础加成万分比
-define(P_WingBaseSSRW, 502).                %%   SSR翅膀基础加成万分比
-define(P_WingBaseSPW, 503).                %%   SP翅膀基础加成万分比
-define(P_WingBaseURW, 504).                %%   UR翅膀基础加成万分比
-define(P_HolyBaseAW, 505).                %%   A圣物基础加成万分比
-define(P_HolyBaseSW, 506).                %%   S圣物基础加成万分比
-define(P_HolyBaseSSW, 507).                %%   SS圣物基础加成万分比
-define(P_HolyBaseSSSW, 508).               %%   SSS圣物基础加成万分比
-define(P_ZhuZhanGDBaseW, 509).             %%  主战龙神基础加成万分比
-define(P_JingLingGDBaseW, 510).            %%  精灵龙神基础加成万分比

-define(P_EMJiaChen, 511).               %%	恶魔最终伤害加成
-define(P_EMJianMian, 512).              %%	恶魔最终伤害减免
-define(P_TSJiaChen, 513).               %%	天使最终伤害加成
-define(P_TSJianMian, 514).              %%	天使最终伤害减免
-define(P_GLJiaChen, 515).               %%	古龙最终伤害加成
-define(P_GLJianMian, 516).              %%	古龙最终伤害减免

-define(P_ShengJiaBase, 517).           %% 圣甲值
-define(P_ShengJiaZZ, 518).             %% 圣甲增长率
-define(P_ShengJiaRX, 519).             %% 圣甲韧性
-define(P_YuanSuBJW, 520).              %% 元素暴击率
-define(P_YuanSuRXW, 521).              %% 元素韧性率
-define(P_YuanSuBaoShangJCW, 522).      %% 元素爆伤加成
-define(P_YuanSuBaoShangJMW, 523).      %% 元素爆伤减免
-define(P_YuanFang1ShengDunW, 524).     %% 火防圣盾率
-define(P_YuanFang2ShengDunW, 525).     %% 水防圣盾率
-define(P_YuanFang3ShengDunW, 526).     %% 风防圣盾率
-define(P_YuanFang4ShengDunW, 527).     %% 土防圣盾率
-define(P_YuanFangShengDunW, 528).      %% 元防圣盾率
-define(P_DamageFix, 529).              %% 上限限伤
-define(P_DamageLimit, 530).            %% 固定限伤

-define(P_LingwenBase, 531).            %% 灵纹基础属性加成
-define(P_MowenBase, 532).              %% 魔纹基础属性加成
-define(P_ShenwenBase, 533).            %% 神纹基础属性加成
-define(P_AllShengwenBase, 534).        %% 所有圣纹基础属性加成
-define(P_LingwenSuit, 535).            %% 所有灵纹套装属性加成
-define(P_MowenSuit, 536).              %% 所有魔纹套装属性加成
-define(P_ShenwenSuit, 537).            %% 所有神纹套装属性加成

-define(P_ZhuoYueShangHaiJiaCheng, 2001).        %% 卓越伤害加成
-define(P_ZhuoYueShangHaiJianMian, 2002).        %% 卓越伤害减免
-define(P_ZhiMingShangHaiJiaCheng, 2003).        %% 致命伤害加成
-define(P_ZhiMingShangHaiJianMian, 2004).        %% 致命伤害减免
-define(P_DuoBeiYiJiLv, 2005).                   %% 多倍一击率
-define(P_DuoBeiYiJiDiKangLv, 2006).             %% 抗多倍一击率
-define(P_DuoBeiShangHaiJiaCheng, 2007).         %% 多倍伤害加成
-define(P_DuoBeiShangHaiJianMian, 2008).         %% 多倍伤害减免
-define(P_ZhuiMingDiKangLv, 2009).               %% 抗追命几率
-define(P_ZhuiMingShangHaiJiaCheng, 2010).       %% 追命伤害加成
-define(P_ZhuiMingShangHaiJianMian, 2011).       %% 追命伤害减免
-define(P_GongJiShangHaiJiaCheng, 2012).         %% 攻击伤害加成
-define(P_GongJiShangHaiJianMian, 2013).         %% 攻击伤害减免
-define(P_PoJiaShangHaiJiaCheng, 2014).          %% 破甲伤害加成
-define(P_PoJiaShangHaiJianMian, 2015).          %% 破甲伤害减免
-define(P_YuanSuShangHaiJiaCheng, 2016).         %% 元素伤害加成
-define(P_YuanSuShangHaiJianMian, 2017).         %% 元素伤害减免
-define(P_HuShiFangYu, 2018).                    %% 忽视防御率
-define(P_HuShiFangYuDiKang, 2019).              %% 抗忽视防御率
-define(P_HuShiFangYuBiLi, 2020).                %% 忽视防御比例
-define(P_HuShiFangYuZengQiang, 2021).           %% 增强防御比例
-define(P_HuShiHuJia, 2022).                     %% 忽视护甲率
-define(P_HuShiHuJiaDiKang, 2023).               %% 抗忽视护甲率
-define(P_HuShiHuJiaBiLi, 2024).                 %% 忽视护甲比例
-define(P_HuShHuJiaZengQiang, 2025).             %% 增强护甲比例
-define(P_JueDuiMingZhong, 2026).                %% 绝对命中
-define(P_FanJiLv, 2027).                        %% 反击几率
-define(P_FanJiDiKangLv, 2028).                  %% 抵抗反击
-define(P_FanJiShangHaiJiaCheng, 2029).          %% 反击伤害加成
-define(P_FanJiShangHaiJianMian, 2030).          %% 反击伤害减免
-define(P_FanTanLv, 2031).                       %% 反弹几率
-define(P_FanTanDiKangLv, 2032).                 %% 抵抗反弹
-define(P_FanTanShangHaiJiaCheng, 2033).         %% 反弹伤害加成
-define(P_FanTanShangHaiJianMian, 2034).         %% 反弹伤害减免
-define(P_ZhuFBShangHaiJiaCheng, 2035).          %% 主线副本伤害加成
%% 2036--2057 前端使用
-define(P_ShouDaoZhiLiaoXiuZheng, 2058).         %% 受到最终治疗修正
-define(P_CSBiLiGj, 2059).                       %% 承伤最大生命值万分比的固定伤害
-define(P_ShengMingBiLiJiaCheng, 2060).          %% 造成万分比伤害加成
-define(P_JianYiDiKang, 2061).                   %% 减益抵抗 针对bufftype广义类型4
-define(P_JianYiZengQiang, 2062).                %% 减益增强 针对bufftype广义类型4
-define(P_ZengYiDiKang, 2063).                   %% 增益抵抗 针对bufftype广义类型3
-define(P_ZengYiZengQiang, 2064).                %% 增益增强 针对bufftype广义类型3
-define(P_FinalDamageReduce, 2065).              %% 伤害公式最外层伤害减免
-define(P_HpLost1, 2066).                        %% 单次掉血最大值 (整形)
-define(P_HpLost2, 2067).                        %% 单次掉血最大值 (万分比)
-define(P_PetShangHaiJiaChen3, 2071).            %% 英雄伤害加成[银色黎明]
-define(P_PetShangHaiJianMian3, 2072).           %% 英雄伤害减免[银色黎明]
-define(P_PetShangHaiJiaChen2, 2073).            %% 英雄伤害加成[审判联盟]
-define(P_PetShangHaiJianMian2, 2074).           %% 英雄伤害减免[审判联盟]
-define(P_PetShangHaiJiaChen1, 2075).            %% 英雄伤害加成[暗影议会]
-define(P_PetShangHaiJianMian1, 2076).           %%	英雄伤害减免[暗影议会]
-define(P_ShenXiangShangHaiJiaChen, 2077).       %% 神像技能伤害加成
-define(P_ShenXiangShangHaiJianMian, 2078).      %% 神像技能伤害减免
-define(P_PetShangHaiJiaChen4, 2079).            %% 英雄伤害加成[幻兽]
-define(P_PetShangHaiJianMian4, 2080).           %% 英雄伤害加成[幻兽]
-define(P_ShengDunMapJC, 2081).                  %% 圣盾地图加成
-define(P_JiNengCDReduction1, 2082).              %% 技能冷却缩减1
-define(P_JiNengCDReduction2, 2083).              %% 技能冷却缩减2
-define(P_JiNengCDReduction3, 2084).              %% 技能冷却缩减3
-define(P_JiNengCDReduction4, 2085).              %% 技能冷却缩减4
-define(P_HpLostMirr1, 2087).                     %% 单次掉血最大值 (整形) 对镜像专用
-define(P_HpLostMirr2, 2088).                     %% 单次掉血最大值 (万分比) 对镜像专用


-define(P_FuHuoJiLvJianShao, 4001). %% 减少对方触发复活几率XX%
-define(P_FuHuoShengMingJianShao, 4002). %% 减少对方触发复活时获得生命的比例%
-define(P_FuHuoJiLv, 4003). %% 复活几率XX%
-define(P_FuHuoShengMing, 4004). %% 复活时生命比例%
-define(P_FuHuoCDJianShao, 4005). %% 复活冷却时间减少X毫秒
-define(P_FuHuoCDJianShaoLv, 4006). %% 复活冷却时间减少%
-define(P_FuHuoCDBase, 4007). %% 复活基础冷却时间
-define(P_FuHuoJiLvShengXiao, 4008). %% 复活几率生效万分比
-define(P_HuTiJiLvJianShao, 4021). %% 降低对方触发护体几率XX%
-define(P_HuTiBiLiJianShao, 4022). %% 减少对方护体减伤比例XX%
-define(P_HuTiJiLv, 4023). %% 护体触发几率XX%
-define(P_HuTiChiXuShiJian, 4024). %% 护体持续时间X毫秒
-define(P_HuTiChiXuShiJianLv, 4025). %% 护体持续时间%
-define(P_HuTiBiLi, 4026). %% 护体减伤比例%
-define(P_HuTiCDJianShao, 4027). %% 护体冷却时间减少X毫秒
-define(P_HuTiCDJianShaoLv, 4028). %% 护体冷却时间减少%
-define(P_HuTiCDBase, 4029). %% 护体基础冷却时间
-define(P_HuTiJiLvShengXiao, 4030). %% 护体几率生效万分比
-define(P_MaBiJiLv, 4041). %% 麻痹几率%
-define(P_MaBiChiXuShiJian, 4042). %% 麻痹持续时间X毫秒
-define(P_MaBiChiXuShiJianLv, 4043). %% 麻痹持续时间%
-define(P_MaBiCDJianShao, 4044). %% 麻痹冷却时间减少X毫秒
-define(P_MaBiCDJianShaoLv, 4045). %% 麻痹冷却时间减少%
-define(P_MaBiJiLvJianShao, 4046). %% 抗麻痹几率%
-define(P_MaBiChiXuShiJianJianShao, 4047). %% 减少麻痹时间X毫秒
-define(P_MaBiChiXuShiJianJianShaoLv, 4048). %% 减少麻痹时间%
-define(P_MaBiCDBase, 4049). %% 麻痹基础冷却时间
-define(P_MaBiJiLvShengXiao, 4050). %% 麻痹几率生效万分比

-define(P_Longshenjichujiacheng1, 5001).                %% 冰霜龙神基础属性加成
-define(P_Longshenjichujiacheng2, 5002).                %% 生命龙神基础属性加成
-define(P_Longshenjichujiacheng3, 5003).                %% 光明龙神基础属性加成
-define(P_Longshenjichujiacheng4, 5004).                %% 火焰龙神基础属性加成
-define(P_Longshenjichujiacheng5, 5005).                %% 时间龙神基础属性加成
-define(P_Longshenjichujiacheng6, 5006).                %% 空间龙神基础属性加成
-define(P_Longshenjichujiacheng7, 5007).                %% 黑暗龙神基础属性加成
-define(P_Longshenjichujiacheng8, 5008).                %% 七海之神基础属性加成
-define(P_Longshenjichujiacheng9, 5009).                %% 战争之神基础属性加成
-define(P_Longshenjichujiacheng10, 5010).                %% 复仇女神基础属性加成
-define(P_Longshenjichujiacheng11, 5011).                %% 新月女神基础属性加成
-define(P_Longshenjichujiacheng12, 5012).                %% 黑夜女神基础属性加成
-define(P_Longshenjichujiacheng13, 5013).                %% 正义女神基础属性加成
-define(P_Longshenjichujiacheng14, 5014).                %% 风暴女神基础属性加成
-define(P_Lgonshendiaoxiangjiacheng1, 5015).            %% 冰霜法杖基础属性加成
-define(P_Lgonshendiaoxiangjiacheng2, 5016).            %% 双月对剑基础属性加成
-define(P_Lgonshendiaoxiangjiacheng3, 5017).            %% 光辉长枪基础属性加成
-define(P_Lgonshendiaoxiangjiacheng4, 5018).            %% 烈焰镰刀基础属性加成
-define(P_Lgonshendiaoxiangjiacheng5, 5019).            %% 时光机枪基础属性加成
-define(P_Lgonshendiaoxiangjiacheng6, 5020).            %% 秩序月环基础属性加成
-define(P_Lgonshendiaoxiangjiacheng7, 5021).            %% 魔龙之剑基础属性加成
-define(P_Lgonshendiaoxiangjiacheng8, 5022).            %% 三叉戟基础属性加成
-define(P_Lgonshendiaoxiangjiacheng9, 5023).            %% 无尽圣剑基础属性加成
-define(P_Lgonshendiaoxiangjiacheng10, 5024).            %% 复仇之刃基础属性加成
-define(P_Lgonshendiaoxiangjiacheng11, 5025).            %% 魔幻音弦基础属性加成
-define(P_Lgonshendiaoxiangjiacheng12, 5026).            %% 银月魔杖基础属性加成
-define(P_Lgonshendiaoxiangjiacheng13, 5027).            %% 正义圣剑基础属性加成
-define(P_Lgonshendiaoxiangjiacheng14, 5028).            %% 风暴权杖基础属性加成
-define(P_Xianglianjichujiacheng, 5029).                %% 项链基础属性加成
-define(P_Jiezhijichujiacheng, 5030).                    %% 戒指基础属性加成
-define(P_Hufujichujiacheng, 5031).                        %% 护符基础属性加成
-define(P_Guangminglongshijiacheng, 5032).                %% 光明剑龙饰基础属性加成
-define(P_Bingshuanglongshijiacheng, 5033).                %% 冰霜剑龙饰基础属性加成
-define(P_Shengminglongshijiacheng, 5034).                %% 生命剑龙饰基础属性加成
-define(P_Shenlingzhankuijichujiacheng, 5035).            %% 神灵战盔基础属性加成
-define(P_Shenlingzhandunjichujiacheng, 5036).            %% 神灵战盾基础属性加成
-define(P_Shenlingzhanyijichujiacheng, 5037).            %% 神灵战衣基础属性加成
-define(P_Shenlingzhanxuejichujiacheng, 5038).            %% 神灵战靴基础属性加成
-define(P_Shenlingchibangjichujiacheng, 5039).            %% 神灵翅膀基础属性加成
-define(P_Shenlingquanzhangjichujiacheng, 5040).        %% 神灵权杖基础属性加成
-define(P_Zuoqizhuangbeijichujiacheng1, 5041).            %% 面甲基础属性加成
-define(P_Zuoqizhuangbeijichujiacheng2, 5042).            %% 座鞍基础属性加成
-define(P_Zuoqizhuangbeijichujiacheng3, 5043).            %% 缰绳基础属性加成
-define(P_Zuoqizhuangbeijichujiacheng4, 5044).            %% 脚蹬基础属性加成
-define(P_Zuoqizhuangbeijichujiacheng5, 5045).            %% 铁蹄基础属性加成
-define(P_Zuoqizhuangbeijichujiacheng6, 5046).            %% 项圈基础属性加成
-define(P_Mochongzhuangbeijichujiacheng1, 5047).        %% 短刃基础属性加成
-define(P_Mochongzhuangbeijichujiacheng2, 5048).        %% 铭牌基础属性加成
-define(P_Mochongzhuangbeijichujiacheng3, 5049).        %% 护腿基础属性加成
-define(P_Mochongzhuangbeijichujiacheng4, 5050).        %% 头甲基础属性加成
-define(P_Mochongzhuangbeijichujiacheng5, 5051).        %% 战盔基础属性加成
-define(P_Mochongzhuangbeijichujiacheng6, 5052).        %% 披风基础属性加成
-define(P_Chibangzhuangbeijichujiacheng1, 5053).        %% 尾翼基础属性加成
-define(P_Chibangzhuangbeijichujiacheng2, 5054).        %% 流羽基础属性加成
-define(P_Chibangzhuangbeijichujiacheng3, 5055).        %% 掠影基础属性加成
-define(P_Chibangzhuangbeijichujiacheng4, 5056).        %% 幻彩基础属性加成
-define(P_Chibangzhuangbeijichujiacheng5, 5057).        %% 边镶基础属性加成
-define(P_Chibangzhuangbeijichujiacheng6, 5058).        %% 浮翎基础属性加成
-define(P_Haishentaozhuangjichujiacheng1, 5059).        %% 海王战戟基础属性加成
-define(P_Haishentaozhuangjichujiacheng2, 5060).        %% 海鲨背鳍基础属性加成
-define(P_Haishentaozhuangjichujiacheng3, 5061).        %% 海妖手套基础属性加成
-define(P_Haishentaozhuangjichujiacheng4, 5062).        %% 海龙鳞甲基础属性加成
-define(P_Haishentaozhuangjichujiacheng5, 5063).        %% 海蛇腰带基础属性加成
-define(P_Haishentaozhuangjichujiacheng6, 5064).        %% 海鲛长靴基础属性加成
-define(P_Longshendiaoxiangqianghuajiacheng1, 5065).    %% 冰霜/生命-龙神雕像强化属性加成
-define(P_Longshendiaoxiangqianghuajiacheng2, 5066).    %% 光明/火焰-龙神雕像强化属性加成
-define(P_Longshenzhengtijichujiacheng, 5067).            %% 冰霜/生命/光明/火焰龙神基础属性加成
-define(P_Longshendiaoxiangzhengtijichujiacheng, 5068).    %% 冰霜/生命/光明/火焰龙神雕像基础属性加成
-define(P_Shipinqianghuajiacheng, 5069).                %% 饰品强化属性加成
-define(P_Shenlingzhuangbeiqianghuajiacheng1, 5070).    %% 神灵装备（战盔/战盾/战衣）强化属性加成
-define(P_Shenlingzhuangbeiqianghuajiacheng2, 5071).    %% 神灵装备（战靴/翅膀/权杖）强化属性加成
-define(P_Zuoqizhuangbeiqianghuajiacheng1, 5072).        %% 坐骑装备（攻击部位）强化属性加成
-define(P_Zuoqizhuangbeiqianghuajiacheng2, 5073).        %% 坐骑装备（防御部位）强化属性加成
-define(P_Mochongzhuangbeiqianghuajiacheng1, 5074).        %% 魔宠装备（攻击部位）强化属性加成
-define(P_Mochongzhuangbeiqianghuajiacheng2, 5075).        %% 魔宠装备（防御部位）强化属性加成
-define(P_Chibangzhuangbeiqianghuajiacheng1, 5076).        %% 翅膀装备（攻击部位）强化属性加成
-define(P_Chibangzhuangbeiqianghuajiacheng2, 5077).        %% 翅膀装备（防御部位）强化属性加成
-define(P_Haishentaozhuangqianghuajiacheng1, 5078).        %% 海神套装（攻击部位）强化属性加成
-define(P_Haishentaozhuangqianghuajiacheng2, 5079).        %% 海神套装（防御部位）强化属性加成
-define(P_PET_QUALITY_HP, 5080). %% 宠物生命资质(换算成1)
-define(P_PET_QUALITY_ATK, 5081). %% 宠物攻击资质(换算成3)
-define(P_PET_QUALITY_DEF, 5082). %% 宠物防御资质(换算成4)
-define(P_PET_QUALITY_BRO, 5083). %% 宠物破甲资质(换算成5)
-define(P_PET_QUALITY_PERCENT_HP, 5084). %% 宠物生命资质万分比
-define(P_PET_QUALITY_PERCENT_ATK, 5085). %% 宠物攻击资质万分比
-define(P_PET_QUALITY_PERCENT_DEF, 5086). %% 宠物防御资质万分比
-define(P_PET_QUALITY_PERCENT_BRO, 5087). %% 宠物破甲资质万分比
-define(P_PET_QUALITY_LIST, [?P_PET_QUALITY_HP, ?P_PET_QUALITY_ATK, ?P_PET_QUALITY_DEF, ?P_PET_QUALITY_BRO,
	?P_PET_QUALITY_PERCENT_HP, ?P_PET_QUALITY_PERCENT_ATK, ?P_PET_QUALITY_PERCENT_DEF, ?P_PET_QUALITY_PERCENT_BRO]). %% 宠物资质相关列表

%% 系统万分比加成属性列表
-define(PL_XiTongWList, [2] ++ lists:seq(96, 112) ++ lists:seq(123, 130) ++ [147, 148, 149, 150, 151, 154] ++
	lists:seq(164, 183) ++ lists:seq(191, 198) ++ lists:seq(501, 510) ++ lists:seq(531, 537) ++ lists:seq(5001, 5079)).
%% 全局打包属性加成
-define(PL_ShuXingWList, lists:seq(91, 94) ++ [528]).
%% 全局单一属性加成
-define(PL_ShuXing1WList, lists:seq(87, 90) ++ lists:seq(65, 83)).

%% 基础属性值（非百分比属性） 策划给的，不私自加
-define(BasePropList, [1, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 19, 20]).

%%===========================================
-define(ObjectType_Player, 1).            %%
-define(ObjectType_Monster, 2).            %%
-define(ObjectType_MonsterBoss, 3).        %%

-define(DEFAULT_ATTRIBUTES, #{
	?P_GongJi => 0,
	?P_PoJia => 0,
	?P_YuanSuGJ1 => 0,
	?P_YuanSuGJ2 => 0,
	?P_YuanSuGJ3 => 0,
	?P_YuanSuGJ4 => 0,
	?P_YuanSuBJW => 0,
	?P_YuanSuBaoShangJCW => 0,
	?P_ShangHaiJiaChen => 0,
	?P_GongJiShangHaiJiaCheng => 0,
	?P_PoJiaShangHaiJiaCheng => 0,
	?P_YuanSuShangHaiJiaCheng => 0,
	%%
	?P_FangYu => 0,
	?P_HuJia => 0,
	?P_YuanSuFY1 => 0,
	?P_YuanSuFY2 => 0,
	?P_YuanSuFY3 => 0,
	?P_YuanSuFY4 => 0,
	?P_YuanSuRXW => 0,
	?P_YuanSuBaoShangJMW => 0,
	?P_ShangHaiJianMian => 0,
	?P_GongJiShangHaiJianMian => 0,
	?P_PoJiaShangHaiJianMian => 0,
	?P_YuanSuShangHaiJianMian => 0,
	%%
	?P_PVAJiaChen => 0,
	?P_EMJiaChen => 0,
	?P_TSJiaChen => 0,
	?P_GLJiaChen => 0,
	?P_JZSHXiuZheng => 0,
	?P_JZCSXiuZheng => 0,
	%%
	?P_PVAJianMian => 0,
	?P_EMJianMian => 0,
	?P_TSJianMian => 0,
	?P_GLJianMian => 0,
	?P_CSGuDingGj => 0,
	?P_ShengMing => 0,
	?P_DamageFix => 0,
	?P_DamageLimit => 0,
	?P_ObjectID => 0,
	?P_RoleId => 0,
	?P_ObjectType => 0,
	?P_FinalDamageReduce => 0,
	%%
	?P_PetShangHaiJiaChen3 => 0,
	?P_PetShangHaiJianMian3 => 0,
	?P_PetShangHaiJiaChen2 => 0,
	?P_PetShangHaiJianMian2 => 0,
	?P_PetShangHaiJiaChen1 => 0,
	?P_PetShangHaiJianMian1 => 0,
	?P_ShenXiangShangHaiJiaChen => 0,
	?P_ShenXiangShangHaiJianMian => 0,
	?P_PetShangHaiJiaChen4 => 0,
	?P_PetShangHaiJianMian4 => 0
}).

-endif.        %% -ifndef
