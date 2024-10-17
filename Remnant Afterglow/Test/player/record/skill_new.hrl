%%%-------------------------------------------------------------------
%%% @author xiehonggang
%%% @copyright (C) 2018, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 24. 七月 2018 10:36
%%%-------------------------------------------------------------------
-ifndef(skill_new_hrl).
-define(skill_new_hrl, 1).
-author("xiehonggang").


%% 新技能相关 start
-define(MapObjectSkillInfo, mapObjectSkillInfo).%%进程字典，存放地图object初始技能相关数据,同步给客户端视野。战斗中临时技能不放入
-define(MapObjectCleanSkillInfo, mapObjectCleanSkillInfo).%%进程字典，存放地图object退出地图时需删除技能id相关索引，战斗中临时技能会计入
-define(MapObjectSkillItem, mapObjectCleanSkillItem).%%进程字典，存放地图object对应技能id相关信息
%% 新技能相关 end


%% 地图技能信息
%% 注：该信息只能在玩家进入技能初始化，后续技能不需要该信息
-record(skill_map_info, {
	skill_id = 0,
	level = 0,
	fix_list = [],
	%%必须初始化和修正后面的参数
	%%skillBase中可以被修正的参数
	trig_para,
	para_corr,
	target,        %%  (势力关系1,目标类型1,其他条件1,目标数1)|(势力关系2,目标类型2,其他条件2,目标数2)
	cd_para,       %% (技能组,基础冷却时间,初始冷却时间,技能存储次数,释放间隔)
	cost,          %% 消耗
	spec_effect,   %% 特殊效果
	%%  (效果类型,技能系数, 技能基础值)  将技能系数和技能基础值冲SkillEffect里面先拆出来 现将其进行等级加成之后在进行修正
	skill_factor,       %% 技能系数
	skill_base_value,    %% 技能基础值

	attr_para,
	other_effect,
	oth_eff_limit,
	activate_effect,
	displacement,
	spec_eff_limit
	%%skillBase中可以被修正的参数 end
}).

%% 技能使用cd信息
-record(use_skill_cd, {
	next_use_time = 0,
	group_cd_list = [],
	cd_map = maps:new()
}).

