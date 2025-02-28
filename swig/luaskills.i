﻿/********************************************************************
    Copyright (c) 2013-2015 - Mogara

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
*********************************************************************/

class LuaTriggerSkill: public TriggerSkill {
public:
    LuaTriggerSkill(const char *name, Frequency frequency, const char *limit_mark);
    void addEvent(TriggerEvent triggerEvent);
    void setViewAsSkill(ViewAsSkill *view_as_skill);
    void setGlobal(bool global);
    void setCanPreshow(bool preshow);
    void setGuhuoType(const char *type);
    

    virtual int getPriority() const;

    virtual TriggerList triggerable(TriggerEvent triggerEvent, Room *room, ServerPlayer *player, QVariant &data) const;
    virtual bool cost(TriggerEvent triggerEvent, Room *room, ServerPlayer *player, QVariant &data, ServerPlayer *ask_who = NULL) const;
    virtual bool effect(TriggerEvent triggerEvent, Room *room, ServerPlayer *player, QVariant &data, ServerPlayer *ask_who = NULL) const;
    void onTurnBroken(const char *function_name,TriggerEvent triggerEvent, Room *room, ServerPlayer *player, QVariant &data, ServerPlayer *ask_who = NULL) const;
    virtual void record(TriggerEvent triggerEvent, Room *room, ServerPlayer *player, QVariant &data) const;

    LuaFunction on_record;
    LuaFunction can_trigger;
    LuaFunction on_cost;
    LuaFunction on_effect;
    LuaFunction on_turn_broken;

    int priority;
    bool can_preshow;
};

class BattleArraySkill: public TriggerSkill {
public:
    BattleArraySkill(const QString &name,const HegemonyMode::ArrayType type);

    virtual void summonFriends(ServerPlayer *player) const;

    HegemonyMode::ArrayType getArrayType() const;
};

class LuaBattleArraySkill: public BattleArraySkill {
public:
    LuaBattleArraySkill(const char *name, Frequency frequency, const char *limit_mark, HegemonyMode::ArrayType array_type);
    void addEvent(TriggerEvent triggerEvent);
    void setViewAsSkill(ViewAsSkill *view_as_skill);

    virtual int getPriority() const;

    virtual TriggerList triggerable(TriggerEvent triggerEvent, Room *room, ServerPlayer *player, QVariant &data) const;
    virtual bool cost(TriggerEvent triggerEvent, Room *room, ServerPlayer *player, QVariant &data, ServerPlayer *ask_who = NULL) const;
    virtual bool effect(TriggerEvent triggerEvent, Room *room, ServerPlayer *player, QVariant &data, ServerPlayer *ask_who = NULL) const;
    void onTurnBroken(const char *function_name,TriggerEvent triggerEvent, Room *room, ServerPlayer *player, QVariant &data, ServerPlayer *ask_who = NULL) const;
    virtual void record(TriggerEvent triggerEvent, Room *room, ServerPlayer *player, QVariant &data) const;

    LuaFunction on_record;
    LuaFunction can_trigger;
    LuaFunction on_cost;
    LuaFunction on_effect;
    LuaFunction on_turn_broken;

    int priority;
};

class ProhibitSkill: public Skill {
public:
    ProhibitSkill(const QString &name);

    virtual bool isProhibited(const Player *from, const Player *to, const Card *card, const QList<const Player *> &others = QList<const Player *>()) const = 0;
};

class FixCardSkill : public Skill {
public:
    FixCardSkill(const QString &name);

    virtual bool isCardFixed(const Player *from, const Player *to, const QString &flags, Card::HandlingMethod method) const = 0;
};

class DistanceSkill: public Skill {
public:
    DistanceSkill(const QString &name);

    virtual int getCorrect(const Player *from, const Player *to) const = 0;
};

class MaxCardsSkill: public Skill {
public:
    MaxCardsSkill(const QString &name);

    virtual int getExtra(const Player *target) const;
    virtual int getFixed(const Player *target) const;
};

class TargetModSkill: public Skill {
public:
    enum ModType {
        Residue,
        DistanceLimit,
        ExtraTarget
    };

    TargetModSkill(const QString &name);
    virtual QString getPattern() const;

    virtual int getResidueNum(const Player *from, const Card *card, const Player *to) const;
    virtual int getDistanceLimit(const Player *from, const Card *card, const Player *to) const;
    virtual int getExtraTargetNum(const Player *from, const Card *card) const;

protected:
    QString pattern;
};

class LuaProhibitSkill: public ProhibitSkill {
public:
    LuaProhibitSkill(const char *name);

    virtual bool isProhibited(const Player *from, const Player *to, const Card *card, const QList<const Player *> &others = QList<const Player *>()) const;

    LuaFunction is_prohibited;
};

class LuaFixCardSkill: public FixCardSkill {
public:
    LuaFixCardSkill(const char *name);

    virtual bool isCardFixed(const Player *from, const Player *to, const QString &flags, Card::HandlingMethod method) const;

    LuaFunction is_cardfixed;
};

class ViewHasSkill : public Skill {

public:
    ViewHasSkill(const QString &name);

    virtual bool ViewHas(const Player *player, const QString &skill_name, const QString &flag) const = 0;
};

class LuaViewHasSkill : public ViewHasSkill {
public:
    LuaViewHasSkill(const char *name);
    virtual bool ViewHas(const Player *player, const QString &skill_name, const QString &flag) const;
    void setGlobal(bool global);

    LuaFunction is_viewhas;
};

class ViewAsSkill: public Skill {
public:
    ViewAsSkill(const QString &name);

    virtual bool viewFilter(const QList<const Card *> &selected, const Card *to_select) const = 0;
    virtual const Card *viewAs(const QList<const Card *> &cards) const = 0;

    virtual bool isEnabledAtPlay(const Player *player) const;
    virtual bool isEnabledAtResponse(const Player *player, const char *pattern) const;

    bool isResponseOrUse() const;
    QString getExpandPile() const;
};

class LuaViewAsSkill: public ViewAsSkill {
public:
    LuaViewAsSkill(const char *name, const char *response_pattern, bool response_or_use, const char *expand_pile, const char *limit_mark);

    void setGuhuoType(const char *type);
    
    virtual bool viewFilter(const QList<const Card *> &selected, const Card *to_select) const;
    virtual const Card *viewAs(const QList<const Card *> &cards) const;

    LuaFunction view_filter;
    LuaFunction view_as;

    LuaFunction enabled_at_play;
    LuaFunction enabled_at_response;
    LuaFunction enabled_at_nullification;
    LuaFunction in_pile;
};

class OneCardViewAsSkill: public ViewAsSkill {
public:
    OneCardViewAsSkill(const QString &name);

    virtual bool viewFilter(const QList<const Card *> &selected, const Card *to_select) const;
    virtual const Card *viewAs(const QList<const Card *> &cards) const;

    virtual bool viewFilter(const Card *to_select) const = 0;
    virtual const Card *viewAs(const Card *originalCard) const = 0;
};

class FilterSkill: public OneCardViewAsSkill {
public:
    FilterSkill(const QString &name);

    virtual bool viewFilter(const Card *to_select, ServerPlayer *player) const = 0;
};

class LuaFilterSkill: public FilterSkill {
public:
    LuaFilterSkill(const char *name);

    virtual bool viewFilter(const Card *to_select, ServerPlayer *player) const;
    virtual const Card *viewAs(const Card *originalCard) const;

    LuaFunction view_filter;
    LuaFunction view_as;
};

class LuaDistanceSkill: public DistanceSkill {
public:
    LuaDistanceSkill(const char *name);
    virtual int getCorrect(const Player *from, const Player *to) const;

    LuaFunction correct_func;
};

class LuaMaxCardsSkill: public MaxCardsSkill {
public:
    LuaMaxCardsSkill(const char *name);
    virtual int getExtra(const Player *target) const;
    virtual int getFixed(const Player *target) const;

    LuaFunction extra_func;
    LuaFunction fixed_func;
};

class AttackRangeSkill: public Skill{
public:
    AttackRangeSkill(const QString &name);

    virtual int getExtra(const Player *target, bool include_weapon) const;
    virtual int getFixed(const Player *target, bool include_weapon) const;
};

class LuaAttackRangeSkill: public AttackRangeSkill{
public:
    LuaAttackRangeSkill(const char *name);

    virtual int getExtra(const Player *target, bool include_weapon) const;
    virtual int getFixed(const Player *target, bool include_weapon) const;

    LuaFunction extra_func;
    LuaFunction fixed_func;
};

class LuaTargetModSkill: public TargetModSkill {
public:
    LuaTargetModSkill(const char *name, const char *pattern);

    virtual int getResidueNum(const Player *from, const Card *card, const Player *to) const;
    virtual int getDistanceLimit(const Player *from, const Card *card, const Player *to) const;
    virtual int getExtraTargetNum(const Player *from, const Card *card) const;

    LuaFunction residue_func;
    LuaFunction distance_limit_func;
    LuaFunction extra_target_func;
};

class LuaSkillCard: public SkillCard {
public:
    LuaSkillCard(const char *name, const char *skillName);
    void setTargetFixed(bool target_fixed);
    void setWillThrow(bool will_throw);
    void setCanRecast(bool can_recast);
    void setMute(bool isMute);
    void setHandlingMethod(Card::HandlingMethod handling_method);
    void onTurnBroken(const char *function_name, Room *room, QVariant &value);
    LuaSkillCard *clone() const;
    

    LuaFunction filter;
    LuaFunction feasible;
    LuaFunction about_to_use;
    LuaFunction on_use;
    LuaFunction on_effect;
    LuaFunction on_validate;
    LuaFunction on_validate_in_response;
    LuaFunction extra_cost;
    LuaFunction on_turn_broken;
};

