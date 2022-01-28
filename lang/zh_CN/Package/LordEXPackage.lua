--[[********************************************************************
	Copyright (c) 2013-2015 Mogara

  This file is part of QSanguosha-Hegemony.

  This game is free software; you can redistribute it and/or
  modify it under the terms of the GNU General Public License as
  published by the Free Software Foundation; either version 3.0
  of the License, or (at your option) any later version.

  This program is distributed in the hope that it will be useful,
  but WITHOUT ANY WARRANTY; without even the implied warranty of
  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
  General Public License for more details.

  See the LICENSE file for more details.

  Mogara
*********************************************************************]]

-- translation for Standard General Package

return {
	["manoeuvre"] = "纵横捭阖",
	
	["#huaxin"] = "渊清玉洁",
	["huaxin"] = "华歆",
	["designer:huaxin"] = "韩旭",
	["illustrator:huaxin"] = "秋呆呆",
	["wanggui"] = "望归",
	[":wanggui"] = "当你造成或受到伤害后，若你于当前回合内未发动过此技能，且你：仅此武将牌处于明置状态，你可对与你势力不同的一名角色造成1点普通伤害；所有武将牌均处于明置状态，你可令与你势力相同的角色各摸一张牌。",
	["wanggui:prompt"] = "是否使用“望归”，令与你势力相同的角色各摸一张牌",
	["wanggui-invoke"] = "是否使用“望归”，对一名与你势力不同的角色造成1点伤害",
	["xibing"] = "息兵",
	[":xibing"] = "当{黑色【杀】或黑色普通锦囊牌}于其他角色的出牌阶段内指定目标后，若使用者为该角色且其于此回合内于使用此牌之前未使用过{黑色【杀】或黑色普通锦囊牌}且目标对应的角色数为1，你可发动此技能▶{若其手牌数小于体力值，其将手牌补至X张（X为其体力值），其于此回合内不能使用牌}。若你与其所有武将牌均处于明置状态，你可暗置你的一张不为君主武将牌且不为士兵牌的武将牌▷其暗置你选择的其一张你选择的其一张不为君主武将牌且不为士兵牌的武将牌，你与其于此回合内不能明置以此法暗置的武将牌。",
	["@xibing-hide"] = "息兵:选择要暗置的%dest的武将牌",
	["xibing:head"] = "暗置主将",
	["xibing:deputy"] = "暗置副将",
	
	
	["#luyusheng"] = "义姑",
	["luyusheng"] = "陆郁生",
	["designer:luyusheng"] = "韩旭",
	["illustrator:luyusheng"] = "君桓文化",
	["zhente"] = "贞特",
	[":zhente"] = "当你成为黑色基本牌或黑色普通锦囊牌的目标后，若使用者不为你且你于当前回合内未发动过此技能，你可令其选择：1.其于此回合内不能使用黑色的牌；2.此牌对此目标无效。",
	["zhente-ask"] = "贞特效果，选择一项：1.令【%arg】对%src无效；2.本回合不能使用黑色牌",
	["zhente:nullified"] = "此牌对其无效",
	["zhente:cardlimited"] = "本回合不能使用黑色牌",
	
	["#ZhiweiChoice1"] = "%from 选择：【%arg】对 %to 无效",
	["#ZhiweiChoice2"] = "%from 选择：本回合不能使用黑色牌",
	
	["zhiwei"] = "至微",
	["#zhiwei-effect"] = "至微",
	[":zhiwei"] = "当你明置此武将牌时，你可选择一名其他角色▶(→)直到你暗置或移除此武将牌前，{当其造成伤害后，你摸一张牌；当其受到伤害后，你随机弃置一张手牌；弃牌阶段结束时，你令其获得你于此阶段内因弃置而置入弃牌堆的牌；当其死亡时，若你的所有武将牌均处于明置状态，你暗置此武将牌}。",
	
	["zhiwei-invoke"] = "是否使用“至微”，选择一名其他角色",
	
	["#ZhiweiEffect1"] = "%to 造成伤害，%from 因 %arg 效果摸一张牌",
	["#ZhiweiEffect2"] = "%to 受到伤害，%from 因 %arg 效果随机弃置一张手牌",
	["#ZhiweiEffect3"] = "%to 因 %arg 效果获得 %from 弃置的牌",
	["#ZhiweiEffect4"] = "%to 死亡，%from 因 %arg 效果暗置武将牌",
	
	["#ZhiweiFinsh"] = "%from 对 %to 的 %arg 效果终止",

	["#zongyux"] = "九酝鸿胪",
	["zongyux"] = "宗预",
	["designer:zongyux"] = "韩旭",
	["illustrator:zongyux"] = "铁杵",
	["qiao"] = "气傲",
	[":qiao"] = "当你成为牌的目标后，若使用者与你势力不同且你于当前回合内发动此技能的次数＜2，你可弃置其一张牌▶你弃置一张牌。",
	["chengshang"] = "承赏",
	[":chengshang"] = "当牌于你的出牌阶段内结算完成后，若使用者为你且此牌的目标列表中有对应的角色与你势力不同的目标且此牌未造成过伤害，你可发动此技能▶你获得牌堆中所有与此牌花色和点数均相同的牌▷此技能于此阶段内无效。",

	["@qiao-discard"] = "气傲：选择一张牌弃置",
	
	
	["#miheng"] = "鸷鹗啄孤凤",
	["miheng"] = "祢衡",
	["designer:miheng"] = "韩旭",
	["illustrator:miheng"] = "佚名",
	["kuangcai"] = "狂才",
	[":kuangcai"] = "锁定技，①你于回合内使用的牌无距离关系的限制且无次数限制。②弃牌阶段开始时，若你于此回合内使用过牌且未造成过伤害，你的手牌上限于此回合内-1。",
	["shejian"] = "舌剑",
	[":shejian"] = "当你成为牌的目标后，若使用者不为你且目标对应的角色数为1且所有角色的体力值均大于0且你有手牌，你可发动此技能▶你弃置所有手牌，对使用者造成1点普通伤害。",

	["#fengxi"] = "东吴苏武",
	["fengxi"] = "冯熙",
	["designer:fengxi"] = "韩旭",
	["illustrator:fengxi"] = "佚名",
	["yusui"] = "玉碎",
	[":yusui"] = "当你成为黑色牌的目标后，若使用者与你势力不同，你可失去1点体力▶你选择：1.令其弃置X张手牌（X为其体力上限）；2.令其失去Y点体力（Y=max{其体力值-你的体力值，0}）。",
	["boyan"] = "驳言",
	[":boyan"] = "出牌阶段限一次，你可选择一名其他角色▶其将手牌补至X张（X为其体力上限），其于此回合内不能使用或打出对应的实体牌均为其手牌区里的牌的牌，你可令其于其下个回合结束之前拥有〖驳言（纵横）〗。",
	["@yusui-choice"] = "玉碎：选择一项令%dest执行",
	["yusui:losehp"] = "失去体力至与你相同",
	["yusui:discard"] = "弃置体力上限张手牌",
	
	["@boyan-zongheng"] = "是否让%dest获得技能：驳言（纵横）",
	
	["boyanzongheng"] = "驳言",
	[":boyanzongheng"] = "出牌阶段限一次，你可选择一名其他角色▶其于此回合内不能使用或打出对应的实体牌均为其手牌区里的牌的牌。",
	
	
	["#dengzhi"] = "绝境外交家",
	["dengzhi"] = "邓芝",
	["designer:dengzhi"] = "韩旭",
	["illustrator:dengzhi"] = "佚名",
	["jianliang"] = "简亮",
	[":jianliang"] = "摸牌阶段开始时，若你是手牌数最小的角色，你可令与你势力相同的角色各摸一张牌。",
	["weimeng"] = "危盟",
	[":weimeng"] = "出牌阶段限一次，你可选择一名有手牌的其他角色▶你获得其至多X张手牌（X为你的体力值），将等量的牌交给其。你可令其于其下个回合结束之前拥有〖危盟（纵横）〗。",

	["weimengzongheng"] = "危盟",
	[":weimengzongheng"] = "出牌阶段限一次，你可选择一名有手牌的其他角色▶你获得其一张手牌，将一张牌交给其。",
	
	
	["@weimeng-num"] = "危盟：选择获得%dest的牌的数量",
	
	["@weimeng-give"] = "危盟：选择交给%dest的%arg张牌",
	
	["@weimeng-zongheng"] = "是否让%dest获得技能：危盟（纵横）",
	
	["#xunchen"] = "三公谋主",
	["xunchen"] = "荀谌",
	["designer:xunchen"] = "韩旭",
	["illustrator:xunchen"] = "凝聚永恒",
	["fenglve"] = "锋略",
	[":fenglve"] = "出牌阶段限一次，你可与一名角色拼点▶{若：你赢，其将区域里两张牌交给你；其赢，你将一张牌交给其}。你可令其于其下个回合结束之前拥有〖锋略（纵横）〗。",
	["anyong"] = "暗涌",
	["#anyong-effect"] = "暗涌",
	[":anyong"] = "当与你势力相同的角色A对另一名其他角色B造成伤害时，若你于当前回合内未发动过此技能，你可令伤害值+X（X为伤害值）▶若B：所有武将牌均处于明置状态，你失去1点体力，失去此技能；仅有一张武将牌处于明置状态，你弃置两张手牌。",
	["@fenglve-give1"] = "锋略：选择一张牌交给%dest",
	["@anyong-discard"] = "暗涌：选择两张手牌弃置",
	
	["fenglvezongheng"] = "锋略",
	[":fenglvezongheng"] = "出牌阶段限一次，你可与一名角色拼点▶若：你赢，其将区域里一张牌交给你；其赢，你将两张牌交给其。",
	["@fenglve-give2"] = "锋略：选择两张牌交给%dest",
	
	["@fenglve-zongheng"] = "是否让%dest获得技能：锋略（纵横）",
	
	
	["newsgs"] = "十周年专属",
	
	
	["#jianggan"] = "锋镝悬信",
	["jianggan"] = "蒋干",
	["illustrator:jianggan"] = "biou09",
	["weicheng"] = "伪诚",
	[":weicheng"] = "当你的手牌移至其他角色的手牌区后，若你的手牌数小于你的体力值，你可摸一张牌。",
	["daoshu"] = "盗书",
	[":daoshu"] = "出牌阶段限一次，你可以选择一种花色并选择一名有手牌的其他角色▶你获得其一张牌并记录此牌的游戏牌ID。若为此ID的牌："..
		"是你选择的花色，{你对其造成1点伤害。此技能于此阶段内的发动次数上限+1}；"..
		"不是你选择的花色，{若你的手牌均与此牌花色相同，你展示所有手牌。你将一张与此牌花色花色不同的手牌交给其}。",
	["@daoshu-give"] = "盗书：选择一张手牌交给 %dest",
	
	
	
	["#zhouyi"] = "靛情雨黛",
	["zhouyi"] = "周夷",
    ["designer:zhouyi"] = "韩旭",
	["illustrator:zhouyi"] = "Tb罗根",
	["zhukou"] = "逐寇",
	[":zhukou"] = "当你于一名角色的出牌阶段内造成伤害后，若你于此阶段内于造成此伤害之前未造成过伤害，你可摸X张牌（X=min{你于此回合内使用过的牌数,5}）。",
	["duannian"] = "断念",
	[":duannian"] = "出牌阶段结束时，若你有手牌，你可发动此技能▶你弃置所有手牌，将手牌补至X张（X为你的体力上限）。",
	["lianyou"] = "莲佑",
	[":lianyou"] = "你死亡时，你可令一名其他角色获得〖兴火〗。",
	["xinghuo"] = "兴火",
	[":xinghuo"] = "锁定技，当你造成火焰伤害时，你令伤害值+1。",
	
	["@lianyou"] = "是否使用“莲佑”，选择一名角色获得“兴火”",
	
	["#nanhualaoxian"] = "仙人指路",
	["nanhualaoxian"] = "南华老仙",
	["designer:nanhualaoxian"] = "韩旭",
	["illustrator:nanhualaoxian"] = "君桓文化",
	["gongxiu"] = "共修",
	[":gongxiu"] = "摸牌阶段，你可令额定摸牌数-1▶你选择：1.令至多X名角色各摸一张牌，你于下次发动此技能时不能选择此项；2.令至多X名角色各弃置一张牌，你于下次发动此技能时不能选择此项。（X为你的体力上限）",
	["jinghe"] = "经合",
	[":jinghe"] = "出牌阶段限一次，若你于此回合内未发动过此技能，你可以展示至多X张牌名各不相同的手牌并选择等量的有处于明置状态的武将牌的角色（X为你的体力上限）▶系统随机从"..
	"{〖雷击〗、〖阴兵〗、〖活气〗、〖鬼助〗、〖仙授〗、〖论道〗、〖观月〗、〖言政〗}"..
	"中选择等量的技能，这些角色各可从中选择一个{没有角色因执行此次技能的效果而选择过的}技能，其拥有此技能直到你的下回合开始。",
	["leiji_tianshu"] = "雷击",
	[":leiji_tianshu"] = "当你使用或打出【闪】时，你可令一名其他角色判定▶若结果为黑桃，你对其造成2点雷电伤害。",
	["yinbing"] = "阴兵",
	[":yinbing"] = "锁定技，①当你因执行你使用的【杀】的效果而造成的伤害的结算结算开始前，你终止此伤害流程▶其失去X点体力（X为伤害值）。②当其他角色失去体力后，你摸一张牌。",
	["huoqi"] = "活气",
	[":huoqi"] = "出牌阶段限一次，你可弃置一张牌并选择体力值最小的一名角色▶其回复1点体力，其摸一张牌。",
	["guizhu"] = "鬼助",
	[":guizhu"] = "当一名角色进入濒死状态时，若你于当前回合内未发动过此技能，你摸两张牌。",
	["xianshou"] = "仙授",
	[":xianshou"] = "出牌阶段限一次，你可选择：1.令一名已受伤的角色摸一张牌；2.令一名未受伤的角色摸两张牌。",
	["lundao"] = "论道",
	[":lundao"] = "当你受到伤害后，若来源的手牌数：大于你，你可弃置其一张牌；小于你，你可摸一张牌。",
	["guanyue"] = "观月",
	[":guanyue"] = "结束阶段开始时，你可观看牌堆顶的两张牌▶你获得其中的—张牌。",
	["yanzheng"] = "言政",
	[":yanzheng"] = "准备阶段开始时，若你的手牌数大于1，你可选择一张手牌并弃置其余的手牌▶你对至多X名角色各造成1点伤害（X为你以此法弃置的牌数）。",

	["@gongxiu-choose"] = "共修：选择一项效果发动",
	["gongxiu_choose:draw"] = "令角色摸牌",
	["gongxiu_choose:discard"] = "令角色弃牌",
	["@gongxiu-draw"] = "共修：选择至多%arg名角色各摸一张牌",
	["@gongxiu-discard"] = "共修：选择至多%arg名角色各弃置一张牌",
	["@gongxiu-throw"] = "共修：选择一张牌弃置",
	
	["@jinghe-choose"] = "经合：选择获得一项技能",
	
	["@yanzheng"] = "是否使用“言政”，选择一张手牌，弃置其余手牌",
	["@yanzheng-damage"] = "言政：选择至多%arg名角色",
	
	
	["#lvlingqi"] = "无双虓姬",
	["lvlingqi"] = "吕玲绮",
	["designer:lvlingqi"] = "",
	["illustrator:lvlingqi"] = "",
	["guowu"] = "帼武",
	[":guowu"] = "出牌阶段开始时，你可展示所有手牌▶你获得X枚“帼武”（X为你以此法展示的牌中的类别数）。{你随机获得弃牌堆里的一张【杀】。"..
		"若Y大于1，你于此阶段内使用牌无距离关系的限制}→{当你于此阶段内使用【杀】或普通锦囊牌选择目标后，若Y大于2，你可令至多两名角色也成为此牌的目标▷你弃1枚“帼武”；"..
		"此阶段结束后，你弃所有“帼武”}。（Y为“帼武”数）",
	["zhuangrong"] = "妆戎",
	[":zhuangrong"] = "出牌阶段限一次，你可弃置一张锦囊牌▶你于此阶段内拥有〖无双〗。",
	["wushuang_lvlingqi"] = "无双",
	["shenwei"] = "神威",
	[":shenwei"] = "主将技，①此武将牌上单独的阴阳鱼个数-1。②摸牌阶段，你令额定摸牌数+2；③你的手牌上限+2。",
	["@guowu-add"] = "你可以发动“帼武”，为使用的【%arg】增加至多两个目标",
	
    ["$AddCardTarget"] = "%from 发动了“%arg”为 %card 增加了额外目标 %to",
    ["$RemoveCardTarget"] = "%from 发动了“%arg”为 %card 减少了目标 %to",
	
	["MOL"] = "移动版专属",
	
	
	["#duyu"] = "文成武德",
	["designer:duyu"] = "cl",
	["duyu"] = "杜预",
	["illustrator:duyu"] = "佚名",
	["wuku"] = "武库",
	[":wuku"] = "锁定技，当装备牌被使用时，若使用者与你势力不同且“武库”数＜2，你获得1枚“武库”。",
	["miewu"] = "灭吴",
	[":miewu"] = "①当你需要使用基本牌/锦囊牌时，若你有“武库”且你于当前回合内未发动过此技能和〖灭吴②〗，你可使用对应的实体牌为你的一张牌的此基本牌/锦囊牌▶你弃1枚“武库”，系统继续此基本牌/锦囊牌的使用流程，你摸一张牌。②当你需要打出基本牌/锦囊牌时，若你有“武库”且你于当前回合内未发动过此技能和〖灭吴①〗，你可打出对应的实体牌为你的一张牌的此基本牌/锦囊牌▶你弃1枚“武库”，系统继续此基本牌/锦囊牌的打出流程，你摸一张牌。",
	["#armory"] = "武库",
	
	
	
	["overseas"] = "海外版专属",

    ["beimihu"] = "卑弥呼",
	["#beimihu"] = "邪马台的女王",
	["illustrator:beimihu"] = "聚一_小道恩",
	["designer:beimihu"] = "淬毒",
	["guishu"] = "鬼术",
	[":guishu"] = "出牌阶段，若你{未发动过此技能或上次以此法使用的牌为【知己知彼】/【远交近攻】}，你可使用对应的实体牌为你的一张黑桃手牌的【远交近攻】/【知己知彼】。" ,
	["yuanyu"] = "远域",
	[":yuanyu"] = "锁定技，当你受到伤害时，若来源不为你的上家或下家，你防止此伤害。" ,

    ["caozhen"] = "曹真",
	["#caozhen"] = "万载不刊",
	["illustrator:caozhen"] = "瞎子Ghe",
	["sidi"] = "司敌",
	[":sidi"] = "①当魏势力角色受到伤害后，你可令其选择其一张牌▶其将此牌置于你的武将牌上（称为“驭”）。②不为魏势力或没有势力的角色的回合开始时，若其存活，你可将至多三张“驭”置入弃牌堆▶"..
		"你选择等量的项：1.你选一种牌的类别，其于此回合内不能使用此类别的牌；2.你选其处于明置状态的武将牌上的一个技能，此技能于此回合内无效；3.你令其选一名魏势力角色回复1点体力。" ,

	["drive"] = "驭",
	
	["@sidi-put"] = "司敌：选一张牌作为%src的“驭”",
	["@sidi-remove"] = "是否对%dest使用“司敌”",
	["@sidi-choice"] = "司敌：选择一项令%dest执行",

	["sidi_choice:cardlimit"] = "选一种类别的牌不能使用",
	["sidi_choice:skilllimit"] = "选一个技能不能使用",
	["sidi_choice:recover"] = "令其选魏势力角色回复体力",
	
	["@sidi-recover"] = "司敌：选一名魏势力角色回复体力",
	["@sidi-cardtype"] = "司敌：令%dest本回合不能使用一种类别的牌",
	["@sidi-skill"] = "司敌：令%dest的一个技能本回合无效",
	
	
	["#liaohua"] = "历尽沧桑",
	["liaohua"] = "廖化",
	["illustrator:liaohua"] = "",
	["dangxian"] = "当先",
	[":dangxian"] = "锁定技，①当你第一次明置此武将牌后，你获得1枚“先驱”。②回合开始后，你获得一个额外的出牌阶段。",
	
	["#zhugejin"] = "联盟的维系者",
	["zhugejin"] = "诸葛瑾",
	["illustrator:zhugejin"] = "",
	["huanshi"] = "缓释",
	[":huanshi"] = "当与你势力相同的角色的判定结果确定前，你可打出对应的实体牌为你的一张牌且与此牌牌名相同的牌▶系统将此牌作为判定牌，将原判定牌置入弃牌堆。",
	["hongyuan"] = "弘援",
	[":hongyuan"] = "①当牌因合纵的效果而摸牌而移动至你的手牌区前，你可将目标区域改至一名与你势力相同的其他角色的手牌区。②出牌阶段限一次，你可合纵一张手牌。",
	["mingzhe"] = "明哲",
	[":mingzhe"] = "①当红色牌于你的回合外被使用/打出时，若使用/打出者为你，你摸一张牌。②当一张红色装备牌于你的回合外移出你的装备区后，你可摸一张牌。",
	
	["@huanshi-card"] = CommonTranslationTable["@askforretrial"],
	["hongyuan-invoke"] = "是否使用“弘援”，选择摸牌的角色",
	
	
	["#quancong"] = "慕势耀族",
	["quancong"] = "全琮",
	["illustrator:quancong"] = "",
	["qinzhong"] = "亲重",
	[":qinzhong"] = "副将技，回合开始时，你可与一名与你势力相同的角色交换副将。",
	["zhaofu"] = "招附",
	[":zhaofu"] = "①出牌阶段开始时，若有“赏”的角色数小于3，你可弃置一张牌并选择一名没有“赏”的其他角色▶其获得1枚“赏”。"..
		"②当基本牌/普通锦囊牌使用结算后，若使用者有“赏”，你可使用无对应的实体牌的与此基本牌/普通锦囊牌牌名相同的牌▶其弃1枚“赏”，系统继续此牌的使用流程。",

	["reward"] = "赏",
	
	["qinzhong-invoke"] = "是否使用“亲重”，与一名势力相同的角色交换副将",
	["@zhaofu1"] = "是否使用“招附”，弃置一张牌令一名角色获得“赏”",
	["zhaofu:prompt"] = "是否使用“招附”，视为使用【%arg】",
	["@zhaofu2"] = "是否使用“招附”，视为使用【%arg】",
	
	
	
	["lord_ex"] = "君临天下·EX",
	["lord_ex_card"] = "君临天下·EX",
	
	
	["#mengda"] = "怠军反复",
	["mengda"] = "孟达",
	["designer:mengda"] = "韩旭",
	["illustrator:mengda"] = "张帅",
	["qiuan"] = "求安",
	[":qiuan"] = "当你受到伤害时，若没有“函”，你可将是此伤害的渠道的牌对应的所有实体牌置于你的武将牌上（均称为“函”）▶你防止此伤害。",
	["liangfan"] = "量反",
	[":liangfan"] = "锁定技，准备阶段开始时，若有“函”，你获得“函”▶你失去1点体力→当你于此回合内因执行牌的效果而对一名角色造成伤害后，若此牌对应的实体牌中有你以此法得到的牌，你可获得其一张牌。",
	["letter"] = "函",
	["#liangfan-effect"] = "量反",
	["#LiangfanEffect"] = "%from 使用%arg牌造成伤害，获得 %to 的一张牌",
	
	["@liangfan"] = "量反：是否获得%dest的一张牌",
	
	
	["#tangzi"] = "得时识风",
	["designer:tangzi"] = "荼蘼（韩旭）",
	["tangzi"] = "唐咨",
	["illustrator:tangzi"] = "凝聚永恒",
	["xingzhao"] = "兴棹",
	[":xingzhao"] = "锁定技，①若X>0，你拥有〖恂恂〗。②当你受到一名角色造成的伤害后，若X>1且其存活且其：手牌数大于你，你摸一张牌；手牌数小于你，你令其摸一张牌。③弃牌阶段开始时，若X>2，你的手牌上限于此回合内+4。④当你失去装备区的牌后，若X＞3，你摸一张牌。（X为已受伤的角色的势力数）",
	["xunxun_tangzi"] = "恂恂",
	
	["#zhanglu"] = "政宽教惠",
	["designer:zhanglu"] = "韩旭",
	["zhanglu"] = "张鲁",
	["illustrator:zhanglu"] = "磐蒲",
	["bushi"] = "布施",
	[":bushi"] = "锁定技，①当你受到1点伤害后，你令与你势力相同的一名角色摸一张牌。②当你对其他角色造成伤害后，你令与其势力相同的一名角色摸一张牌。",
	["midao"] = "米道",
	["#midao-other"] = "米道",
	[":midao"] = "当（曾）有对应的实体牌的{基本牌或伤害类锦囊牌}于一名角色的出牌阶段内指定第一个目标时，若使用者为该角色且其与你势力相同且你于此阶段内未发动过此技能，（你令）其可将一张手牌交给你▶你将其使用的牌改为任意花色和属性。",
	["bushi-invoke"] = "布施：令一名角色摸一张牌",
	["@midao"] = "是否使用%src的“米道”",
	["@midao-nature"] = "米道：为%dest使用的【%arg】选择一个属性",
	["midao:normal"] = "普通伤害",
	["midao:fire"] = "火焰伤害",
	["midao:thunder"] = "雷电伤害",
	["#MidaoSuit"] = "%from 使用的【%arg】花色改为%arg2",
	["#MidaoNature"] = "%from 使用的【%arg】造成伤害改为%arg2",
	
	["#mifangfushiren"] = "逐驾迎尘",
	["designer:mifangfushiren"] = "Loun老萌",
	["mifangfushiren"] = "糜芳＆傅士仁",
	["&mifangfushiren"] = "糜芳傅士仁",
	["illustrator:mifangfushiren"] = "木美人",
	["fengshix"] = "锋势",
	["#fengshix-other"] = "锋势",
	[":fengshix"] = "①当牌指定目标后，若使用者为你且目标对应的角色数为1且与此目标对应的角色的手牌数小于你，你可发动此技能▶你弃置你与其各一张牌，此牌的伤害值基数+1。②当你成为牌的目标后，若目标对应的角色数为1且你的手牌数小于使用者，（你令）其可发动此技能▶你弃置你与其各一张牌，此牌的伤害值基数+1。",
	["@fengshix"] = "是否使用%src的“锋势”",
	
	
	["#liuqi"] = "居外而安",
	["designer:liuqi"] = "荼蘼（韩旭）",
	["liuqi"] = "刘琦",
	["illustrator:liuqi"] = "绘聚艺堂",
	["wenji"] = "问计",
	[":wenji"] = "出牌阶段开始时，你可令一名其他角色将其一张牌交给你（正面朝上移动）▶若其：与你势力不同，你将一张不为你以此法得到的牌以外的牌交给其（正面朝上移动）；与你势力相同或没有势力，你于此回合内使用对应的实体牌中有你以此法得到的牌的牌无距离关系的限制且无次数限制→当牌于此回合内被使用时，若此牌对应的实体牌中有你以此法得到的牌，你令所有角色不能响应此次使用的牌。",
	["tunjiang"] = "屯江",
	[":tunjiang"] = "结束阶段开始时，若你于出牌阶段内使用过牌且未对其他角色使用过牌，你可摸X张牌（X为势力数）。",
	["@wenji"] = "是否使用“问计”，选择一名其他角色",
	["@wenji-give"] = "问计：选择一张牌交给 %src",
	["#WenjiEffect"] = "%from 的%arg效果生效，【%arg2】不能被响应",
	["#wenji-effect"] = "问计",
	
	["#shixie"] = "百粤灵欹",
	["designer:shixie"] = "韩旭",
	["shixie"] = "士燮",
	["illustrator:shixie"] = "磐蒲",
	["biluan"] = "避乱",
	[":biluan"] = "锁定技，其他角色至你的距离+X（X=max{你装备区里的牌数,1}）。",
	["lixia"] = "礼下",
	[":lixia"] = "一名角色的准备阶段开始时，若其与你势力不同，（你令）其可弃置你装备区里的一张牌▶若你以此法被弃置过牌，其选择：1.弃置两张牌；2.失去1点体力；3.令你摸两张牌。",

	["@lixia"] = "是否使用%src的“礼下”",
	["@lixia-choose"] = "礼下：请选择执行的操作",
	["lixia_effect:discard"] = "弃置两张牌",
	["lixia_effect:losehp"] = "失去1点体力",
	["lixia_effect:draw"] = "令%from摸两张牌",

	["#zhonghui"] = "桀骜的野心家",
	["designer:zhonghui"] = "韩旭",
	["zhonghui"] = "钟会",
	["illustrator:zhonghui"] = "磐蒲",
	["quanji"] = "权计",
	[":quanji"] = "①当你受到伤害后，或当你因执行目标数为1的牌的效果而对一名角色造成伤害后，你可摸一张牌▶你将一张牌置于武将牌上（称为“权”）。②你的手牌上限+X（X为“权”数）。",
	["paiyi"] = "排异",
	[":paiyi"] = "出牌阶段限一次，你可将一张“权”置入弃牌堆并选择一名角色▶其摸X张牌（X=min{“权”数, 7}）。若其手牌数大于你，你对其造成1点普通伤害。",

	["@quanji-push"] = "权计：选择一张牌作为“权”",
	["power_pile"] = "权",

	["#dongzhao"] = "移尊易鼎",
	["dongzhao"] = "董昭",
	["illustrator:dongzhao"] = "小牛",
	["designer:dongzhao"] = "逍遥鱼叔",
	["quanjin"] = "劝进",
	[":quanjin"] = "出牌阶段限一次，你可将一张手牌交给于此阶段内受到过伤害的角色▶其选择是否执行军令。若其选择：是，你摸一张牌；否且你不是手牌数最大的角色，你摸X张牌（X=min{手牌数最大的角色的手牌数-你的手牌数,5}）。",
	["zaoyun"] = "凿运",
	[":zaoyun"] = "出牌阶段限一次，你可选择与你势力不同且你至其距离大于1的角色并弃置X张手牌（X为你至其距离-1）▶你至其的距离于此回合内视为1，你对其造成1点伤害。",

	["#xushu"] = "化剑为犁",
	["xushu"] = "徐庶",
	["illustrator:xushu"] = "YanBai",
	["designer:xushu"] = "梦魇狂朝",
	["zhuhai"] = "诛害",
	[":zhuhai"] = "其他角色的结束阶段开始时，若其于此回合内造成过伤害且此武将牌处于明置状态，你可对包括其在内的角色使用【杀】（无距离关系的限制）。",
	["pozhen"] = "破阵",
	[":pozhen"] = "限定技，其他角色的准备阶段开始时，若其存活，你可发动此技能▶其于此回合内不能使用或打出对应的实体牌均是其手牌区的牌的牌且不能重铸手牌。你可弃置与其处于同一队列或同一围攻关系的围攻角色的其他角色的各一张牌。",
	["jiancai"] = "荐才",
	[":jiancai"] = "副将技，①此武将牌上单独的阴阳鱼个数-1。②当一名角色受到伤害时，若其与你势力相同且伤害值不小于其体力值，你可令伤害值-1▶你变更。③当一名角色变更时，若其与你势力相同，你可令备选武将牌数+2。",
	
	["@zhuhai"] = "是否使用“诛害”，对%src使用【杀】",
	["@pozhen-discard"] = "破阵：是否弃置与%dest处于同一队列或围攻关系的角色的各一张牌",
	["jiancai:damage"] = "是否使用“荐才”，令%src受到的伤害-1",
	["jiancai:transform"] = "是否使用“荐才”，令%src变更时的备选武将数+2",
	
	["#wujing"] = "汗马鎏金",
	["wujing"] = "吴景",
	["illustrator:wujing"] = "小牛",
	["designer:wujing"] = "逍遥鱼叔",
	["diaogui"] = "调归",
	[":diaogui"] = "出牌阶段限一次，你可使用对应的实体牌为一张装备牌的【调虎离山】▶若有于你使用此牌之前不相邻且均与你势力相同的相邻的角色，你摸X张牌（X为这些角色中与其处于同一队列的角色数的最大值）。",
	["fengyang"] = "风扬",
	[":fengyang"] = "阵法技，当有牌因与你势力不同的角色的弃置/获得而移动前，你取消与你处于同一队列的角色的装备区里的牌的此次移动。",
	
	["#DiaoguiCheak"] = "调归检测%from的下家和上家分别是%to",

	["#yanbaihu"] = "豺牙落涧",
	["yanbaihu"] = "严白虎",
	["illustrator:yanbaihu"] = "YanBai",
	["designer:yanbaihu"] = "逍遥鱼叔",
	["zhidao"] = "雉盗",
	[":zhidao"] = "锁定技，出牌阶段开始时，你选择一名其他角色▶你至其的距离于此回合内视为1，除其外的的其他角色于此回合内不是你使用牌的合法目标(→)你于此阶段内对其造成伤害后，若你于此阶段内于造成此伤害之前未对其造成过伤害，你获得其区域里的一张牌。",
	["jilix"] = "寄篱",
	[":jilix"] = "副将技，①此武将牌上单独的阴阳鱼个数-1。②当红色基本牌或红色普通锦囊牌结算结束后，若此牌的最终目标数为1且你是此目标对应的角色，使用者对你使用无对应的实体牌且与此牌牌名相同的牌（无距离关系和目标的限制）。③当你受到伤害时，若你于此阶段内受到过伤害的次数为1，你防止此伤害▶你移除此武将牌。",
	
	["#zhidao-damage"] = "雉盗",
	["@zhidao-target"] = "雉盗：选择一名其他角色",
	["#ZhidaoEffect"] = "%from 因“%arg”的效果，获得 %to 区域里的一张牌",
	
	["jilix:target"] = "是否使用“寄篱”，令%src再视为对你使用一次【%arg】",
	["jilix:damage"] = "是否使用“寄篱”，防止受到的伤害并移除此武将牌",

	["ImperialEdict"] = "诏书",
	[":ImperialEdict"] = "装备牌·宝物\n\n技能：\n" ..
					"1. 与你势力相同的角色的出牌阶段限一次，若其：是小势力角色，其可将至多两张手牌置于你的武将牌上（均称为“诏”）；不是小势力角色，其可将一张手牌置于你的武将牌上（称为“诏”）。\n" ..
					"2. 出牌阶段限一次，若有四张不同花色的“诏”，你可将所有“诏”置入弃牌堆，你从势力锦囊牌堆中随机获得一张牌。\n" ,

	["imperialedictattach"] = "放置手牌",
	[":imperialedictattach"] = "出牌阶段限一次，若你：是小势力角色，你可将至多两张手牌置于【诏书】上（均称为“诏”）；不是小势力角色，你可将一张手牌置于【诏书】上（称为“诏”）。",
	["imperialedicttrick"] = "获得锦囊",
	[":imperialedicttrick"] = "出牌阶段限一次，若有四张不同花色的“诏”，你可将所有“诏”置入弃牌堆，你从势力锦囊牌堆中随机获得一张牌。",

	["rule_the_world"] = "号令天下",
	[":rule_the_world"] = "锦囊牌·魏\n\n使用时机：出牌阶段。\n使用目标：一名体力值不是最小的角色。\n作用效果：除目标对应的角色外的角色各选择：1.{若其势力：为魏，其对目标对应的角色使用无对应的实体牌的普【杀】；不为魏，其弃置一张手牌▷其对目标对应的角色使用无对应的实体牌的普【杀】}；2.{若其势力：为魏，其获得目标对应的角色的一张牌；不为魏，其弃置目标对应的角色的一张牌}；3.获得1枚“令”。",
	["rule_the_world:slash"] = "%log视为对%to使用【杀】",
	["rule_the_world:discard"] = "%log%to的一张牌",
	["rule_the_world_slash"] = "弃置一张牌并",
	["rule_the_world_discard"] = "弃置",
	["rule_the_world_getcard"] = "获得",
	["@rule_the_world-slash"] = "号令天下：弃置一张手牌，视为对%dest使用【杀】",

	["conquering"] = "克复中原",
	[":conquering"] = "锦囊牌·蜀\n\n使用时机：出牌阶段。\n使用目标：至少一名角色。\n作用效果：目标对应的角色选择：1.使用无对应的实体牌的【杀】（有距离关系的限制。若其势力为蜀，此【杀】的伤害值基数+1）；2.摸一张牌。",
	["@conquering-slash"] = "克复中原：可视为使用一张【杀】，或点取消摸牌",

	["consolidate_country"] = "固国安邦",
	[":consolidate_country"] = "锦囊牌·吴\n\n使用时机：出牌阶段。\n使用目标：你。\n作用效果：目标对应的角色摸八张牌，选择能弃置的至少六张手牌。{若其势力为吴，其可将其以此法选择的牌中的至多六张交给与其势力相同的其他角色}。其弃置其以此法选择的牌。",

	["@consolidate_country-discard"] = "固国安邦：选择6张手牌弃置",
	["@consolidate_country-give"] = "固国安邦：可将这些牌分配给与你势力相同的角色，其余的弃置",

	["chaos"] = "文和乱武",
	[":chaos"] = "锦囊牌·群\n\n使用时机：出牌阶段。\n使用目标：所有角色。\n作用效果：目标对应的角色展示所有手牌▷{你选择：1.若其手牌区里的其能弃置的牌的类别：{不均相同，你令其弃置两张类别不同的手牌；均相同，你令其弃置一张手牌}；2.观看其手牌并弃置其中的一张}▷若其势力为群且其没有手牌，其将其手牌补至X张（X为其体力值）。",
	
	["chaos:letdiscard"] = "令%to弃置两张不同类型的手牌",
	["chaos:discard"] = "弃置%to的一张手牌",

	["@chaos-select"] = "文和乱武：选择手牌中两张不同类型的牌弃置",

	["@trick-show"] = "是否明置一张武将牌来使【%arg】获得额外的效果",
	["trick_show:show_head"] = "明置主将",
	["trick_show:show_deputy"] = "明置副将",

	["#simazhao"] = "嘲风开天",
	["designer:simazhao"] = "韩旭",
	["simazhao"] = "司马昭",
	["illustrator:simazhao"] = "凝聚永恒",
	["suzhi"] = "夙智",
	[":suzhi"] = "锁定技，①当你于回合内因执行【杀】或【决斗】的效果而造成伤害时，若使用者为你且X＜3，你令伤害值+1。②当锦囊牌于你的回合内被使用时，若使用者为你且X＜3，你摸一张牌。③当其他角色的牌于你的回合内因弃置而置入弃牌堆后，若X＜3，你获得其一张牌。④若X＜3，你于回合内使用锦囊牌无距离关系的限制。⑤回合结束时，若X＜3，你于你的下个回合开始之前拥有〖反馈〗。（X为你于此回合内发动〖夙智①〗、〖夙智②〗和〖夙智③〗的次数之和）",
	["zhaoxin"] = "昭心",
	[":zhaoxin"] = "当你受到伤害后，你可展示所有手牌▶你与一名手牌数不大于你的其他角色交换手牌。",
	["@zhaoxin-exchange"] = "昭心：选择一名手牌数不大于你的角色交换手牌",
	["fankui_simazhao"] = "反馈",
	
	
	["#xuyou"] = "毕方矫翼",
	["xuyou"] = "许攸",
	["designer:xuyou"] = "逍遥鱼叔",
	["illustrator:xuyou"] = "猎枭",
	["chenglve"] = "成略",
	[":chenglve"] = "当牌使用结算结束后，若使用者与你势力相同且此牌的目标数大于1，你可令其摸一张牌▶若你受到过渠道为此牌的伤害，你可令一名与你势力相同且两张武将牌均处于明置状态且没有“阴阳鱼”的角色获得1枚“阴阳鱼”。",
	["shicai"] = "恃才",
	[":shicai"] = "锁定技，当你受到伤害后，若伤害值：小于2，你摸两张牌；大于1，你弃置所有手牌。",

	["@chenglve-mark"] = "成略：选择一名角色获得“阴阳鱼”标记",

	["#xiahouba"] = "棘途壮志",
	["xiahouba"] = "夏侯霸",
	["designer:xiahouba"] = "逍遥鱼叔",
	["illustrator:xiahouba"] = "小牛",
	["baolie"] = "豹烈",
	[":baolie"] = "锁定技，①出牌阶段开始时，你选择所有攻击范围内有你且（你明置后会）与你势力不同的角色▶这些角色各{需对包括你在内的角色使用【杀】，否则你弃置其一张牌}。②你对体力值不小于你的角色使用【杀】无次数限制且无距离关系的限制。",
	
	["@baolie-slash"] = "豹烈：对%src使用一张【杀】，否则其弃置你一张牌",

	["#zhugeke"] = "兴家赤族",
	["zhugeke"] = "诸葛恪",
	["designer:zhugeke"] = "逍遥鱼叔",
	["illustrator:zhugeke"] = "猎枭",
	["aocai"] = "傲才",
	[":aocai"] = "当你于回合外需要使用/打出基本牌时，你可观看牌堆顶的两张牌并可使用/打出对应的实体牌为其中的与此基本牌牌名相同的一张牌且与此基本牌牌名相同的牌。",
	["duwu"] = "黩武",
	[":duwu"] = "限定技，出牌阶段，你可选择攻击范围内所有（你明置后会）与你势力不同或没有势力的角色并选择军令▶这些角色各{选择是否执行军令，若其选择否，你对其造成1点伤害，你摸一张牌}，若有于此技能结算中进入过濒死状态且存活的角色，你失去1点体力。",
	
	["#aocai"] = "傲才",
	["@aocai-view"] = "请从“傲才”牌中选择一张合适的牌",

	["#sunchen"] = "食髓的朝堂客",
	["sunchen"] = "孙綝",
	["designer:sunchen"] = "逍遥鱼叔",
	["illustrator:sunchen"] = "depp",
	["shilu"] = "嗜戮",
	[":shilu"] = "①当一名角色死亡时，你可将其所有武将牌置于你的武将牌上（称为“戮”）▶若其是你杀死的，你随机将武将牌里的两张武将牌置于你的武将牌上（均称为“戮”）。②准备阶段开始时，若你有“戮”，你可弃置至多X张牌（X为“戮”数）▶你摸等量的牌。",
	["xiongnve"] = "凶虐",
	[":xiongnve"] = "①出牌阶段开始时，你可将一张“戮”置入武将牌堆▶你选择：1.(→)当你于此回合内对与你以此法置入武将牌堆的“戮”代表的武将势力相同的角色造成伤害时，你令伤害值+1；2.(→)当你于此回合内对与你以此法置入武将牌堆的“戮”代表的武将势力相同的角色造成伤害时，你获得其一张牌；3.你于此回合内对与你以此法置入武将牌堆的“戮”代表的武将势力相同的角色使用牌无次数限制。①出牌阶段结束时，你可将两张“戮”置入武将牌堆▶(→)当你于你的下个回合开始之前受到其他角色造成的伤害时，你令伤害值-1。",

	["#xiongnve-effect"] = "凶虐",

	["massacre"] = "戮",
	["@shilu"] = "是否使用“嗜戮”，弃置至多%arg张牌并摸等量的牌",
	["@xiongnve-continue"] = "凶虐：是否继续弃置“戮”",
	
	["#GetMassacreDetail"] = "%from 获得了“戮” %arg",
	["#dropMassacreDetail"] = "%from 丢弃了“戮” %arg",
	["#GetMassacre"] = "%from 获得了 %arg 张“戮”",
	
	["@xiongnve-choice"] = "凶虐：选择一项效果",
	["xiongnve:adddamage"] = "造成的伤害+1",
	["xiongnve:extraction"] = "造成伤害时获得其一张牌",
	["xiongnve:nolimit"] = "使用牌无次数限制",
	
	["#xiongnveAdddamage"] = "%from 本回合对势力为 %arg 的角色造成的伤害+1",
	["#xiongnveExtraction"] = "%from 本回合对势力为 %arg 的角色造成伤害后获得其一张牌",
	["#xiongnveNolimit"] = "%from 本回合对势力为 %arg 的角色使用牌无次数限制",
	
	["xiongnve_avoid"] = "凶虐减伤",

	["xiongnve:attack"] = "是否使用“凶虐”，弃置一张“戮”来发动对应势力的效果",
	["xiongnve:defence"] = "是否使用“凶虐”，弃置两张“戮”来令受到的伤害-1",




	["#panjun"] = "逆鳞之砥",
	["panjun"] = "潘濬",
	["illustrator:panjun"] = "Domi",
	["designer:panjun"] = "逍遥鱼叔",
	["congcha"] = "聪察",
	[":congcha"] = "①准备阶段开始时，你可选择一名没有势力的角色▶(→)当其于你的下个回合开始之前明置武将牌后，若其于明置此武将牌之前没有势力且于明置此武将牌时与你：势力相同，你与其各摸两张牌；势力不同，其失去1点体力。②摸牌阶段，若没有没有势力的角色，你可令摸牌数+2。",
	["gongqing"] = "公清",
	[":gongqing"] = "锁定技，①当你受到伤害时，若来源的攻击范围小于3且伤害值大于1，你将伤害值改为1。②当你受到伤害时，若来源的攻击范围大于3，你令伤害值+1。",

	["@congcha-target"] = "是否使用“聪察”，选择一名没有势力的角色",
	
	["#congcha-effect"] = "聪察",
	["#gongqing-decrease"] = "公清",

	
	["#wenqin"] = "勇而无算",
	["wenqin"] = "文钦",
	["illustrator:wenqin"] = "匠人绘-零二",
	["designer:wenqin"] = "逍遥鱼叔",
	["jinfa"] = "矜伐",
	[":jinfa"] = "出牌阶段限一次，你可弃置一张牌并选择一名有牌的其他角色▶其选择：1.令你获得其一张牌；2.将一张装备牌交给你，若此牌在你的手牌区里为黑桃，其对你使用无对应的实体牌的【杀】。",
	["@jinfa-give"] = "矜伐：选择一张装备牌交给%src，或点取消令%src获得你一张牌",

	["#huangzu"] = "遮山扼江",
	["huangzu"] = "黄祖",
	["designer:huangzu"] = "逍遥鱼叔",
	["illustrator:huangzu"] = "YanBai",
	["xishe"] = "袭射",
	[":xishe"] = "其他角色的准备阶段开始时，你可弃置装备区里的一张牌▶你对其使用无对应的实体牌的【杀】（无距离关系的限制，若其体力值小于你，所有角色不能响应此【杀】），你可重复此流程→此回合结束前，若你于此回合内因渠道为此【杀】的伤害而杀死过角色，你可变更（以此法作为你的副将的武将牌处于暗置状态）。",
	["@xishe-slash"] = "是否使用“袭射”，弃置装备区里的牌视为对%src使用【杀】",
	
	["#xishe-transform"] = "袭射",
	
	["#gongsunyuan"] = "狡黠的投机者",
	["gongsunyuan"] = "公孙渊",
	["designer:gongsunyuan"] = "逍遥鱼叔",
	["illustrator:gongsunyuan"] = "猎枭",
	["huaiyi"] = "怀异",
	[":huaiyi"] = "出牌阶段限一次，你可展示所有手牌▶若不为同一颜色，你选择一种颜色，弃置所有为此颜色的手牌，选择至多X名有牌的其他角色，获得这些角色的各一张牌（X为你以此法弃置的手牌数），将你以此法得到的牌中的所有装备牌置于你的武将牌上（均称为“异”）。",
	["zisui"] = "恣睢",
	[":zisui"] = "锁定技，①摸牌阶段，若有“异”，你多摸X张牌（X为“异”数）。②结束阶段开始时，若“异”数大于你的体力上限，你死亡。",
	
	["@huaiyi-choose"] = "怀异：选择弃置一种颜色的手牌",
	["@huaiyi-snatch"] = "怀异：选择至多%arg名角色，获得这些角色各一张牌",
	["huaiyi:red"] = "红色",
	["huaiyi:black"] = "黑色",
	
	["disloyalty"] = "异",

	["#pengyang"] = "误身的狂士",
	["pengyang"] = "彭羕",
	["illustrator:pengyang"] = "匠人绘-零一",
	["designer:pengyang"] = "逍遥鱼叔",
	["daming"] = "达命",
	[":daming"] = "与你势力相同的角色的出牌阶段开始时，你可弃置一张锦囊牌▶你令一名角色横置，摸X张牌（X为处于连环状态的角色的势力数），选择：1.对当前回合角色使用无对应的实体牌的【桃】；2.当前回合角色对你选择的另一名角色使用无对应的实体牌的雷【杀】。",
	["xiaoni"] = "嚣逆",
	[":xiaoni"] = "锁定技，①当{【杀】或普通锦囊牌}指定第一个目标后，若使用者为你且有与你势力相同的其他角色且这些角色的手牌数均不大于你，"..
		"你令所有是此牌的目标对应的角色的角色不能响应此牌。②当你成为{【杀】或普通锦囊牌}的目标后，若使用者不为你且有与你势力相同的其他角色且这些角色的手牌数均不大于你，"..
		"你令你不能响应此牌。",
	
	["@daming"] = "是否对%dest使用“达命”，弃置一张锦囊牌",
	["@daming-chain"] = "达命：选择要横置的角色",
	["@daming-choice"] = "达命：选择%dest要执行的效果",
	["daming:peach"] = "使用【桃】",
	["daming:slash"] = "使用雷【杀】",
	["@daming-slash"] = "达命：选择%dest使用【杀】的目标",

	["#sufei"] = "诤友投明",
	["sufei"] = "苏飞",
	["designer:sufei"] = "逍遥鱼叔",
	["illustrator:sufei"] = "Domi",
	["lianpian"] = "联翩",
	[":lianpian"] = "①结束阶段开始时，若你于此回合内弃置过所有角色的牌数之和大于你的体力值，你可令一名与你势力相同的角色将手牌补至X张（X为其体力上限）。②其他角色的结束阶段开始时，若其于此回合内弃置过所有角色的牌数之和大于你的体力值，（你令）其可选择：1.弃置你的一张牌；2.令你回复1点体力。",

	["@lianpian-target"] = "是否使用“联翩”，选择一名角色将手牌补至体力上限",
	["@lianpian"] = "是否使用%src的“联翩”",
	["#lianpian-other"] = "联翩",
	["lianpian:discard"] = "弃置其一张牌",
	["lianpian:recover"] = "令其回复体力",

	["#liuba"] = "清河一鲲",
	["liuba"] = "刘巴",
	["illustrator:liuba"] = "Mr_Sleeping",
	["designer:liuba"] = "逍遥鱼叔",
	["tongdu"] = "统度",
	[":tongdu"] = "与你势力相同的角色的结束阶段开始时，（你令）其可摸X张牌（X=min{其于此回合的弃牌阶段内弃置过的牌数, 3}）。",
	["qingyin"] = "清隐",
	[":qingyin"] = "限定技，出牌阶段，你可选择所有（你明置后会）与你势力相同的角色▶这些角色各回复X点体力（X为其体力上限-体力值）。你移除此武将牌。",
	["@tongdu"] = "是否使用%src的“统度”",
	["#tongdu-other"] = "统度",

	["#zhuling"] = "五子之亚",
	["zhuling"] = "朱灵",
	["designer:zhuling"] = "逍遥鱼叔",
	["illustrator:zhuling"] = "YanBai",
	["juejue"] = "决绝",
	[":juejue"] = "①弃牌阶段开始时，你可失去1点体力▶(→)此阶段结束时，若你于此阶段内弃置过你的牌，你令其他角色各选择：1.将X张手牌置入弃牌堆（X为你于此阶段内弃置过你的牌数）；2.受到你造成的1点普通伤害。②你杀死与你势力相同的角色不执行奖惩。",
	["fangyuan"] = "方圆",
	[":fangyuan"] = "阵法技，①你为围攻角色的围攻关系中的围攻角色的手牌上限+1。②你为围攻角色的围攻关系中的被围攻角色的手牌上限-1。③结束阶段开始时，你对为你为被围攻角色的围攻关系中的围攻角色的一名角色使用无对应的实体牌的【杀】。",
	["@fangyuan-slash"] = "方圆：选择一名围攻你的角色，视为对其使用【杀】",
	
	["@juejue-discard"] = "决绝：选择%arg张手牌置入弃牌堆，或%src对你造成1点伤害",
	
	["#fangyuan-maxcards"] = "方圆",


	["#test"] = "%arg",
}