%% 技能位
-define(SkillPos_1, 1).        %%  普攻
-define(SkillPos_2, 2).        %%  翻滚
-define(SkillPos_3, 3).        %%  基础主动1
-define(SkillPos_4, 4).        %%  基础主动2
-define(SkillPos_5, 5).        %%  基础主动3
-define(SkillPos_6, 6).        %%  基础主动4
-define(SkillPos_7, 7).        %%  龙神变身
-define(SkillPos_8, 8).        %%  组队被动技能
-define(SkillPos_9, 9).        %%  龙神普攻
-define(SkillPos_10, 10).        %%  龙神技能1
-define(SkillPos_11, 11).        %%  龙神技能2
-define(SkillPos_12, 12).        %%  龙神公用技
-define(SkillPos_13, 13).        %%  魔宠增援技
-define(SkillPos_14, 14).        %%  魔宠普攻
-define(SkillPos_15, 15).        %%  魔宠技能1
-define(SkillPos_16, 16).        %%  魔宠技能2
-define(SkillPos_17, 17).        %%  魔宠装配技1
-define(SkillPos_18, 18).        %%  魔宠装配技2
-define(SkillPos_19, 19).        %%  魔宠装配技3
-define(SkillPos_20, 20).        %%  魔宠装配技4
-define(SkillPos_21, 21).        %%  魔宠装配技5
-define(SkillPos_476, 476).        %%  魔宠装配技6
-define(SkillPos_22, 22).        %%  坐骑装配技1
-define(SkillPos_23, 23).        %%  坐骑装配技2
-define(SkillPos_24, 24).        %%  坐骑装配技3
-define(SkillPos_25, 25).        %%  坐骑装配技4
-define(SkillPos_26, 26).        %%  坐骑装配技5
-define(SkillPos_27, 27).        %%  坐骑装配技6
-define(SkillPos_28, 28).        %%  坐骑装配技7
-define(SkillPos_29, 29).        %%  坐骑装配技8
-define(SkillPos_30, 30).        %%  坐骑装配技9
-define(SkillPos_31, 31).        %%  坐骑装配技10
-define(SkillPos_32, 32).        %%  翅膀装配技1
-define(SkillPos_33, 33).        %%  翅膀装配技2
-define(SkillPos_34, 34).        %%  翅膀装配技3
-define(SkillPos_35, 35).        %%  翅膀装配技4
-define(SkillPos_36, 36).        %%  翅膀装配技5
-define(SkillPos_37, 37).        %%  翅膀装配技6
-define(SkillPos_38, 38).        %%  翅膀装配技7
-define(SkillPos_39, 39).        %%  翅膀装配技8
-define(SkillPos_40, 40).        %%  翅膀装配技9
-define(SkillPos_41, 41).        %%  翅膀装配技10
-define(SkillPos_42, 42).        %%  龙神秘典1
-define(SkillPos_43, 43).        %%  龙神秘典2
-define(SkillPos_44, 44).        %%  龙神秘典3
-define(SkillPos_45, 45).        %%  龙神秘典4
-define(SkillPos_46, 46).        %%  龙神秘典5
-define(SkillPos_47, 47).        %%  龙神秘典6
-define(SkillPos_48, 48).        %%  龙神秘典7
-define(SkillPos_49, 49).        %%  龙神秘典8
-define(SkillPos_50, 50).        %%  龙神秘典9
-define(SkillPos_51, 51).        %%  龙神秘典10
-define(SkillPos_52, 52).        %%  龙神秘典11
-define(SkillPos_53, 53).        %%  龙神秘典12
-define(SkillPos_54, 54).        %%  神兽1-1 todo 废弃
-define(SkillPos_55, 55).        %%  神兽1-2 todo 废弃
-define(SkillPos_56, 56).        %%  神兽1-3 todo 废弃
-define(SkillPos_57, 57).        %%  神兽2-1 todo 废弃
-define(SkillPos_58, 58).        %%  神兽2-2 todo 废弃
-define(SkillPos_59, 59).        %%  神兽2-3 todo 废弃
-define(SkillPos_60, 60).        %%  神兽3-1 todo 废弃
-define(SkillPos_61, 61).        %%  神兽3-2 todo 废弃
-define(SkillPos_62, 62).        %%  神兽3-3 todo 废弃
-define(SkillPos_63, 63).        %%  神兽4-1 todo 废弃
-define(SkillPos_64, 64).        %%  神兽4-2 todo 废弃
-define(SkillPos_65, 65).        %%  神兽4-3 todo 废弃
-define(SkillPos_66, 66).        %%  神兽5-1 todo 废弃
-define(SkillPos_67, 67).        %%  神兽5-2 todo 废弃
-define(SkillPos_68, 68).        %%  神兽5-3 todo 废弃
-define(SkillPos_69, 69).        %%  圣物1普攻
-define(SkillPos_70, 70).        %%  圣物2普攻
-define(SkillPos_71, 71).        %%  圣物3普攻
-define(SkillPos_72, 72).        %%  圣物4普攻
-define(SkillPos_73, 73).        %%  圣物被动技1-1
-define(SkillPos_74, 74).        %%  圣物被动技1-2
-define(SkillPos_75, 75).        %%  圣物被动技1-3
-define(SkillPos_76, 76).        %%  圣物被动技1-4
-define(SkillPos_77, 77).        %%  圣物被动技2-1
-define(SkillPos_78, 78).        %%  圣物被动技2-2
-define(SkillPos_79, 79).        %%  圣物被动技2-3
-define(SkillPos_80, 80).        %%  圣物被动技2-4
-define(SkillPos_81, 81).        %%  圣物被动技3-1
-define(SkillPos_82, 82).        %%  圣物被动技3-2
-define(SkillPos_83, 83).        %%  圣物被动技3-3
-define(SkillPos_84, 84).        %%  圣物被动技3-4
-define(SkillPos_85, 85).        %%  圣物被动技4-1
-define(SkillPos_86, 86).        %%  圣物被动技4-2
-define(SkillPos_87, 87).        %%  圣物被动技4-3
-define(SkillPos_88, 88).        %%  圣物被动技4-4
-define(SkillPos_89, 89).        %%  追击技能1
-define(SkillPos_90, 90).        %%  追击技能2
-define(SkillPos_91, 91).        %%  追击技能3
-define(SkillPos_92, 92).        %%  职业技能1
-define(SkillPos_93, 93).        %%  职业技能2
-define(SkillPos_94, 94).        %%  职业技能3
-define(SkillPos_95, 95).        %%  预言之书-被动技能1
-define(SkillPos_96, 96).        %%  预言之书-被动技能2
-define(SkillPos_97, 97).        %%  预言之书-被动技能3
-define(SkillPos_98, 98).        %%  预言之书-被动技能4
-define(SkillPos_99, 99).        %%  预言之书-被动技能5
-define(SkillPos_100, 100).        %%  天赋技能1
-define(SkillPos_101, 101).        %%  天赋技能2
-define(SkillPos_102, 102).        %%  天赋技能3
-define(SkillPos_103, 103).        %%  天赋技能4
-define(SkillPos_104, 104).        %%  天赋技能5
-define(SkillPos_105, 105).        %%  天赋技能6
-define(SkillPos_106, 106).        %%  守护技能
-define(SkillPos_107, 107).        %%  职业被动技能
-define(SkillPos_108, 108).        %%  魔戒触发技1
-define(SkillPos_109, 109).        %%  魔戒触发技2
-define(SkillPos_110, 110).        %%  魔戒触发技3
-define(SkillPos_111, 111).        %%  魔戒触发技4
-define(SkillPos_114, 114).        %%  器灵镶嵌技1
-define(SkillPos_115, 115).        %%  器灵镶嵌技2
-define(SkillPos_116, 116).        %%  器灵镶嵌技3
-define(SkillPos_117, 117).        %%  器灵镶嵌技4
-define(SkillPos_118, 118).        %%  器灵镶嵌技5
-define(SkillPos_119, 119).     %%  神兵触发技1
-define(SkillPos_120, 120).     %%  神兵触发技2
-define(SkillPos_121, 121).     %%  神兵触发技3
-define(SkillPos_122, 122).     %%  神兵触发技4
-define(SkillPos_123, 123).     %%  神兵触发技5
-define(SkillPos_124, 124).     %%  圣盾技能1
-define(SkillPos_125, 125).     %%  圣盾技能2
-define(SkillPos_126, 126).     %%  圣盾技能3
-define(SkillPos_127, 127).     %%  圣盾技能4
-define(SkillPos_128, 128).     %%  圣盾技能5
-define(SkillPos_129, 129).     %%  圣盾技能6
-define(SkillPos_130, 130).     %%  圣盾技能7
-define(SkillPos_131, 131).     %%  圣盾技能8
-define(SkillPos_132, 132).     %%  圣盾技能9
-define(SkillPos_133, 133).     %%  圣盾技能10
-define(SkillPos_134, 134).     %%  圣盾技能11
-define(SkillPos_135, 135).     %%  圣盾技能12
-define(SkillPos_136, 136).     %%  星座技能1
-define(SkillPos_137, 137).     %%  星座技能2
-define(SkillPos_138, 138).     %%  星座技能3
-define(SkillPos_139, 139).     %%  星座技能4
-define(SkillPos_140, 140).     %%  星座技能5
-define(SkillPos_141, 141).     %%  星座技能6
-define(SkillPos_142, 142).     %%  星座技能7
-define(SkillPos_143, 143).     %%  星座技能8
-define(SkillPos_144, 144).     %%  星座技能9
-define(SkillPos_145, 145).     %%  星座技能10
-define(SkillPos_146, 146).     %%  古神圣装技能1
-define(SkillPos_147, 147).     %%  古神圣装技能2
-define(SkillPos_148, 148).     %%  古神圣装技能3
-define(SkillPos_149, 149).     %%  古神圣装技能4
-define(SkillPos_150, 150).     %%  古神圣装技能5
-define(SkillPos_151, 151).        %%  神兽6-1 todo 废弃
-define(SkillPos_152, 152).        %%  神兽6-2 todo 废弃
-define(SkillPos_153, 153).        %%  神兽6-3 todo 废弃
-define(SkillPos_478, 478).        %%  神灵7-1 todo 废弃
-define(SkillPos_479, 479).        %%  神灵7-2 todo 废弃
-define(SkillPos_480, 480).        %%  神灵7-3 todo 废弃