class LuaBasicCard: public BasicCard {
public:
    LuaBasicCard(Card::Suit suit, int number, const char *obj_name, const char *class_name, const char *subtype);
    LuaBasicCard *clone(Card::Suit suit = Card::SuitToBeDecided, int number = -1) const;
    void setTargetFixed(bool target_fixed);
    void setCanRecast(bool can_recast);

    virtual void onUse(Room *room, const CardUseStruct &card_use) const;
    virtual void onEffect(const CardEffectStruct &effect) const;
    virtual void use(Room *room, ServerPlayer *source, QList<ServerPlayer *> &targets) const;

    virtual bool targetsFeasible(const QList<const Player *> &targets, const Player *Self) const;
    virtual bool targetFilter(const QList<const Player *> &targets, const Player *to_select, const Player *Self) const;
    virtual bool isAvailable(const Player *player) const;

    virtual QString getClassName() const;
    virtual QString getSubtype() const;
    virtual bool isKindOf(const char *cardType) const;

    // the lua callbacks
    LuaFunction filter;
    LuaFunction feasible;
    LuaFunction available;
    LuaFunction about_to_use;
    LuaFunction on_use;
    LuaFunction on_effect;
};

class LuaTrickCard: public TrickCard {
public:
    enum SubClass { TypeNormal, TypeSingleTargetTrick, TypeDelayedTrick, TypeAOE, TypeGlobalEffect };

    LuaTrickCard(Card::Suit suit, int number, const char *obj_name, const char *class_name, const char *subtype);
    LuaTrickCard *clone(Card::Suit suit = Card::SuitToBeDecided, int number = -1) const;
    void setTargetFixed(bool target_fixed);
    void setCanRecast(bool can_recast);

    virtual void onUse(Room *room, const CardUseStruct &card_use) const;
    virtual void onEffect(const CardEffectStruct &effect) const;
    virtual void use(Room *room, ServerPlayer *source, QList<ServerPlayer *> &targets) const;
    virtual void onNullified(ServerPlayer *target) const;
    virtual bool isCancelable(const CardEffectStruct &effect) const;

    virtual bool targetsFeasible(const QList<const Player *> &targets, const Player *Self) const;
    virtual bool targetFilter(const QList<const Player *> &targets, const Player *to_select, const Player *Self) const;
    virtual bool isAvailable(const Player *player) const;

    virtual QString getClassName() const;
    void setSubClass(SubClass subclass);
    SubClass getSubClass() const;
    virtual QString getSubtype() const;
    virtual bool isKindOf(const char *cardType) const;

    // the lua callbacks
    LuaFunction filter;
    LuaFunction feasible;
    LuaFunction available;
    LuaFunction is_cancelable;
    LuaFunction about_to_use;
    LuaFunction on_use;
    LuaFunction on_effect;
    LuaFunction on_nullified;
};

class LuaWeapon: public Weapon {
public:
    LuaWeapon(Card::Suit suit, int number, int range, const char *obj_name, const char *class_name);
    LuaWeapon *clone(Card::Suit suit = Card::SuitToBeDecided, int number = -1) const;

    virtual void onInstall(ServerPlayer *player) const;
    virtual void onUninstall(ServerPlayer *player) const;

    virtual QString getClassName();
    virtual bool isKindOf(const char *cardType);

    // the lua callbacks
    LuaFunction on_install;
    LuaFunction on_uninstall;
};

class LuaArmor: public Armor {
public:
    LuaArmor(Card::Suit suit, int number, const char *obj_name, const char *class_name);
    LuaArmor *clone(Card::Suit suit = Card::SuitToBeDecided, int number = -1) const;

    virtual void onInstall(ServerPlayer *player) const;
    virtual void onUninstall(ServerPlayer *player) const;

    virtual QString getClassName();
    virtual bool isKindOf(const char *cardType);

    // the lua callbacks
    LuaFunction on_install;
    LuaFunction on_uninstall;
};

class LuaTreasure: public Treasure {
public:
    LuaTreasure(Card::Suit suit, int number, const char *obj_name, const char *class_name);
    LuaTreasure *clone(Card::Suit suit = Card::SuitToBeDecided, int number = -1) const;

    virtual void onInstall(ServerPlayer *player) const;
    virtual void onUninstall(ServerPlayer *player) const;

    virtual QString getClassName();
    virtual bool isKindOf(const char *cardType);

    // the lua callbacks
    LuaFunction on_install;
    LuaFunction on_uninstall;
};


class Scenario : public Package
{
public:
    bool exposeRoles() const;
    int getPlayerCount() const;
    QString getRoles() const;
};

class LuaScenario : public Scenario
{
public:
    LuaScenario(const char *name);

    void setRule(LuaTriggerSkill *rule);
    
    bool exposeRoles() const;
    int getPlayerCount() const;
    QString getRoles() const;
    void assign(QStringList &generals, QStringList &generals2, QStringList &roles, Room *room) const;
    AI::Relation relationTo(const ServerPlayer *a, const ServerPlayer *b) const;
    void onTagSet(Room *room, const char *key) const;
    bool generalSelection() const;
    void setRandomSeat(bool random);

    bool expose_role;
    int player_count;
    bool general_selection;

    LuaFunction on_assign;
    LuaFunction relation;
    LuaFunction on_tag_set;
};

