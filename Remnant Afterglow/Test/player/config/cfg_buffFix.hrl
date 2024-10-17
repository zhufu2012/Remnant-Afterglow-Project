-ifndef(cfg_buffFix_hrl).
-define(cfg_buffFix_hrl, true).

-record(buffFixCfg, {
	%% BUFF修正ID
	iD,
	%% 修正描述
	%% 后续的数值替换{1}
	%% {0}由修正来源替换
	info_CeHua,
	buffFixInfoString,
	%% 文本描述参数（带成长）
	%% 基础数据|成长数据展示数据=基础数据+成长数据*(MaxLevel=0？当前等级：min(当前等级,MaxLevel))
	infoCorr,
	%% 最大等级
	maxLevel,
	findIndex,
	%% 修正类型
	%% 1:修正自己释放出的BUFF
	%% 2:修正对自己生效的BUFF
	fixType,
	%% {检测BUFF类型，参数}
	%% 检测BUFF类型
	%% 1：检测Buff的type字段
	%% 2：检测typeSubClass字段
	%% 3：检测typeMinSubclass字段
	%% 参数：需要检测的字段值
	fixBuffType,
	%% BUFF创建概率
	%% 修正值, 填0代表不修正
	%% {基础固定修正值,固定修正成长值,基础万分比修正值,万分比修正成长值}
	%% 固定修正值=最小修正值+修正成长值*(MaxLevel=0？当前等级：min(当前等级,MaxLevel))
	%% 结果=原值*（10000+万分比修正值）/10000+固定修正值
	createRate,
	%% 持续总时间
	%% 修正值，填0代表不修正
	%% {基础固定修正值,固定修正成长值,基础万分比修正值,万分比修正成长值}
	%% 结果=原值*（10000+万分比修正值）/10000+固定修正值
	allLastTime,
	%% 效果修正
	%% 修正值，填0代表不修正
	%% {基础固定修正值,固定修正成长值,基础万分比修正值,万分比修正成长值}|{参数2}|{参数3}
	%% 结果=原值*（10000+万分比修正值）/10000+固定修正值
	%% 针对不同BUFF效果修正填写方式不一样
	%% 以改变属性修正为示例
	%% 假设原数据为:{2,100,200}
	%% 现在有对其的以下修正：  固定修正模式：{MinX,MinY}|{X,Y}     万分比修正模式：{MinM,MinN}|{M,N}
	%% 先计算当前等级需要成长值,如：CurX=MinX+X*(MaxLevel=0？当前等级：min(当前等级,MaxLevel))
	%% 修正后结果：{2,100*（10000+CurM)/10000+CurX,200*(10000+CurN)/10000+CurY}
	%% effectType
	%%                   填写方式:{}内都是由基础固定值……万分比成长值4部分组成，|分隔该类型下的参数；后面的参数对应一一替换，X保持不变                                            
	%% 1.改变属性        {固定值修正}|{万分比修正}                                 参数分别修正对应{X,固定值，万分比}
	%% 2.伤害            不可修正                            
	%% 3.治疗            不可修正                                
	%% 4.晕眩            不可修正 
	%% 5.定身            不可修正 
	%% 6.虚化            不可修正 
	%% 7.沉默            不可修正
	%% 8.恐惧            不可修正 
	%% 9.无敌            不可修正 
	%% 10.使用技能       {概率修正}                                                 参数分别修正对应{X,概率}
	%% 11.伤害转治疗    {固定治疗修正}|{伤害转化万分比修正}                           参数分别修正对应{固定治疗,伤害转化万分比,X}
	%% 12.吸伤盾        {固定吸收修正}|{属性转化万分比修正}                          参数分别修正对应{固定吸收,X,属性转化万分比,X}
	%% 13.反伤盾        {固定反伤修正}|{反伤万分比修正}                              参数分别修正对应{固定反伤,反伤万分比}
	%% 14.清除BUFF      不可修正      
	%% 15.清除BUFF      不可修正       
	%% 16.嘲讽          不可修正
	%% 17.变身(未使用）  不可修正                                              
	%% 18.清除BUFF      不可修正 
	%% 19.清除BUFF      不可修正 
	%% 20.支配          不可修正
	%% 21.魅惑          不可修正
	%% 22.致盲          不可修正
	%% 23.禁锢          不可修正
	%% 24.狂怒          {自身某属性万分比伤害值修正}                                   参数分别修正对应{自身某属性万分比伤害值,X}
	%% 25.固定治疗      不可修正                
	%% 26.免疫BUFF      不可修正 
	%% 29.怒气恢复      {怒气值修正}                                                 参数分别修正对应{恢复怒气值}
	%% 30.变身         只能替换修正
	%% 31.CD缩短      {CD缩短固定值修正}|{CD缩短万分比修正}                           参数分别修正对应{X,CD缩短固定值,CD缩短万分比}
	%% 32.冰冻(晕眩）   不可修正
	effectTypeParam,
	%% 治疗、伤害修正
	%% 修正值，填0代表不修正
	%% {基础固定修正值,固定修正成长值,基础万分比修正值,万分比修正成长值}
	%% 对某个值求修正效果
	damageFix
}).

-endif.