-define(SkillPos_368, 368).        %%  1v1奖杯属性技能
-define(SkillPos_369, 369).        %%  1v1奖杯触发技能

-define(SkillPos_370, 370).     %%  远征中，当前赛季星石技能位
-define(SkillPos_371, 371).     %%  星座星石技能1
-define(SkillPos_372, 372).     %%  星座星石技能2
-define(SkillPos_373, 373).     %%  星座星石技能3
-define(SkillPos_374, 374).     %%  星座星石技能4
-define(SkillPos_375, 375).     %%  星座星石技能5

%% 技能位400-420 守护使用

-define(SkillPos_675, 675).   %% 龙神翻滚

%% 宠物装备技能 678-686
-define(SkillPos_678, 678).   %% 宠物装备技能1
-define(SkillPos_679, 679).   %% 宠物装备技能2
-define(SkillPos_680, 680).   %% 宠物装备技能3
-define(SkillPos_681, 681).   %% 宠物装备技能4
-define(SkillPos_682, 682).   %% 宠物装备技能5
-define(SkillPos_683, 683).   %% 宠物装备技能6
-define(SkillPos_684, 684).   %% 宠物装备技能7
-define(SkillPos_685, 685).   %% 宠物装备技能8
-define(SkillPos_686, 686).   %% 宠物装备技能9
-define(SkillPos_687, 687).   %% 坐骑翻滚
-define(SkillPos_688, 688).   %% 翅膀翻滚
-define(SkillPos_689, 689).   %% sp英雄增援技
-define(SkillPos_690, 690).   %% sp英雄被动技
-define(SkillPos_691, 691).   %% sp英雄额外技
-define(SkillPos_692, 692).   %% sp英雄额外技2
-define(SkillPos_693, 693).   %% sp英雄被动技2
-define(SkillPos_694, 694).   %% sp英雄被动技3