%{

#include "lua-wrapper.h"
#include "clientplayer.h"
#include "scenario.h"

void LuaTriggerSkill::record(TriggerEvent triggerEvent, Room *room, ServerPlayer *player, QVariant &data) const
{
    if (on_record == 0)
        return;
    try {
        lua_State *l = room->getLuaState();
        lua_rawgeti(l, LUA_REGISTRYINDEX, on_record);

        LuaTriggerSkill *self = const_cast<LuaTriggerSkill *>(this);
        SWIG_NewPointerObj(l, self, SWIGTYPE_p_LuaTriggerSkill, 0);

        int e = static_cast<int>(triggerEvent);

        lua_pushinteger(l, e);

        SWIG_NewPointerObj(l, room, SWIGTYPE_p_Room, 0);

        // the third argument: player
        SWIG_NewPointerObj(l, player, SWIGTYPE_p_ServerPlayer, 0);

        // the last event: data
        SWIG_NewPointerObj(l, &data, SWIGTYPE_p_QVariant, 0);

        int error = lua_pcall(l, 5, 0, 0);
        if (error) {
            const char *msg = lua_tostring(l, -1);
            lua_pop(l, 1);
            room->output(msg);
            return;
        }
    }
    catch (TriggerEvent e) {
        if (e == TurnBroken || e == StageChange)
            onTurnBroken("on_record", triggerEvent, room, player, data, NULL);
        throw e;
    }
}

TriggerList LuaTriggerSkill::triggerable(TriggerEvent triggerEvent, Room *room, ServerPlayer *player, QVariant &data) const
{
    if (can_trigger == 0)
        return TriggerSkill::triggerable(triggerEvent, room, player, data);
    try {
        lua_State *l = room->getLuaState();
        lua_rawgeti(l, LUA_REGISTRYINDEX, can_trigger);

        LuaTriggerSkill *self = const_cast<LuaTriggerSkill *>(this);
        SWIG_NewPointerObj(l, self, SWIGTYPE_p_LuaTriggerSkill, 0);

        int e = static_cast<int>(triggerEvent);

        lua_pushinteger(l, e);

        SWIG_NewPointerObj(l, room, SWIGTYPE_p_Room, 0);

        // the third argument: player
        SWIG_NewPointerObj(l, player, SWIGTYPE_p_ServerPlayer, 0);

        // the last event: data
        SWIG_NewPointerObj(l, &data, SWIGTYPE_p_QVariant, 0);

        int error = lua_pcall(l, 5, 2, 0);
        if (error) {
            const char *msg = lua_tostring(l, -1);
            lua_pop(l, 1);
            room->output(msg);
            return TriggerSkill::triggerable(triggerEvent, room, player, data);
        } else {
            QString trigger_str = lua_tostring(l, -2);
            TriggerList skill_list;
            QString obj_name_str = lua_tostring(l, -1);
            if (obj_name_str.isNull()) {
                void *ask_who_p = NULL;
                int convert_result = SWIG_ConvertPtr(l, -1, &ask_who_p, SWIGTYPE_p_ServerPlayer, 0);
                if (!SWIG_IsOK(convert_result) || ask_who_p == NULL) {
                    ServerPlayer *who = player;
                    QStringList trigger_list = trigger_str.split(",");
                    skill_list.insert(who, trigger_list);
                } else {
                    ServerPlayer *who = static_cast<ServerPlayer *>(ask_who_p);
                    QStringList trigger_list = trigger_str.split(",");
                    skill_list.insert(who, trigger_list);
                }
            } else {
                QStringList who_skill_list = trigger_str.split("|");
                QStringList obj_name_list = obj_name_str.split("|");
                int index = 0;
                while (who_skill_list.size() > index) {
                    ServerPlayer *who = player;
                    if (obj_name_list.size() > index)
                        who = room->findPlayer(obj_name_list.at(index), true);
                    if (who)
                        skill_list.insert(who, who_skill_list.at(index).split(","));
                    index++;
                }
            }
            lua_pop(l, 2);
            return skill_list;
        }
    }
    catch (TriggerEvent e) {
        if (e == TurnBroken || e == StageChange)
            onTurnBroken("can_trigger", triggerEvent, room, player, data, NULL);
        throw e;
    }
}

bool LuaTriggerSkill::cost(TriggerEvent triggerEvent, Room *room, ServerPlayer *player, QVariant &data, ServerPlayer *ask_who) const
{
    if (on_cost == 0)
        return TriggerSkill::cost(triggerEvent, room, player, data, ask_who);
    try {
        lua_State *L = room->getLuaState();

        int e = static_cast<int>(triggerEvent);

        // the callback
        lua_rawgeti(L, LUA_REGISTRYINDEX, on_cost);

        LuaTriggerSkill *self = const_cast<LuaTriggerSkill *>(this);
        SWIG_NewPointerObj(L, self, SWIGTYPE_p_LuaTriggerSkill, 0);

        // the first argument: event
        lua_pushinteger(L, e);

        SWIG_NewPointerObj(L, room, SWIGTYPE_p_Room, 0);

        // the third argument: player
        SWIG_NewPointerObj(L, player, SWIGTYPE_p_ServerPlayer, 0);

        // the forth event: data
        SWIG_NewPointerObj(L, &data, SWIGTYPE_p_QVariant, 0);

        // the last event: ask_who
        SWIG_NewPointerObj(L, ask_who, SWIGTYPE_p_ServerPlayer, 0);

        int error = lua_pcall(L, 6, 1, 0);
        if (error) {
            const char *error_msg = lua_tostring(L, -1);
            lua_pop(L, 1);
            room->output(error_msg);
            return true;
        } else {
            bool result = lua_toboolean(L, -1);
            lua_pop(L, 1);
            return result;
        }
    }
    catch (TriggerEvent e) {
        if (e == TurnBroken || e == StageChange)
            onTurnBroken("on_cost", triggerEvent, room, player, data, ask_who);
        throw e;
    }
}

bool LuaTriggerSkill::effect(TriggerEvent triggerEvent, Room *room, ServerPlayer *player, QVariant &data, ServerPlayer *ask_who) const
{
    if (on_effect == 0)
        return TriggerSkill::effect(triggerEvent, room, player, data, ask_who);

    try {
        lua_State *L = room->getLuaState();

        int e = static_cast<int>(triggerEvent);

        // the callback
        lua_rawgeti(L, LUA_REGISTRYINDEX, on_effect);

        LuaTriggerSkill *self = const_cast<LuaTriggerSkill *>(this);
        SWIG_NewPointerObj(L, self, SWIGTYPE_p_LuaTriggerSkill, 0);

        // the first argument: event
        lua_pushinteger(L, e);

        SWIG_NewPointerObj(L, room, SWIGTYPE_p_Room, 0);

        // the third argument: player
        SWIG_NewPointerObj(L, player, SWIGTYPE_p_ServerPlayer, 0);

        // the forth event: data
        SWIG_NewPointerObj(L, &data, SWIGTYPE_p_QVariant, 0);

        // the last event: ask_who
        SWIG_NewPointerObj(L, ask_who, SWIGTYPE_p_ServerPlayer, 0);

        int error = lua_pcall(L, 6, 1, 0);
        if (error) {
            const char *error_msg = lua_tostring(L, -1);
            lua_pop(L, 1);
            room->output(error_msg);
            return false;
        } else {
            bool result = lua_toboolean(L, -1);
            lua_pop(L, 1);
            return result;
        }
    }
    catch (TriggerEvent e) {
        if (e == TurnBroken || e == StageChange)
            onTurnBroken("on_effect", triggerEvent, room, player, data, ask_who);
        throw e;
    }
}

void LuaTriggerSkill::onTurnBroken(const char *function_name, TriggerEvent triggerEvent, Room *room, ServerPlayer *player, QVariant &data, ServerPlayer *ask_who) const
{
    if (on_turn_broken == 0)
        return;

    lua_State *L = room->getLuaState();

    int e = static_cast<int>(triggerEvent);

    // the callback
    lua_rawgeti(L, LUA_REGISTRYINDEX, on_turn_broken);

    LuaTriggerSkill *self = const_cast<LuaTriggerSkill *>(this);
    SWIG_NewPointerObj(L, self, SWIGTYPE_p_LuaTriggerSkill, 0);

    //first arg: function_name

    lua_pushstring(L, function_name);

    // the second argument: event
    lua_pushinteger(L, e);

    SWIG_NewPointerObj(L, room, SWIGTYPE_p_Room, 0);

    // the third argument: player
    SWIG_NewPointerObj(L, player, SWIGTYPE_p_ServerPlayer, 0);

    // the forth event: data
    SWIG_NewPointerObj(L, &data, SWIGTYPE_p_QVariant, 0);

    // the last event: ask_who
    SWIG_NewPointerObj(L, ask_who, SWIGTYPE_p_ServerPlayer, 0);

    int error = lua_pcall(L, 7, 0, 0);
    if (error) {
        const char *error_msg = lua_tostring(L, -1);
        lua_pop(L, 1);
        room->output(error_msg);
    }
}

void LuaBattleArraySkill::record(TriggerEvent triggerEvent, Room *room, ServerPlayer *player, QVariant &data) const
{
    if (on_record == 0)
        return;
    try {
        lua_State *l = room->getLuaState();

        lua_rawgeti(l, LUA_REGISTRYINDEX, on_record);

        LuaBattleArraySkill *self = const_cast<LuaBattleArraySkill *>(this);
        SWIG_NewPointerObj(l, self, SWIGTYPE_p_LuaBattleArraySkill, 0);

        int e = static_cast<int>(triggerEvent);

        lua_pushinteger(l, e);

        SWIG_NewPointerObj(l, room, SWIGTYPE_p_Room, 0);

        // the third argument: player
        SWIG_NewPointerObj(l, player, SWIGTYPE_p_ServerPlayer, 0);

        // the last event: data
        SWIG_NewPointerObj(l, &data, SWIGTYPE_p_QVariant, 0);

        int error = lua_pcall(l, 5, 0, 0);
        if (error) {
            const char *msg = lua_tostring(l, -1);
            lua_pop(l, 1);
            room->output(msg);
            return;
        }
    }
    catch (TriggerEvent e) {
        if (e == TurnBroken || e == StageChange)
            onTurnBroken("on_record", triggerEvent, room, player, data, NULL);
        throw e;
    }
}

TriggerList LuaBattleArraySkill::triggerable(TriggerEvent triggerEvent, Room *room, ServerPlayer *player, QVariant &data) const
{
    if (can_trigger == 0) {
        TriggerList r;
        if (BattleArraySkill::triggerable(player))
            r[player] << objectName();

        return r;
    }

    try {
        lua_State *l = room->getLuaState();

        lua_rawgeti(l, LUA_REGISTRYINDEX, can_trigger);

        LuaBattleArraySkill *self = const_cast<LuaBattleArraySkill *>(this);
        SWIG_NewPointerObj(l, self, SWIGTYPE_p_LuaBattleArraySkill, 0);

        int e = static_cast<int>(triggerEvent);

        lua_pushinteger(l, e);

        SWIG_NewPointerObj(l, room, SWIGTYPE_p_Room, 0);

        // the third argument: player
        SWIG_NewPointerObj(l, player, SWIGTYPE_p_ServerPlayer, 0);

        // the last event: data
        SWIG_NewPointerObj(l, &data, SWIGTYPE_p_QVariant, 0);

        int error = lua_pcall(l, 5, 2, 0);
        if (error) {
            const char *msg = lua_tostring(l, -1);
            lua_pop(l, 1);
            room->output(msg);
            return TriggerSkill::triggerable(triggerEvent, room, player, data);
        } else {
            QString trigger_str = lua_tostring(l, -2);
            TriggerList skill_list;
            QString obj_name_str = lua_tostring(l, -1);
            if (obj_name_str.isNull()) {
                void *ask_who_p = NULL;
                int convert_result = SWIG_ConvertPtr(l, -1, &ask_who_p, SWIGTYPE_p_ServerPlayer, 0);
                if (!SWIG_IsOK(convert_result) || ask_who_p == NULL) {
                    ServerPlayer *who = player;
                    QStringList trigger_list = trigger_str.split("+");
                    skill_list.insert(who, trigger_list);
                } else {
                    ServerPlayer *who = static_cast<ServerPlayer *>(ask_who_p);
                    QStringList trigger_list = trigger_str.split("+");
                    skill_list.insert(who, trigger_list);
                }
            } else {
                QStringList who_skill_list = trigger_str.split("|");
                QStringList obj_name_list = obj_name_str.split("|");
                int index = 0;
                while (who_skill_list.size() > index) {
                    ServerPlayer *who = player;
                    if (obj_name_list.at(index).size() > index)
                        who = room->findPlayer(obj_name_list.at(index), true);
                    if (who)
                        skill_list.insert(who, who_skill_list.at(index).split("+"));
                    index++;
                }
            }

            lua_pop(l, 2);
            return skill_list;
        }
    }
    catch (TriggerEvent e) {
        if (e == TurnBroken || e == StageChange)
            onTurnBroken("can_trigger", triggerEvent, room, player, data, NULL);
        throw e;
    }
}

bool LuaBattleArraySkill::cost(TriggerEvent triggerEvent, Room *room, ServerPlayer *player, QVariant &data, ServerPlayer *ask_who) const
{
    if (on_cost == 0)
        return BattleArraySkill::cost(triggerEvent, room, player, data, ask_who);
    try {
        lua_State *L = room->getLuaState();

        int e = static_cast<int>(triggerEvent);

        // the callback
        lua_rawgeti(L, LUA_REGISTRYINDEX, on_cost);

        LuaBattleArraySkill *self = const_cast<LuaBattleArraySkill *>(this);
        SWIG_NewPointerObj(L, self, SWIGTYPE_p_LuaBattleArraySkill, 0);

        // the first argument: event
        lua_pushinteger(L, e);

        SWIG_NewPointerObj(L, room, SWIGTYPE_p_Room, 0);

        // the third argument: player
        SWIG_NewPointerObj(L, player, SWIGTYPE_p_ServerPlayer, 0);

        // the forth event: data
        SWIG_NewPointerObj(L, &data, SWIGTYPE_p_QVariant, 0);

        // the last event: ask_who
        SWIG_NewPointerObj(L, ask_who, SWIGTYPE_p_ServerPlayer, 0);

        int error = lua_pcall(L, 6, 1, 0);
        if (error) {
            const char *error_msg = lua_tostring(L, -1);
            lua_pop(L, 1);
            room->output(error_msg);
            return true;
        } else {
            bool result = lua_toboolean(L, -1);
            lua_pop(L, 1);
            return result;
        }

    }
    catch (TriggerEvent e) {
        if (e == TurnBroken || e == StageChange)
            onTurnBroken("on_cost", triggerEvent, room, player, data, ask_who);
        throw e;
    }
}

bool LuaBattleArraySkill::effect(TriggerEvent triggerEvent, Room *room, ServerPlayer *player, QVariant &data, ServerPlayer *ask_who) const
{
    if (on_effect == 0)
        return BattleArraySkill::effect(triggerEvent, room, player, data, ask_who);
    try {
        lua_State *L = room->getLuaState();

        int e = static_cast<int>(triggerEvent);

        // the callback
        lua_rawgeti(L, LUA_REGISTRYINDEX, on_effect);

        LuaBattleArraySkill *self = const_cast<LuaBattleArraySkill *>(this);
        SWIG_NewPointerObj(L, self, SWIGTYPE_p_LuaBattleArraySkill, 0);

        // the first argument: event
        lua_pushinteger(L, e);

        SWIG_NewPointerObj(L, room, SWIGTYPE_p_Room, 0);

        // the third argument: player
        SWIG_NewPointerObj(L, player, SWIGTYPE_p_ServerPlayer, 0);

        // the forth event: data
        SWIG_NewPointerObj(L, &data, SWIGTYPE_p_QVariant, 0);

        // the last event: ask_who
        SWIG_NewPointerObj(L, ask_who, SWIGTYPE_p_ServerPlayer, 0);

        int error = lua_pcall(L, 6, 1, 0);
        if (error) {
            const char *error_msg = lua_tostring(L, -1);
            lua_pop(L, 1);
            room->output(error_msg);
            return false;
        } else {
            bool result = lua_toboolean(L, -1);
            lua_pop(L, 1);
            return result;
        }
    }
    catch (TriggerEvent e) {
        if (e == TurnBroken || e == StageChange)
            onTurnBroken("on_effect", triggerEvent, room, player, data, ask_who);
        throw e;
    }
}

void LuaBattleArraySkill::onTurnBroken(const char *function_name, TriggerEvent triggerEvent, Room *room, ServerPlayer *player, QVariant &data, ServerPlayer *ask_who) const
{
    if (on_turn_broken == 0)
        return;

    lua_State *L = room->getLuaState();

    int e = static_cast<int>(triggerEvent);

    // the callback
    lua_rawgeti(L, LUA_REGISTRYINDEX, on_turn_broken);

    LuaBattleArraySkill *self = const_cast<LuaBattleArraySkill *>(this);
    SWIG_NewPointerObj(L, self, SWIGTYPE_p_LuaBattleArraySkill, 0);

    //first arg: function_name

    lua_pushstring(L, function_name);

    // the second argument: event
    lua_pushinteger(L, e);

    SWIG_NewPointerObj(L, room, SWIGTYPE_p_Room, 0);

    // the third argument: player
    SWIG_NewPointerObj(L, player, SWIGTYPE_p_ServerPlayer, 0);

    // the forth event: data
    SWIG_NewPointerObj(L, &data, SWIGTYPE_p_QVariant, 0);

    // the last event: ask_who
    SWIG_NewPointerObj(L, ask_who, SWIGTYPE_p_ServerPlayer, 0);

    int error = lua_pcall(L, 7, 0, 0);
    if (error) {
        const char *error_msg = lua_tostring(L, -1);
        lua_pop(L, 1);
        room->output(error_msg);
    }
}

#include <QMessageBox>

static void Error(lua_State *L)
{
    const char *error_string = lua_tostring(L, -1);
    lua_pop(L, 1);
    QMessageBox::warning(NULL, "Lua script error!", error_string);
}

bool LuaProhibitSkill::isProhibited(const Player *from, const Player *to, const Card *card, const QList<const Player *> &others) const
{
    if (is_prohibited == 0)
        return false;

    lua_State *L = Sanguosha->getLuaState();

    lua_rawgeti(L, LUA_REGISTRYINDEX, is_prohibited);

    SWIG_NewPointerObj(L, this, SWIGTYPE_p_LuaProhibitSkill, 0);
    SWIG_NewPointerObj(L, from, SWIGTYPE_p_Player, 0);
    SWIG_NewPointerObj(L, to, SWIGTYPE_p_Player, 0);
    SWIG_NewPointerObj(L, card, SWIGTYPE_p_Card, 0);

    lua_createtable(L, others.length(), 0);
    for (int i = 0; i < others.length(); i++) {
        const Player *player = others[i];
        SWIG_NewPointerObj(L, player, SWIGTYPE_p_Player, 0);
        lua_rawseti(L, -2, i + 1);
    }

    int error = lua_pcall(L, 5, 1, 0);
    if (error) {
        Error(L);
        return false;
    }

    bool result = lua_toboolean(L, -1);
    lua_pop(L, 1);
    return result;
}

bool LuaFixCardSkill::isCardFixed(const Player *from, const Player *to, const QString &flags, Card::HandlingMethod method) const
{
    if (is_cardfixed == 0)
        return false;

    lua_State *L = Sanguosha->getLuaState();

    lua_rawgeti(L, LUA_REGISTRYINDEX, is_cardfixed);

    SWIG_NewPointerObj(L, this, SWIGTYPE_p_LuaFixCardSkill, 0);
    SWIG_NewPointerObj(L, from, SWIGTYPE_p_Player, 0);
    SWIG_NewPointerObj(L, to, SWIGTYPE_p_Player, 0);

    lua_pushstring(L, flags.toLatin1());

    int e = static_cast<int>(method);
    lua_pushinteger(L, e);

    int error = lua_pcall(L, 5, 1, 0);
    if (error) {
        Error(L);
        return false;
    }

    bool result = lua_toboolean(L, -1);
    lua_pop(L, 1);
    return result;
}

bool LuaViewHasSkill::ViewHas(const Player *player, const QString &skill_name, const QString &flag) const
{
    if (is_viewhas == 0)
        return false;

    lua_State *L;
    if (Sanguosha->currentRoom())
        L = Sanguosha->currentRoom()->getLuaState();
    else
        return false;

    lua_rawgeti(L, LUA_REGISTRYINDEX, is_viewhas);
    SWIG_NewPointerObj(L, this, SWIGTYPE_p_LuaViewHasSkill, 0);
    SWIG_NewPointerObj(L, player, SWIGTYPE_p_Player, 0);
    lua_pushstring(L, skill_name.toLatin1());
    lua_pushstring(L, flag.toLatin1());

    int error = lua_pcall(L, 4, 1, 0);
    if (error) {
        Error(L);
        return false;
    } else {
        bool result = lua_toboolean(L, -1);
        lua_pop(L, 1);
        return result;
    }
}

int LuaDistanceSkill::getCorrect(const Player *from, const Player *to) const
{
    if (correct_func == 0)
        return 0;

    lua_State *L = Sanguosha->getLuaState();

    lua_rawgeti(L, LUA_REGISTRYINDEX, correct_func);

    SWIG_NewPointerObj(L, this, SWIGTYPE_p_LuaDistanceSkill, 0);
    SWIG_NewPointerObj(L, from, SWIGTYPE_p_Player, 0);
    SWIG_NewPointerObj(L, to, SWIGTYPE_p_Player, 0);

    int error = lua_pcall(L, 3, 1, 0);
    if (error) {
        Error(L);
        return 0;
    }

    int correct = lua_tointeger(L, -1);
    lua_pop(L, 1);

    return correct;
}

int LuaMaxCardsSkill::getExtra(const Player *target) const
{
    if (extra_func == 0)
        return MaxCardsSkill::getExtra(target);

    lua_State *L = Sanguosha->getLuaState();

    lua_rawgeti(L, LUA_REGISTRYINDEX, extra_func);

    SWIG_NewPointerObj(L, this, SWIGTYPE_p_LuaMaxCardsSkill, 0);
    SWIG_NewPointerObj(L, target, SWIGTYPE_p_Player, 0);

    int error = lua_pcall(L, 2, 1, 0);
    if (error) {
        Error(L);
        return MaxCardsSkill::getExtra(target);
    }

    int extra = lua_tointeger(L, -1);
    lua_pop(L, 1);

    return extra;
}

int LuaMaxCardsSkill::getFixed(const Player *target) const
{
    if (fixed_func == 0)
        return MaxCardsSkill::getFixed(target);

    lua_State *L = Sanguosha->getLuaState();

    lua_rawgeti(L, LUA_REGISTRYINDEX, fixed_func);

    SWIG_NewPointerObj(L, this, SWIGTYPE_p_LuaMaxCardsSkill, 0);
    SWIG_NewPointerObj(L, target, SWIGTYPE_p_Player, 0);

    int error = lua_pcall(L, 2, 1, 0);
    if (error) {
        Error(L);
        return MaxCardsSkill::getFixed(target);
    }

    int extra = lua_tointeger(L, -1);
    lua_pop(L, 1);

    return extra;
}

int LuaTargetModSkill::getResidueNum(const Player *from, const Card *card, const Player *to) const
{
    if (residue_func == 0)
        return 0;

    lua_State *L = Sanguosha->getLuaState();

    lua_rawgeti(L, LUA_REGISTRYINDEX, residue_func);

    SWIG_NewPointerObj(L, this, SWIGTYPE_p_LuaTargetModSkill, 0);
    SWIG_NewPointerObj(L, from, SWIGTYPE_p_Player, 0);
    SWIG_NewPointerObj(L, card, SWIGTYPE_p_Card, 0);
    SWIG_NewPointerObj(L, to, SWIGTYPE_p_Player, 0);

    int error = lua_pcall(L, 4, 1, 0);
    if (error) {
        Error(L);
        return 0;
    }

    int residue = lua_tointeger(L, -1);
    lua_pop(L, 1);

    return residue;
}

int LuaTargetModSkill::getDistanceLimit(const Player *from, const Card *card, const Player *to) const
{
    if (distance_limit_func == 0)
        return 0;

    lua_State *L = Sanguosha->getLuaState();

    lua_rawgeti(L, LUA_REGISTRYINDEX, distance_limit_func);

    SWIG_NewPointerObj(L, this, SWIGTYPE_p_LuaTargetModSkill, 0);
    SWIG_NewPointerObj(L, from, SWIGTYPE_p_Player, 0);
    SWIG_NewPointerObj(L, card, SWIGTYPE_p_Card, 0);
    SWIG_NewPointerObj(L, to, SWIGTYPE_p_Player, 0);

    int error = lua_pcall(L, 4, 1, 0);
    if (error) {
        Error(L);
        return 0;
    }

    int distance_limit = lua_tointeger(L, -1);
    lua_pop(L, 1);

    return distance_limit;
}

int LuaTargetModSkill::getExtraTargetNum(const Player *from, const Card *card) const
{
    if (extra_target_func == 0)
        return 0;

    lua_State *L = Sanguosha->getLuaState();

    lua_rawgeti(L, LUA_REGISTRYINDEX, extra_target_func);

    SWIG_NewPointerObj(L, this, SWIGTYPE_p_LuaTargetModSkill, 0);
    SWIG_NewPointerObj(L, from, SWIGTYPE_p_Player, 0);
    SWIG_NewPointerObj(L, card, SWIGTYPE_p_Card, 0);

    int error = lua_pcall(L, 3, 1, 0);
    if (error) {
        Error(L);
        return 0;
    }

    int extra_target_func = lua_tointeger(L, -1);
    lua_pop(L, 1);

    return extra_target_func;
}

bool LuaFilterSkill::viewFilter(const Card *to_select, ServerPlayer *player) const
{
    if (view_filter == 0)
        return false;

    lua_State *L = player->getRoom()->getLuaState();

    lua_rawgeti(L, LUA_REGISTRYINDEX, view_filter);

    SWIG_NewPointerObj(L, this, SWIGTYPE_p_LuaFilterSkill, 0);
    SWIG_NewPointerObj(L, to_select, SWIGTYPE_p_Card, 0);
    SWIG_NewPointerObj(L, player, SWIGTYPE_p_ServerPlayer, 0);

    int error = lua_pcall(L, 3, 1, 0);
    if (error) {
        Error(L);
        return false;
    }

    bool result = lua_toboolean(L, -1);
    lua_pop(L, 1);
    return result;
}

int LuaAttackRangeSkill::getExtra(const Player *target, bool include_weapon) const
{
    if (extra_func == 0)
        return AttackRangeSkill::getExtra(target, include_weapon);

    lua_State *l = Sanguosha->getLuaState();

    lua_rawgeti(l, LUA_REGISTRYINDEX, extra_func);

    SWIG_NewPointerObj(l, this, SWIGTYPE_p_LuaAttackRangeSkill, 0);
    SWIG_NewPointerObj(l, target, SWIGTYPE_p_Player, 0);
    lua_pushboolean(l, include_weapon);

    int error = lua_pcall(l, 3, 1, 0);
    if (error) {
        Error(l);
        return AttackRangeSkill::getExtra(target, include_weapon);
    }

    int extra = lua_tointeger(l, -1);
    lua_pop(l, 1);

    return extra;
}

int LuaAttackRangeSkill::getFixed(const Player *target, bool include_weapon) const
{
    if (fixed_func == 0)
        return AttackRangeSkill::getFixed(target, include_weapon);

    lua_State *l = Sanguosha->getLuaState();

    lua_rawgeti(l, LUA_REGISTRYINDEX, fixed_func);

    SWIG_NewPointerObj(l, this, SWIGTYPE_p_LuaAttackRangeSkill, 0);
    SWIG_NewPointerObj(l, target, SWIGTYPE_p_Player, 0);
    lua_pushboolean(l, include_weapon);

    int error = lua_pcall(l, 3, 1, 0);
    if (error) {
        Error(l);
        return AttackRangeSkill::getFixed(target, include_weapon);
    }

    int extra = lua_tointeger(l, -1);
    lua_pop(l, 1);

    return extra;
}

const Card *LuaFilterSkill::viewAs(const Card *originalCard) const
{
    if (view_as == 0)
        return NULL;

    lua_State *L = Sanguosha->getLuaState();

    lua_rawgeti(L, LUA_REGISTRYINDEX, view_as);

    SWIG_NewPointerObj(L, this, SWIGTYPE_p_LuaFilterSkill, 0);
    SWIG_NewPointerObj(L, originalCard, SWIGTYPE_p_Card, 0);

    int error = lua_pcall(L, 2, 1, 0);
    if (error) {
        Error(L);
        return NULL;
    }

    void *card_ptr;
    int result = SWIG_ConvertPtr(L, -1, &card_ptr, SWIGTYPE_p_Card, 0);
    lua_pop(L, 1);
    if (SWIG_IsOK(result)) {
        const Card *card = static_cast<const Card *>(card_ptr);
        return card;
    } else
        return NULL;
}

// ----------------------

void LuaViewAsSkill::pushSelf(lua_State *L) const
{
    LuaViewAsSkill *self = const_cast<LuaViewAsSkill *>(this);
    SWIG_NewPointerObj(L, self, SWIGTYPE_p_LuaViewAsSkill, 0);
}

bool LuaViewAsSkill::viewFilter(const QList<const Card *> &selected, const Card *to_select) const
{
    if (view_filter == 0)
        return false;

    lua_State *L = Sanguosha->getLuaState();

    lua_rawgeti(L, LUA_REGISTRYINDEX, view_filter);

    pushSelf(L);

    lua_createtable(L, selected.length(), 0);
    for (int i = 0; i < selected.length(); ++i) {
        const Card *card = selected[i];
        SWIG_NewPointerObj(L, card, SWIGTYPE_p_Card, 0);
        lua_rawseti(L, -2, i + 1);
    }

    const Card *card = to_select;
    SWIG_NewPointerObj(L, card, SWIGTYPE_p_Card, 0);

    int error = lua_pcall(L, 3, 1, 0);
    if (error) {
        Error(L);
        return false;
    } else {
        bool result = lua_toboolean(L, -1);
        lua_pop(L, 1);
        return result;
    }
}

const Card *LuaViewAsSkill::viewAs(const QList<const Card *> &cards) const
{
    if (view_as == 0)
        return NULL;

    lua_State *L = Sanguosha->getLuaState();

    lua_rawgeti(L, LUA_REGISTRYINDEX, view_as);

    pushSelf(L);

    lua_createtable(L, cards.length(), 0);
    for (int i = 0; i < cards.length(); ++i) {
        const Card *card = cards[i];
        SWIG_NewPointerObj(L, card, SWIGTYPE_p_Card, 0);
        lua_rawseti(L, -2, i + 1);
    }

    int error = lua_pcall(L, 2, 1, 0);
    if (error) {
        Error(L);
        return NULL;
    }

    void *card_ptr;
    int result = SWIG_ConvertPtr(L, -1, &card_ptr, SWIGTYPE_p_Card, 0);
    lua_pop(L, 1);
    if (SWIG_IsOK(result)) {
        const Card *card = static_cast<const Card *>(card_ptr);
        return card;
    } else
        return NULL;
}

bool LuaViewAsSkill::isEnabledAtPlay(const Player *player) const
{
    if (enabled_at_play == 0)
        return ViewAsSkill::isEnabledAtPlay(player);

    lua_State *L = Sanguosha->getLuaState();

    // the callback
    lua_rawgeti(L, LUA_REGISTRYINDEX, enabled_at_play);

    pushSelf(L);

    SWIG_NewPointerObj(L, player, SWIGTYPE_p_Player, 0);

    int error = lua_pcall(L, 2, 1, 0);
    if (error) {
        Error(L);
        return false;
    } else {
        bool result = lua_toboolean(L, -1);
        lua_pop(L, 1);
        return result;
    }
}

bool LuaViewAsSkill::isEnabledAtResponse(const Player *player, const QString &pattern) const
{
    if (enabled_at_response == 0)
        return ViewAsSkill::isEnabledAtResponse(player, pattern);

    lua_State *L = Sanguosha->getLuaState();

    // the callback
    lua_rawgeti(L, LUA_REGISTRYINDEX, enabled_at_response);

    pushSelf(L);

    SWIG_NewPointerObj(L, player, SWIGTYPE_p_Player, 0);

    lua_pushstring(L, pattern.toLatin1());

    int error = lua_pcall(L, 3, 1, 0);
    if (error) {
        Error(L);
        return false;
    } else {
        bool result = lua_toboolean(L, -1);
        lua_pop(L, 1);
        return result;
    }
}

bool LuaViewAsSkill::isEnabledAtNullification(const ServerPlayer *player) const
{
    if (enabled_at_nullification == 0)
        return ViewAsSkill::isEnabledAtNullification(player);

    lua_State *L = Sanguosha->getLuaState();

    // the callback
    lua_rawgeti(L, LUA_REGISTRYINDEX, enabled_at_nullification);

    pushSelf(L);

    SWIG_NewPointerObj(L, player, SWIGTYPE_p_ServerPlayer, 0);

    int error = lua_pcall(L, 2, 1, 0);
    if (error) {
        Error(L);
        return false;
    } else {
        bool result = lua_toboolean(L, -1);
        lua_pop(L, 1);
        return result;
    }
}

QString LuaViewAsSkill::getExpandPile() const
{
    if (in_pile == 0)
        return ViewAsSkill::getExpandPile();

    lua_State *L = Sanguosha->getLuaState();

    // the callback
    lua_rawgeti(L, LUA_REGISTRYINDEX, in_pile);

    pushSelf(L);

    int error = lua_pcall(L, 1, 1, 0);
    if (error) {
        Error(L);
        return false;
    } else {
        const char *result = lua_tostring(L, -1);
        lua_pop(L, 1);
        return QString(QLatin1String(result));
    }
}

// ---------------------

void LuaSkillCard::pushSelf(lua_State *L) const
{
    LuaSkillCard *self = const_cast<LuaSkillCard *>(this);
    SWIG_NewPointerObj(L, self, SWIGTYPE_p_LuaSkillCard, 0);
}

bool LuaSkillCard::targetFilter(const QList<const Player *> &targets, const Player *to_select, const Player *self,
    int &maxVotes) const
{
    if (filter == 0) {
        return SkillCard::targetFilter(targets, to_select, self, maxVotes);
    }
    lua_State *L = Sanguosha->getLuaState();

    // the callback
    lua_rawgeti(L, LUA_REGISTRYINDEX, filter);

    pushSelf(L);

    lua_createtable(L, targets.length(), 0);
    for (int i = 0; i < targets.length(); ++i) {
        SWIG_NewPointerObj(L, targets.at(i), SWIGTYPE_p_Player, 0);
        lua_rawseti(L, -2, i + 1);
    }

    SWIG_NewPointerObj(L, to_select, SWIGTYPE_p_Player, 0);
    SWIG_NewPointerObj(L, self, SWIGTYPE_p_Player, 0);

    int error = lua_pcall(L, 4, 2, 0);
    if (error) {
        Error(L);
        return false;
    } else {
        if (lua_isnumber(L, -1) && lua_isboolean(L, -2)) {
            int vote = lua_tointeger(L, -1);
            maxVotes = vote;
            bool result = lua_toboolean(L, -2);
            lua_pop(L, 2);
            return result;
        }
    }
    return false;
}

bool LuaSkillCard::targetsFeasible(const QList<const Player *> &targets, const Player *self) const
{
    if (feasible == 0)
        return SkillCard::targetsFeasible(targets, self);

    lua_State *L = Sanguosha->getLuaState();

    // the callback
    lua_rawgeti(L, LUA_REGISTRYINDEX, feasible);

    pushSelf(L);

    lua_createtable(L, targets.length(), 0);
    for (int i = 0; i < targets.length(); ++i) {
        SWIG_NewPointerObj(L, targets.at(i), SWIGTYPE_p_Player, 0);
        lua_rawseti(L, -2, i + 1);
    }

    SWIG_NewPointerObj(L, self, SWIGTYPE_p_Player, 0);

    int error = lua_pcall(L, 3, 1, 0);
    if (error) {
        Error(L);
        return false;
    } else {
        bool result = lua_toboolean(L, -1);
        lua_pop(L, 1);
        return result;
    }
}

void LuaSkillCard::onUse(Room *room, const CardUseStruct &card_use) const
{
    if (about_to_use == 0)
        return SkillCard::onUse(room, card_use);
    try {
        lua_State *L = Sanguosha->getLuaState();

        // the callback
        lua_rawgeti(L, LUA_REGISTRYINDEX, about_to_use);

        pushSelf(L);

        SWIG_NewPointerObj(L, room, SWIGTYPE_p_Room, 0);
        SWIG_NewPointerObj(L, &card_use, SWIGTYPE_p_CardUseStruct, 0);

        int error = lua_pcall(L, 3, 0, 0);
        if (error) {
            const char *error_msg = lua_tostring(L, -1);
            lua_pop(L, 1);
            room->output(error_msg);
        }
    }
    catch (TriggerEvent e) {
        if (e == TurnBroken || e == StageChange) {
            QVariant data = QVariant::fromValue(card_use);
            onTurnBroken("about_to_use", room, data);
        }
        throw e;
    }
}

void LuaSkillCard::use(Room *room, ServerPlayer *source, QList<ServerPlayer *> &targets) const
{
    if (on_use == 0)
        return SkillCard::use(room, source, targets);
    try {
        lua_State *L = Sanguosha->getLuaState();

        // the callback
        lua_rawgeti(L, LUA_REGISTRYINDEX, on_use);

        pushSelf(L);

        SWIG_NewPointerObj(L, room, SWIGTYPE_p_Room, 0);
        SWIG_NewPointerObj(L, source, SWIGTYPE_p_ServerPlayer, 0);

        lua_createtable(L, targets.length(), 0);
        for (int i = 0; i < targets.length(); ++i) {
            SWIG_NewPointerObj(L, targets.at(i), SWIGTYPE_p_ServerPlayer, 0);
            lua_rawseti(L, -2, i + 1);
        }

        int error = lua_pcall(L, 4, 0, 0);
        if (error) {
            const char *error_msg = lua_tostring(L, -1);
            lua_pop(L, 1);
            room->output(error_msg);
        }
    }
    catch (TriggerEvent e) {
        if (e == TurnBroken || e == StageChange) {
            CardUseStruct card_use(this, source, targets);
            QVariant data = QVariant::fromValue(card_use);
            onTurnBroken("on_use", room, data);
        }
        throw e;
    }
}

void LuaSkillCard::onEffect(const CardEffectStruct &effect) const
{
    if (on_effect == 0)
        return SkillCard::onEffect(effect);

    try {
        lua_State *L = Sanguosha->getLuaState();

        // the callback
        lua_rawgeti(L, LUA_REGISTRYINDEX, on_effect);

        pushSelf(L);

        SWIG_NewPointerObj(L, &effect, SWIGTYPE_p_CardEffectStruct, 0);

        int error = lua_pcall(L, 2, 0, 0);
        if (error) {
            const char *error_msg = lua_tostring(L, -1);
            lua_pop(L, 1);
            Room *room = effect.to->getRoom();
            room->output(error_msg);
        }
    }
    catch (TriggerEvent e) {
        if (e == TurnBroken || e == StageChange) {
            QVariant data = QVariant::fromValue(effect);
            onTurnBroken("on_effect", effect.from->getRoom(), data);
        }
        throw e;
    }
}

const Card *LuaSkillCard::validate(CardUseStruct &cardUse) const
{
    if (on_validate == 0)
        return SkillCard::validate(cardUse);
    try {
        lua_State *L = Sanguosha->getLuaState();

        // the callback
        lua_rawgeti(L, LUA_REGISTRYINDEX, on_validate);

        pushSelf(L);

        SWIG_NewPointerObj(L, &cardUse, SWIGTYPE_p_CardUseStruct, 0);

        int error = lua_pcall(L, 2, 1, 0);
        if (error) {
            const char *error_msg = lua_tostring(L, -1);
            lua_pop(L, 1);
            cardUse.from->getRoom()->output(error_msg);
            return SkillCard::validate(cardUse);
        }

        void *card_ptr;
        int result = SWIG_ConvertPtr(L, -1, &card_ptr, SWIGTYPE_p_Card, 0);
        lua_pop(L, 1);
        if (SWIG_IsOK(result)) {
            const Card *card = static_cast<const Card *>(card_ptr);
            return card;
        } else
            return SkillCard::validate(cardUse);
    }
    catch (TriggerEvent e) {
        if (e == TurnBroken || e == StageChange) {
            QVariant data = QVariant::fromValue(cardUse);
            onTurnBroken("on_validate", cardUse.from->getRoom(), data);
        }
        throw e;
    }
}

const Card *LuaSkillCard::validateInResponse(ServerPlayer *user) const
{
    if (on_validate_in_response == 0)
        return SkillCard::validateInResponse(user);
    try {
        lua_State *L = Sanguosha->getLuaState();

        // the callback
        lua_rawgeti(L, LUA_REGISTRYINDEX, on_validate_in_response);

        pushSelf(L);

        SWIG_NewPointerObj(L, user, SWIGTYPE_p_ServerPlayer, 0);

        int error = lua_pcall(L, 2, 1, 0);
        if (error) {
            const char *error_msg = lua_tostring(L, -1);
            lua_pop(L, 1);
            user->getRoom()->output(error_msg);
            return SkillCard::validateInResponse(user);
        }

        void *card_ptr;
        int result = SWIG_ConvertPtr(L, -1, &card_ptr, SWIGTYPE_p_Card, 0);
        lua_pop(L, 1);
        if (SWIG_IsOK(result)) {
            const Card *card = static_cast<const Card *>(card_ptr);
            return card;
        } else
            return SkillCard::validateInResponse(user);

    }
    catch (TriggerEvent e) {
        if (e == TurnBroken || e == StageChange) {
            QVariant data = QVariant::fromValue(user);
            onTurnBroken("on_validate_in_response", user->getRoom(), data);
        }
        throw e;
    }
}

void LuaSkillCard::extraCost(Room *room, const CardUseStruct &card_use) const
{
    if (extra_cost == 0)
        return SkillCard::extraCost(room, card_use);

    try {
        lua_State *L = Sanguosha->getLuaState();

        // the callback
        lua_rawgeti(L, LUA_REGISTRYINDEX, extra_cost);

        pushSelf(L);

        SWIG_NewPointerObj(L, room, SWIGTYPE_p_Room, 0);
        SWIG_NewPointerObj(L, &card_use, SWIGTYPE_p_CardUseStruct, 0);

        int error = lua_pcall(L, 3, 0, 0);
        if (error) {
            const char *error_msg = lua_tostring(L, -1);
            lua_pop(L, 1);
            room->output(error_msg);
        }
    }
    catch (TriggerEvent e) {
        if (e == TurnBroken || e == StageChange) {
            QVariant data = QVariant::fromValue(card_use);
            onTurnBroken("extra_cost", room, data);
        }
        throw e;
    }
}

void LuaSkillCard::onTurnBroken(const char *function_name, Room *room, QVariant &value) const
{
    if (on_turn_broken == 0)
        return;
    lua_State *L = room->getLuaState();

    lua_rawgeti(L, LUA_REGISTRYINDEX, on_turn_broken);

    pushSelf(L);

    lua_pushstring(L, function_name);

    SWIG_NewPointerObj(L, room, SWIGTYPE_p_Room, 0);


    SWIG_NewPointerObj(L, &value, SWIGTYPE_p_QVariant, 0);

    int error = lua_pcall(L, 4, 0, 0);
    if (error) {
        const char *error_msg = lua_tostring(L, -1);
        lua_pop(L, 1);
        room->output(error_msg);
    }
}

// ---------------------

void LuaBasicCard::pushSelf(lua_State *L) const
{
    LuaBasicCard *self = const_cast<LuaBasicCard *>(this);
    SWIG_NewPointerObj(L, self, SWIGTYPE_p_LuaBasicCard, 0);
}

bool LuaBasicCard::targetFilter(const QList<const Player *> &targets, const Player *to_select, const Player *self) const
{
    if (filter == 0)
        return BasicCard::targetFilter(targets, to_select, self);

    lua_State *L = Sanguosha->getLuaState();

    // the callback
    lua_rawgeti(L, LUA_REGISTRYINDEX, filter);

    pushSelf(L);

    lua_createtable(L, targets.length(), 0);
    for (int i = 0; i < targets.length(); ++i) {
        SWIG_NewPointerObj(L, targets.at(i), SWIGTYPE_p_Player, 0);
        lua_rawseti(L, -2, i + 1);
    }

    SWIG_NewPointerObj(L, to_select, SWIGTYPE_p_Player, 0);
    SWIG_NewPointerObj(L, self, SWIGTYPE_p_Player, 0);

    int error = lua_pcall(L, 4, 1, 0);
    if (error) {
        Error(L);
        return false;
    } else {
        bool result = lua_toboolean(L, -1);
        lua_pop(L, 1);
        return result;
    }
}

bool LuaBasicCard::targetsFeasible(const QList<const Player *> &targets, const Player *self) const
{
    if (feasible == 0)
        return BasicCard::targetsFeasible(targets, self);

    lua_State *L = Sanguosha->getLuaState();

    // the callback
    lua_rawgeti(L, LUA_REGISTRYINDEX, feasible);

    pushSelf(L);

    lua_createtable(L, targets.length(), 0);
    for (int i = 0; i < targets.length(); ++i) {
        SWIG_NewPointerObj(L, targets.at(i), SWIGTYPE_p_Player, 0);
        lua_rawseti(L, -2, i + 1);
    }

    SWIG_NewPointerObj(L, self, SWIGTYPE_p_Player, 0);

    int error = lua_pcall(L, 3, 1, 0);
    if (error) {
        Error(L);
        return false;
    } else {
        bool result = lua_toboolean(L, -1);
        lua_pop(L, 1);
        return result;
    }
}

void LuaBasicCard::onUse(Room *room, const CardUseStruct &card_use) const
{
    if (about_to_use == 0)
        return BasicCard::onUse(room, card_use);

    lua_State *L = Sanguosha->getLuaState();

    // the callback
    lua_rawgeti(L, LUA_REGISTRYINDEX, about_to_use);

    pushSelf(L);

    SWIG_NewPointerObj(L, room, SWIGTYPE_p_Room, 0);
    SWIG_NewPointerObj(L, &card_use, SWIGTYPE_p_CardUseStruct, 0);

    int error = lua_pcall(L, 3, 0, 0);
    if (error) {
        const char *error_msg = lua_tostring(L, -1);
        lua_pop(L, 1);
        room->output(error_msg);
    }
}

void LuaBasicCard::use(Room *room, ServerPlayer *source, QList<ServerPlayer *> &targets) const
{
    if (on_use == 0)
        return BasicCard::use(room, source, targets);

    lua_State *L = Sanguosha->getLuaState();

    // the callback
    lua_rawgeti(L, LUA_REGISTRYINDEX, on_use);

    pushSelf(L);

    SWIG_NewPointerObj(L, room, SWIGTYPE_p_Room, 0);
    SWIG_NewPointerObj(L, source, SWIGTYPE_p_ServerPlayer, 0);

    lua_createtable(L, targets.length(), 0);
    for (int i = 0; i < targets.length(); ++i) {
        SWIG_NewPointerObj(L, targets.at(i), SWIGTYPE_p_ServerPlayer, 0);
        lua_rawseti(L, -2, i + 1);
    }

    int error = lua_pcall(L, 4, 0, 0);
    if (error) {
        const char *error_msg = lua_tostring(L, -1);
        lua_pop(L, 1);
        room->output(error_msg);
    }
}

void LuaBasicCard::onEffect(const CardEffectStruct &effect) const
{
    if (on_effect == 0)
        return BasicCard::onEffect(effect);

    lua_State *L = Sanguosha->getLuaState();

    // the callback
    lua_rawgeti(L, LUA_REGISTRYINDEX, on_effect);

    pushSelf(L);

    SWIG_NewPointerObj(L, &effect, SWIGTYPE_p_CardEffectStruct, 0);

    int error = lua_pcall(L, 2, 0, 0);
    if (error) {
        const char *error_msg = lua_tostring(L, -1);
        lua_pop(L, 1);
        Room *room = effect.to->getRoom();
        room->output(error_msg);
    }
}

bool LuaBasicCard::isAvailable(const Player *player) const
{
    if (available == 0)
        return BasicCard::isAvailable(player);

    lua_State *L = Sanguosha->getLuaState();

    // the callback
    lua_rawgeti(L, LUA_REGISTRYINDEX, available);

    pushSelf(L);

    SWIG_NewPointerObj(L, player, SWIGTYPE_p_Player, 0);

    int error = lua_pcall(L, 2, 1, 0);
    if (error) {
        Error(L);
        return false;
    } else {
        bool result = lua_toboolean(L, -1);
        lua_pop(L, 1);
        return result;
    }
}

// ---------------------

void LuaTrickCard::pushSelf(lua_State *L) const
{
    LuaTrickCard *self = const_cast<LuaTrickCard *>(this);
    SWIG_NewPointerObj(L, self, SWIGTYPE_p_LuaTrickCard, 0);
}

bool LuaTrickCard::targetFilter(const QList<const Player *> &targets, const Player *to_select, const Player *self) const
{
    if (filter == 0)
        return TrickCard::targetFilter(targets, to_select, self);

    lua_State *L = Sanguosha->getLuaState();

    // the callback
    lua_rawgeti(L, LUA_REGISTRYINDEX, filter);

    pushSelf(L);

    lua_createtable(L, targets.length(), 0);
    for (int i = 0; i < targets.length(); ++i) {
        SWIG_NewPointerObj(L, targets.at(i), SWIGTYPE_p_Player, 0);
        lua_rawseti(L, -2, i + 1);
    }

    SWIG_NewPointerObj(L, to_select, SWIGTYPE_p_Player, 0);
    SWIG_NewPointerObj(L, self, SWIGTYPE_p_Player, 0);

    int error = lua_pcall(L, 4, 1, 0);
    if (error) {
        Error(L);
        return false;
    } else {
        bool result = lua_toboolean(L, -1);
        lua_pop(L, 1);
        return result;
    }
}

bool LuaTrickCard::targetsFeasible(const QList<const Player *> &targets, const Player *self) const
{
    if (feasible == 0)
        return TrickCard::targetsFeasible(targets, self);

    lua_State *L = Sanguosha->getLuaState();

    // the callback
    lua_rawgeti(L, LUA_REGISTRYINDEX, feasible);

    pushSelf(L);

    lua_createtable(L, targets.length(), 0);
    for (int i = 0; i < targets.length(); ++i) {
        SWIG_NewPointerObj(L, targets.at(i), SWIGTYPE_p_Player, 0);
        lua_rawseti(L, -2, i + 1);
    }

    SWIG_NewPointerObj(L, self, SWIGTYPE_p_Player, 0);

    int error = lua_pcall(L, 3, 1, 0);
    if (error) {
        Error(L);
        return false;
    } else {
        bool result = lua_toboolean(L, -1);
        lua_pop(L, 1);
        return result;
    }
}

void LuaTrickCard::onNullified(ServerPlayer *target) const
{
    if (on_nullified == 0)
        return TrickCard::onNullified(target);

    lua_State *L = Sanguosha->getLuaState();

    // the callback
    lua_rawgeti(L, LUA_REGISTRYINDEX, on_nullified);

    pushSelf(L);

    SWIG_NewPointerObj(L, target, SWIGTYPE_p_ServerPlayer, 0);

    int error = lua_pcall(L, 2, 0, 0);
    if (error) {
        const char *error_msg = lua_tostring(L, -1);
        lua_pop(L, 1);
        target->getRoom()->output(error_msg);
    }
}

bool LuaTrickCard::isCancelable(const CardEffectStruct &effect) const
{
    if (is_cancelable == 0)
        return TrickCard::isCancelable(effect);

    lua_State *L = Sanguosha->getLuaState();

    // the callback
    lua_rawgeti(L, LUA_REGISTRYINDEX, is_cancelable);

    pushSelf(L);

    SWIG_NewPointerObj(L, &effect, SWIGTYPE_p_CardEffectStruct, 0);

    int error = lua_pcall(L, 2, 1, 0);
    if (error) {
        Error(L);
        return false;
    } else {
        bool result = lua_toboolean(L, -1);
        lua_pop(L, 1);
        return result;
    }
}

void LuaTrickCard::onUse(Room *room, const CardUseStruct &card_use) const
{
    if (about_to_use == 0)
        return TrickCard::onUse(room, card_use);

    lua_State *L = Sanguosha->getLuaState();

    // the callback
    lua_rawgeti(L, LUA_REGISTRYINDEX, about_to_use);

    pushSelf(L);

    SWIG_NewPointerObj(L, room, SWIGTYPE_p_Room, 0);
    SWIG_NewPointerObj(L, &card_use, SWIGTYPE_p_CardUseStruct, 0);

    int error = lua_pcall(L, 3, 0, 0);
    if (error) {
        const char *error_msg = lua_tostring(L, -1);
        lua_pop(L, 1);
        room->output(error_msg);
    }
}

void LuaTrickCard::use(Room *room, ServerPlayer *source, QList<ServerPlayer *> &targets) const
{
    if (on_use == 0)
        return TrickCard::use(room, source, targets);

    lua_State *L = Sanguosha->getLuaState();

    // the callback
    lua_rawgeti(L, LUA_REGISTRYINDEX, on_use);

    pushSelf(L);

    SWIG_NewPointerObj(L, room, SWIGTYPE_p_Room, 0);
    SWIG_NewPointerObj(L, source, SWIGTYPE_p_ServerPlayer, 0);

    lua_createtable(L, targets.length(), 0);
    for (int i = 0; i < targets.length(); ++i) {
        SWIG_NewPointerObj(L, targets.at(i), SWIGTYPE_p_ServerPlayer, 0);
        lua_rawseti(L, -2, i + 1);
    }

    int error = lua_pcall(L, 4, 0, 0);
    if (error) {
        const char *error_msg = lua_tostring(L, -1);
        lua_pop(L, 1);
        room->output(error_msg);
    }
}

void LuaTrickCard::onEffect(const CardEffectStruct &effect) const
{
    if (on_effect == 0)
        return TrickCard::onEffect(effect);

    lua_State *L = Sanguosha->getLuaState();

    // the callback
    lua_rawgeti(L, LUA_REGISTRYINDEX, on_effect);

    pushSelf(L);

    SWIG_NewPointerObj(L, &effect, SWIGTYPE_p_CardEffectStruct, 0);

    int error = lua_pcall(L, 2, 0, 0);
    if (error) {
        const char *error_msg = lua_tostring(L, -1);
        lua_pop(L, 1);
        Room *room = effect.to->getRoom();
        room->output(error_msg);
    }
}

bool LuaTrickCard::isAvailable(const Player *player) const
{
    if (available == 0)
        return TrickCard::isAvailable(player);

    lua_State *L = Sanguosha->getLuaState();

    // the callback
    lua_rawgeti(L, LUA_REGISTRYINDEX, available);

    pushSelf(L);

    SWIG_NewPointerObj(L, player, SWIGTYPE_p_Player, 0);

    int error = lua_pcall(L, 2, 1, 0);
    if (error) {
        Error(L);
        return false;
    } else {
        bool result = lua_toboolean(L, -1);
        lua_pop(L, 1);
        return result;
    }
}

void LuaWeapon::pushSelf(lua_State *L) const
{
    LuaWeapon *self = const_cast<LuaWeapon *>(this);
    SWIG_NewPointerObj(L, self, SWIGTYPE_p_LuaWeapon, 0);
}

void LuaWeapon::onInstall(ServerPlayer *player) const
{
    if (on_install == 0)
        return Weapon::onInstall(player);

    lua_State *L = Sanguosha->getLuaState();

    // the callback
    lua_rawgeti(L, LUA_REGISTRYINDEX, on_install);

    pushSelf(L);

    SWIG_NewPointerObj(L, player, SWIGTYPE_p_ServerPlayer, 0);

    int error = lua_pcall(L, 2, 0, 0);
    if (error) {
        const char *error_msg = lua_tostring(L, -1);
        lua_pop(L, 1);
        Room *room = player->getRoom();
        room->output(error_msg);
    }
}

void LuaWeapon::onUninstall(ServerPlayer *player) const
{
    if (on_uninstall == 0)
        return Weapon::onUninstall(player);

    lua_State *L = Sanguosha->getLuaState();

    // the callback
    lua_rawgeti(L, LUA_REGISTRYINDEX, on_uninstall);

    pushSelf(L);

    SWIG_NewPointerObj(L, player, SWIGTYPE_p_ServerPlayer, 0);

    int error = lua_pcall(L, 2, 0, 0);
    if (error) {
        const char *error_msg = lua_tostring(L, -1);
        lua_pop(L, 1);
        Room *room = player->getRoom();
        room->output(error_msg);
    }
}

void LuaArmor::pushSelf(lua_State *L) const
{
    LuaArmor *self = const_cast<LuaArmor *>(this);
    SWIG_NewPointerObj(L, self, SWIGTYPE_p_LuaArmor, 0);
}

void LuaArmor::onInstall(ServerPlayer *player) const
{
    if (on_install == 0)
        return Armor::onInstall(player);

    lua_State *L = Sanguosha->getLuaState();

    // the callback
    lua_rawgeti(L, LUA_REGISTRYINDEX, on_install);

    pushSelf(L);

    SWIG_NewPointerObj(L, player, SWIGTYPE_p_ServerPlayer, 0);

    int error = lua_pcall(L, 2, 0, 0);
    if (error) {
        const char *error_msg = lua_tostring(L, -1);
        lua_pop(L, 1);
        Room *room = player->getRoom();
        room->output(error_msg);
    }
}

void LuaArmor::onUninstall(ServerPlayer *player) const
{
    if (on_uninstall == 0)
        return Armor::onUninstall(player);

    lua_State *L = Sanguosha->getLuaState();

    // the callback
    lua_rawgeti(L, LUA_REGISTRYINDEX, on_uninstall);

    pushSelf(L);

    SWIG_NewPointerObj(L, player, SWIGTYPE_p_ServerPlayer, 0);

    int error = lua_pcall(L, 2, 0, 0);
    if (error) {
        const char *error_msg = lua_tostring(L, -1);
        lua_pop(L, 1);
        Room *room = player->getRoom();
        room->output(error_msg);
    }
}


void LuaTreasure::pushSelf(lua_State *L) const
{
    LuaTreasure *self = const_cast<LuaTreasure *>(this);
    SWIG_NewPointerObj(L, self, SWIGTYPE_p_LuaTreasure, 0);
}

void LuaTreasure::onInstall(ServerPlayer *player) const
{
    if (on_install == 0)
        return Treasure::onInstall(player);

    lua_State *L = Sanguosha->getLuaState();

    // the callback
    lua_rawgeti(L, LUA_REGISTRYINDEX, on_install);

    pushSelf(L);

    SWIG_NewPointerObj(L, player, SWIGTYPE_p_ServerPlayer, 0);

    int error = lua_pcall(L, 2, 0, 0);
    if (error) {
        const char *error_msg = lua_tostring(L, -1);
        lua_pop(L, 1);
        Room *room = player->getRoom();
        room->output(error_msg);
    }
}

void LuaTreasure::onUninstall(ServerPlayer *player) const
{
    if (on_uninstall == 0)
        return Treasure::onUninstall(player);

    lua_State *L = Sanguosha->getLuaState();

    // the callback
    lua_rawgeti(L, LUA_REGISTRYINDEX, on_uninstall);

    pushSelf(L);

    SWIG_NewPointerObj(L, player, SWIGTYPE_p_ServerPlayer, 0);

    int error = lua_pcall(L, 2, 0, 0);
    if (error) {
        const char *error_msg = lua_tostring(L, -1);
        lua_pop(L, 1);
        Room *room = player->getRoom();
        room->output(error_msg);
    }
}

void LuaScenario::assign(QStringList &generals, QStringList &generals2, QStringList &kingdom, Room *room) const
{
    if (on_assign == 0)
        return Scenario::assign(generals, generals2, kingdom, room);

    lua_State *L = room->getLuaState();

    lua_rawgeti(L, LUA_REGISTRYINDEX, on_assign);

    LuaScenario *self = const_cast<LuaScenario *>(this);
    SWIG_NewPointerObj(L, self, SWIGTYPE_p_LuaScenario, 0);

    SWIG_NewPointerObj(L, room, SWIGTYPE_p_Room, 0);

    int error = lua_pcall(L, 2, 3, 0);
    if (error) {
        const char *error_msg = lua_tostring(L, -1);
        lua_pop(L, 1);
        room->output(error_msg);
        return Scenario::assign(generals, generals2, kingdom, room);
    } else {
        kingdom = QString(lua_tostring(L, -1)).split("+");
        generals2 = QString(lua_tostring(L, -2)).split("+");
        generals = QString(lua_tostring(L, -3)).split("+");
        lua_pop(L, 3);
        return;
    }

}

AI::Relation LuaScenario::relationTo(const ServerPlayer *a, const ServerPlayer *b) const
{
    if (relation == 0)
        return Scenario::relationTo(a, b);

    Room *room = a->getRoom();

    lua_State *L = room->getLuaState();
    lua_rawgeti(L, LUA_REGISTRYINDEX, relation);

    LuaScenario *self = const_cast<LuaScenario *>(this);
    SWIG_NewPointerObj(L, self, SWIGTYPE_p_LuaScenario, 0);

    SWIG_NewPointerObj(L, a, SWIGTYPE_p_ServerPlayer, 0);
    SWIG_NewPointerObj(L, b, SWIGTYPE_p_ServerPlayer, 0);

    int error = lua_pcall(L, 3, 1, 0);
    if (error) {
        const char *error_msg = lua_tostring(L, -1);
        lua_pop(L, 1);
        room->output(error_msg);
        return Scenario::relationTo(a, b);
    } else {
        int result = lua_tointeger(L, -1);
        lua_pop(L, 1);
        return AI::Relation(result);
    }
}

void LuaScenario::onTagSet(Room *room, const char *key) const
{
    if (on_tag_set == 0)
        return;
    lua_State *L = room->getLuaState();

    lua_rawgeti(L, LUA_REGISTRYINDEX, on_tag_set);

    LuaScenario *self = const_cast<LuaScenario *>(this);
    SWIG_NewPointerObj(L, self, SWIGTYPE_p_LuaScenario, 0);

    SWIG_NewPointerObj(L, room, SWIGTYPE_p_Room, 0);

    lua_pushstring(L, key);

    int error = lua_pcall(L, 3, 0, 0);
    if (error) {
        const char *error_msg = lua_tostring(L, -1);
        lua_pop(L, 1);
        room->output(error_msg);
        return;
    }
}


%}