-define(SkillPos_761, 761).        %%  神兽1-1
-define(SkillPos_762, 762).        %%  神兽1-2
-define(SkillPos_763, 763).        %%  神兽1-3
-define(SkillPos_764, 764).        %%  神灵2-1
-define(SkillPos_765, 765).        %%  神灵2-2
-define(SkillPos_766, 766).        %%  神灵2-3
-define(SkillPos_767, 767).        %%  神兽3-1
-define(SkillPos_768, 768).        %%  神兽3-2
-define(SkillPos_769, 769).        %%  神兽3-3
-define(SkillPos_770, 770).        %%  神兽4-1
-define(SkillPos_771, 771).        %%  神兽4-2
-define(SkillPos_772, 772).        %%  神兽4-3
-define(SkillPos_773, 773).        %%  神兽5-1
-define(SkillPos_774, 774).        %%  神兽5-2
-define(SkillPos_775, 775).        %%  神兽5-3
-define(SkillPos_776, 776).        %%  神兽6-1
-define(SkillPos_777, 777).        %%  神兽6-2
-define(SkillPos_778, 778).        %%  神兽6-3
-define(SkillPos_779, 779).        %%  神兽7-1
-define(SkillPos_780, 780).        %%  神兽7-2
-define(SkillPos_781, 781).        %%  神兽7-3
-define(SkillPos_782, 782).        %%  神兽8-1
-define(SkillPos_783, 783).        %%  神兽8-2
-define(SkillPos_784, 784).        %%  神兽8-3
-define(SkillPos_785, 785).        %%  神兽9-1
-define(SkillPos_786, 786).        %%  神兽9-2
-define(SkillPos_787, 787).        %%  神兽9-3

%% 天赋相关
%% 天赋生效条件类型
-define(Genius_OpenType_ShoulingLv, 1).        %% 兽灵等级
-define(Genius_OpenType_MolingLv, 2).        %% 魔灵等级
-define(Genius_OpenType_YilingLv, 3).        %% 翼灵等级
-define(Genius_OpenType_ShenglingLv, 4).    %% 圣灵等级
-define(Genius_OpenType_GemsLv, 5).         %% 宝石等级

%%---------------end----------------------
-endif. %% -ifdef(skill_new_hrl).
