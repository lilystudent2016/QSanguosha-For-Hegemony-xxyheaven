/********************************************************************
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

#include "standard-wei-generals.h"
#include "skill.h"
#include "engine.h"
#include "standard-basics.h"
#include "standard-tricks.h"
#include "client.h"
#include "settings.h"
#include "roomthread.h"

class Jianxiong : public MasochismSkill
{
public:
    Jianxiong() : MasochismSkill("jianxiong")
    {
        frequency = Frequent;
    }

    virtual QStringList triggerable(TriggerEvent, Room *room, ServerPlayer *player, QVariant &data, ServerPlayer * &) const
    {
        if (MasochismSkill::triggerable(player)) {
            DamageStruct damage = data.value<DamageStruct>();
            const Card *card = damage.card;
            if (damage.card == NULL)
                return QStringList();

            QList<int> table_cardids = room->getCardIdsOnTable(card);

            return (table_cardids.length() != 0 && card->getSubcards() == table_cardids) ? QStringList(objectName()) : QStringList();
        }
        return QStringList();
    }

    virtual bool cost(TriggerEvent, Room *room, ServerPlayer *player, QVariant &data, ServerPlayer *) const
    {
        if (player->askForSkillInvoke(this, data)) {
            room->broadcastSkillInvoke(objectName(), player);
            return true;
        }
        return false;
    }

    virtual void onDamaged(ServerPlayer *player, const DamageStruct &damage) const
    {
        player->obtainCard(damage.card);
    }
};

Fankui::Fankui(const QString &owner) : MasochismSkill("fankui" + owner)
{
}

QStringList Fankui::triggerable(TriggerEvent, Room *, ServerPlayer *simayi, QVariant &data, ServerPlayer* &) const
{
    if (MasochismSkill::triggerable(simayi)) {
        ServerPlayer *from = data.value<DamageStruct>().from;
        return (from && simayi->canGetCard(from, "he")) ? QStringList(objectName()) : QStringList();
    }
    return QStringList();
}

bool Fankui::cost(TriggerEvent, Room *room, ServerPlayer *simayi, QVariant &data, ServerPlayer *) const
{
    DamageStruct damage = data.value<DamageStruct>();
    if (!damage.from->isNude() && simayi->askForSkillInvoke(this, data)) {
        room->broadcastSkillInvoke(objectName(), simayi);
        room->doAnimate(QSanProtocol::S_ANIMATE_INDICATE, simayi->objectName(), damage.from->objectName());
        return true;
    }
    return false;
}

void Fankui::onDamaged(ServerPlayer *simayi, const DamageStruct &damage) const
{
    Room *room = simayi->getRoom();
    int card_id = room->askForCardChosen(simayi, damage.from, "he", objectName(), false, Card::MethodGet);
    CardMoveReason reason(CardMoveReason::S_REASON_EXTRACTION, simayi->objectName());
    room->obtainCard(simayi, Sanguosha->getCard(card_id), reason, false);
}

class Guicai : public TriggerSkill
{
public:
    Guicai() : TriggerSkill("guicai")
    {
        events << AskForRetrial;
    }

    virtual QStringList triggerable(TriggerEvent, Room *, ServerPlayer *player, QVariant &, ServerPlayer * &) const
    {
        if (!TriggerSkill::triggerable(player)) return QStringList();
        if (player->isNude() && player->getHandPile().isEmpty())
            return QStringList();
        return QStringList(objectName());
    }

    virtual bool cost(TriggerEvent, Room *room, ServerPlayer *player, QVariant &data, ServerPlayer *) const
    {
        JudgeStruct *judge = data.value<JudgeStruct *>();

        QStringList prompt_list;
        prompt_list << "@guicai-card" << judge->who->objectName()
            << objectName() << judge->reason << QString::number(judge->card->getEffectiveId());
        QString prompt = prompt_list.join(":");

        const Card *card = room->askForCard(player, "..", prompt, data, Card::MethodResponse, judge->who, true);

        if (card) {

            LogMessage log;
            log.type = "#InvokeSkill";
            log.from = player;
            log.arg = objectName();
            room->sendLog(log);

            LogMessage log2;
            log2.card_str = card->toString();
            log2.from = player;
            log2.type = QString("#%1_Resp").arg(card->getClassName());
            room->sendLog(log2);

            room->notifySkillInvoked(player, objectName());
            room->broadcastSkillInvoke(objectName(), player);

            int id = card->getEffectiveId();
            bool isHandcard = (room->getCardOwner(id) == player && room->getCardPlace(id) == Player::PlaceHand);

            CardMoveReason reason(CardMoveReason::S_REASON_RESPONSE, player->objectName(), objectName(), QString());

            room->moveCardTo(card, NULL, Player::PlaceTable, reason);

            CardResponseStruct resp(card, judge->who, false);
            resp.m_isHandcard = isHandcard;
            resp.m_data = data;
            QVariant _data = QVariant::fromValue(resp);
            room->getThread()->trigger(CardResponded, room, player, _data);

            QStringList card_list = player->tag["guicai_cards"].toStringList();
            card_list.append(card->toString());
            player->tag["guicai_cards"] = card_list;

            return true;
        }
        return false;
    }

    virtual bool effect(TriggerEvent, Room *room, ServerPlayer *player, QVariant &data, ServerPlayer *) const
    {
        QStringList card_list = player->tag["guicai_cards"].toStringList();

        if (card_list.isEmpty()) return false;

        QString card_str = card_list.takeLast();
        player->tag["guicai_cards"] = card_list;

        const Card *card = Card::Parse(card_str);
        if (card) {

            JudgeStruct *judge = data.value<JudgeStruct *>();

            room->retrial(card, player, judge, objectName(), false);

            judge->updateResult();
        }
        return false;
    }
};

class Ganglie : public MasochismSkill
{
public:
    Ganglie() : MasochismSkill("ganglie")
    {

    }

    virtual bool cost(TriggerEvent, Room *room, ServerPlayer *player, QVariant &data, ServerPlayer *) const
    {
        if (player->askForSkillInvoke(this, data)) {
            DamageStruct damage = data.value<DamageStruct>();
            if (damage.from != NULL && damage.from->isAlive())
                room->doAnimate(QSanProtocol::S_ANIMATE_INDICATE, player->objectName(), damage.from->objectName());
            room->broadcastSkillInvoke(objectName(), player);
            return true;
        }
        return false;
    }

    virtual void onDamaged(ServerPlayer *xiahou, const DamageStruct &damage) const
    {
        Room *room = xiahou->getRoom();
        ServerPlayer *from = damage.from;
        if (xiahou->isDead()) return;

        JudgeStruct judge;
        judge.pattern = ".";
        judge.patterns << ".|red" << ".|black";
        judge.reason = objectName();
        judge.who = xiahou;

        room->judge(judge);

        if (judge.pattern == ".|red") {
            if (from && from->isAlive())
                room->damage(DamageStruct(objectName(), xiahou, from));
        } else if (judge.pattern == ".|black") {
            if (from && from->isAlive() && xiahou->isAlive() && xiahou->canDiscard(from, "he")) {
                CardMoveReason reason = CardMoveReason(CardMoveReason::S_REASON_DISMANTLE, xiahou->objectName(),
                                                       from->objectName(), objectName(), NULL);
                int id = room->askForCardChosen(xiahou, from, "he", objectName(), false, Card::MethodDiscard);
                room->throwCard(Sanguosha->getCard(id), reason, from, xiahou);
            }

        }
    }
};

Tuxi::Tuxi(const QString &owner) : DrawCardsSkill("tuxi" + owner)
{
}

QStringList Tuxi::triggerable(TriggerEvent, Room *room, ServerPlayer *player, QVariant &data, ServerPlayer * &) const
{
    if (!DrawCardsSkill::triggerable(player) || player->getPhase() != Player::Draw) return QStringList();
    if (data.toInt() < 1) return QStringList();
    QList<ServerPlayer *> other_players = room->getOtherPlayers(player);
    foreach (ServerPlayer *p, other_players) {
        if (player->canGetCard(p, "h")) {
            return QStringList(objectName());
        }
    }
    return QStringList();
}

bool Tuxi::cost(TriggerEvent, Room *room, ServerPlayer *player, QVariant &data, ServerPlayer *) const
{
    QList<ServerPlayer *> to_choose;
    foreach(ServerPlayer *p, room->getOtherPlayers(player)) {
        if (player->canGetCard(p, "h"))
            to_choose << p;
    }

    int x = data.toInt();
    QList<ServerPlayer *> choosees = room->askForPlayersChosen(player, to_choose, objectName(), 0, x, "@tuxi-card:::" + QString::number(x), true);
    if (choosees.length() > 0) {
        room->sortByActionOrder(choosees);
        player->tag["tuxi_invoke"] = QVariant::fromValue(choosees);
        room->broadcastSkillInvoke(objectName(), player);
        return true;
    }

    return false;
}

int Tuxi::getDrawNum(ServerPlayer *source, int n) const
{
    Room *room = source->getRoom();
    QList<ServerPlayer *> targets = source->tag["tuxi_invoke"].value<QList<ServerPlayer *> >();
    source->tag.remove("tuxi_invoke");

    foreach (ServerPlayer *target, targets) {
        if (!source->canGetCard(target, "h")) continue;
        int card_id = room->askForCardChosen(source, target, "h", "tuxi", false, Card::MethodGet);
        CardMoveReason reason(CardMoveReason::S_REASON_EXTRACTION, source->objectName());
        room->obtainCard(source, Sanguosha->getCard(card_id), reason, false);
    }

    return n - targets.length();
}

class Luoyi : public TriggerSkill
{
public:
    Luoyi() : TriggerSkill("luoyi")
    {
        events << EventPhaseEnd << PreCardUsed << EventPhaseStart;
    }

    virtual void record(TriggerEvent triggerEvent, Room *room, ServerPlayer *player, QVariant &) const
    {
        if (triggerEvent == EventPhaseStart) {
            if (player->getPhase() == Player::NotActive) {
                QList<ServerPlayer *> allplayers = room->getAlivePlayers();
                foreach (ServerPlayer *p, allplayers) {
                    room->setPlayerMark(p, "##luoyi", 0);
                }
            }
        }
    }

    virtual QStringList triggerable(TriggerEvent triggerEvent, Room *, ServerPlayer *player, QVariant &, ServerPlayer * &) const
    {
        if (triggerEvent == EventPhaseEnd) {
            if (TriggerSkill::triggerable(player) && player->getPhase() == Player::Draw && !player->isNude())
                return QStringList(objectName());
        }
        return QStringList();
    }

    virtual bool cost(TriggerEvent, Room *room, ServerPlayer *player, QVariant &, ServerPlayer *) const
    {
        if (room->askForDiscard(player, objectName(), 1, 1, true, true, "@luoyi", true)) {
            room->broadcastSkillInvoke(objectName(), player);
            return true;
        }

        return false;
    }

    virtual bool effect(TriggerEvent, Room *room, ServerPlayer *player, QVariant &, ServerPlayer *) const
    {
        room->addPlayerMark(player, "##luoyi");
        return false;
    }
};

class LuoyiDamage : public TriggerSkill
{
public:
    LuoyiDamage() : TriggerSkill("#luoyi-damage")
    {
        events << DamageCaused;
        frequency = Skill::Compulsory;
    }

    virtual QStringList triggerable(TriggerEvent, Room *, ServerPlayer *player, QVariant &data, ServerPlayer * &) const
    {
        if (player != NULL && player->isAlive() && player->getMark("##luoyi") > 0) {
            DamageStruct damage = data.value<DamageStruct>();
            if (damage.card != NULL && (damage.card->isKindOf("Slash") || damage.card->isKindOf("Duel"))
                    && !damage.chain && !damage.transfer) {
                return QStringList(objectName());
            }
        }
        return QStringList();
    }

    virtual bool effect(TriggerEvent, Room *room, ServerPlayer *player, QVariant &data, ServerPlayer *) const
    {
        DamageStruct damage = data.value<DamageStruct>();
        LogMessage log;
        log.type = "#LuoyiBuff";
        log.from = player;
        log.to << damage.to;
        log.arg = QString::number(damage.damage);
        log.arg2 = QString::number(++damage.damage);
        room->sendLog(log);

        data = QVariant::fromValue(damage);

        return false;
    }
};

class Tiandu : public TriggerSkill
{
public:
    Tiandu() : TriggerSkill("tiandu")
    {
        frequency = Frequent;
        events << FinishJudge;
    }

    virtual QStringList triggerable(TriggerEvent, Room *room, ServerPlayer *player, QVariant &data, ServerPlayer * &) const
    {
        JudgeStruct *judge = data.value<JudgeStruct *>();
        if (room->getCardPlace(judge->card->getEffectiveId()) == Player::PlaceJudge && TriggerSkill::triggerable(player))
            return QStringList(objectName());
        return QStringList();
    }

    virtual bool cost(TriggerEvent, Room *room, ServerPlayer *player, QVariant &data, ServerPlayer *) const
    {
        if (player->askForSkillInvoke(this, data)) {
            room->broadcastSkillInvoke(objectName(), player);
            return true;
        }
        return false;
    }

    virtual bool effect(TriggerEvent, Room *, ServerPlayer *player, QVariant &data, ServerPlayer *) const
    {
        JudgeStruct *judge = data.value<JudgeStruct *>();
        player->obtainCard(judge->card);
        return false;
    }
};

class Yiji : public MasochismSkill
{
public:
    Yiji() : MasochismSkill("yiji")
    {
        frequency = Frequent;
    }

    virtual QStringList triggerable(TriggerEvent, Room *, ServerPlayer *player, QVariant &, ServerPlayer* &) const
    {
        if (TriggerSkill::triggerable(player))
            return QStringList(objectName());

        return QStringList();
    }

    virtual bool cost(TriggerEvent, Room *room, ServerPlayer *guojia, QVariant &data, ServerPlayer *) const
    {
        if (guojia->askForSkillInvoke(this, data)) {
            room->broadcastSkillInvoke(objectName(), guojia);
            return true;
        }

        return false;
    }

    virtual void onDamaged(ServerPlayer *guojia, const DamageStruct &) const
    {
        Room *room = guojia->getRoom();

        QList<ServerPlayer *> _guojia;
        _guojia.append(guojia);
        QList<int> yiji_cards = room->getNCards(2, false);

        CardMoveReason preview_reason(CardMoveReason::S_REASON_PREVIEW, guojia->objectName(), objectName(), QString());

        CardsMoveStruct move(yiji_cards, NULL, guojia, Player::PlaceTable, Player::PlaceHand, preview_reason);
        QList<CardsMoveStruct> moves;
        moves.append(move);
        room->notifyMoveCards(true, moves, false, _guojia);
        room->notifyMoveCards(false, moves, false, _guojia);
        QList<int> origin_yiji = yiji_cards;
        while (room->askForYiji(guojia, yiji_cards, objectName(), true, false, true, -1, room->getAlivePlayers())) {
            CardsMoveStruct move(QList<int>(), guojia, NULL, Player::PlaceHand, Player::PlaceTable, preview_reason);
            foreach (int id, origin_yiji) {
                if (room->getCardPlace(id) != Player::DrawPile) {
                    move.card_ids << id;
                    yiji_cards.removeOne(id);
                }
            }
            origin_yiji = yiji_cards;
            QList<CardsMoveStruct> moves;
            moves.append(move);
            room->notifyMoveCards(true, moves, false, _guojia);
            room->notifyMoveCards(false, moves, false, _guojia);
            if (!guojia->isAlive())
                return;
        }

        if (!yiji_cards.isEmpty()) {
            CardsMoveStruct move(yiji_cards, guojia, NULL, Player::PlaceHand, Player::PlaceTable, preview_reason);
            QList<CardsMoveStruct> moves;
            moves.append(move);
            room->notifyMoveCards(true, moves, false, _guojia);
            room->notifyMoveCards(false, moves, false, _guojia);


            foreach (int id, yiji_cards) {
                guojia->obtainCard(Sanguosha->getCard(id), false);
            }
        }
    }
};

class Luoshen : public TriggerSkill
{
public:
    Luoshen() : TriggerSkill("luoshen")
    {
        events << EventPhaseStart;
        frequency = Frequent;
    }

    virtual QStringList triggerable(TriggerEvent, Room *, ServerPlayer *player, QVariant &, ServerPlayer * &) const
    {
        if (player->getPhase() == Player::Start) {
            if (TriggerSkill::triggerable(player))
                return QStringList(objectName());
        }
        return QStringList();
    }

    virtual bool cost(TriggerEvent, Room *room, ServerPlayer *player, QVariant &, ServerPlayer *) const
    {
        if (player->askForSkillInvoke(this)) {
            room->broadcastSkillInvoke(objectName(), player);
            return true;
        }
        return false;
    }

    virtual bool effect(TriggerEvent, Room *room, ServerPlayer *zhenji, QVariant &, ServerPlayer *) const
    {
        JudgeStruct judge;
        judge.pattern = ".|black";
        judge.good = true;
        judge.reason = objectName();
        judge.who = zhenji;

        QList<int> card_list;
        do {
            room->judge(judge);
            if (judge.isGood())
                card_list.append(judge.card->getEffectiveId());
            else
                break;
        } while (zhenji->askForSkillInvoke(this, QVariant(), false));

        QList<int> subcards;
        foreach(int id, card_list)
            if (room->getCardPlace(id) == Player::PlaceJudge && !subcards.contains(id))
                subcards << id;
        if (subcards.length() != 0) {
            DummyCard dummy(subcards);
            zhenji->obtainCard(&dummy);
        }

        return false;
    }
};

class Qingguo : public OneCardViewAsSkill
{
public:
    Qingguo() : OneCardViewAsSkill("qingguo")
    {
        filter_pattern = ".|black|.|hand";
        response_pattern = "jink";
        response_or_use = true;
    }

    virtual const Card *viewAs(const Card *originalCard) const
    {
        Jink *jink = new Jink(originalCard->getSuit(), originalCard->getNumber());
        jink->setSkillName(objectName());
        jink->addSubcard(originalCard->getId());
        jink->setShowSkill(objectName());
        return jink;
    }
};

ShensuCard::ShensuCard()
{
    mute = true;
}

bool ShensuCard::targetFilter(const QList<const Player *> &targets, const Player *to_select, const Player *Self) const
{
    Slash *slash = new Slash(NoSuit, 0);
    slash->setSkillName("shensu");
    slash->setFlags("Global_NoDistanceChecking");
    slash->deleteLater();
    return slash->targetFilter(targets, to_select, Self);
}

void ShensuCard::use(Room *, ServerPlayer *source, QList<ServerPlayer *> &targets) const
{
    QStringList target_list = source->tag["shensu_target"].toStringList();
    QStringList p_list;
    foreach (ServerPlayer *to, targets) {
        p_list.append(to->objectName());
    }
    target_list << p_list;
    source->tag["shensu_target"] = target_list;
}

class ShensuViewAsSkill : public ViewAsSkill
{
public:
    ShensuViewAsSkill() : ViewAsSkill("shensu")
    {
    }

    virtual bool isEnabledAtPlay(const Player *) const
    {
        return false;
    }

    virtual bool isEnabledAtResponse(const Player *, const QString &pattern) const
    {
        return pattern.startsWith("@@shensu");
    }

    virtual bool viewFilter(const QList<const Card *> &selected, const Card *to_select) const
    {
        if (Sanguosha->currentRoomState()->getCurrentCardUsePattern().endsWith("2"))
            return selected.isEmpty() && to_select->isKindOf("EquipCard") && !Self->isJilei(to_select);
        return false;
    }

    virtual const Card *viewAs(const QList<const Card *> &cards) const
    {
        if (Sanguosha->currentRoomState()->getCurrentCardUsePattern().endsWith("2")) {
            if (cards.length() == 1) {
                ShensuCard *shensu = new ShensuCard;
                shensu->addSubcards(cards);
                return shensu;
            }
            return NULL;
        }
        if (cards.isEmpty()) {
            ShensuCard *shensu = new ShensuCard;
            return shensu;
        }
        return NULL;
    }
};

class Shensu : public TriggerSkill
{
public:
    Shensu() : TriggerSkill("shensu")
    {
        events << EventPhaseChanging;
        view_as_skill = new ShensuViewAsSkill;
    }

    virtual bool canPreshow() const
    {
        return true;
    }

    virtual QStringList triggerable(TriggerEvent, Room *, ServerPlayer *xiahouyuan, QVariant &data, ServerPlayer * &) const
    {
        if (!TriggerSkill::triggerable(xiahouyuan) || !Slash::IsAvailable(xiahouyuan))
            return QStringList();
        PhaseChangeStruct change = data.value<PhaseChangeStruct>();
        if (change.to == Player::Judge && !xiahouyuan->isSkipped(Player::Judge) && !xiahouyuan->isSkipped(Player::Draw)) {
            return QStringList(objectName());
        } else if (change.to == Player::Play && !xiahouyuan->isNude() && !xiahouyuan->isSkipped(Player::Play)) {
            return QStringList(objectName());
        } else if (change.to == Player::Discard && !xiahouyuan->isSkipped(Player::Discard)) {
            return QStringList(objectName());
        }

        return QStringList();
    }

    virtual bool cost(TriggerEvent, Room *room, ServerPlayer *xiahouyuan, QVariant &data, ServerPlayer *) const
    {
        PhaseChangeStruct change = data.value<PhaseChangeStruct>();
        if (change.to == Player::Judge && room->askForUseCard(xiahouyuan, "@@shensu1", "@shensu1", 1)) {
            xiahouyuan->skip(Player::Judge);
            xiahouyuan->skip(Player::Draw);
            return true;
        } else if (change.to == Player::Play && room->askForUseCard(xiahouyuan, "@@shensu2", "@shensu2", 2, Card::MethodDiscard)) {
            xiahouyuan->skip(Player::Play);
            return true;
        } else if (change.to == Player::Discard && room->askForUseCard(xiahouyuan, "@@shensu3", "@shensu3", 3)) {
            room->loseHp(xiahouyuan);
            xiahouyuan->skip(Player::Discard);
            return true;
        }
        return false;
    }

    virtual bool effect(TriggerEvent, Room *room, ServerPlayer *player, QVariant &, ServerPlayer *) const
    {
        QStringList target_list = player->tag["shensu_target"].toStringList();
        if (target_list.isEmpty()) return false;
        QString p_list = target_list.takeLast();
        player->tag["shensu_target"] = target_list;
        QStringList p_names = p_list.split("+");

        Slash *slash = new Slash(Card::NoSuit, 0);
        slash->setSkillName("_shensu");
        QList<ServerPlayer *> targets;
        foreach (QString p_name, p_names) {
            ServerPlayer *p = room->findPlayerbyobjectName(p_name);
            if (p)
                targets << p;
        }
        if (!targets.isEmpty())
            room->useCard(CardUseStruct(slash, player, targets), false);

        return false;
    }
};

QiaobianAskCard::QiaobianAskCard()
{
    mute = true;
}

bool QiaobianAskCard::targetsFeasible(const QList<const Player *> &targets, const Player *Self) const
{
    Player::Phase phase = (Player::Phase)Self->getMark("qiaobianPhase");
    if (phase == Player::Draw)
        return targets.length() <= 2 && !targets.isEmpty();
    else if (phase == Player::Play)
        return targets.length() == 2;
    return false;
}

bool QiaobianAskCard::targetFilter(const QList<const Player *> &targets, const Player *to_select, const Player *Self) const
{
    Player::Phase phase = (Player::Phase)Self->getMark("qiaobianPhase");
    if (phase == Player::Draw)
        return targets.length() < 2 && to_select != Self && Self->canGetCard(to_select, "h");
    else if (phase == Player::Play) {
        if (targets.isEmpty())
            return (!to_select->getJudgingArea().isEmpty() || !to_select->getEquips().isEmpty());
        else if (targets.length() == 1){
            for (int i = 0; i < S_EQUIP_AREA_LENGTH; i++) {
                if (targets.first()->getEquip(i) && to_select->canSetEquip(i))
                    return true;
            }
            foreach(const Card *card, targets.first()->getJudgingArea()){
                if (!Sanguosha->isProhibited(NULL, to_select, card))
                    return true;
            }

        }
    }
    return false;
}

void QiaobianAskCard::onUse(Room *room, const CardUseStruct &card_use) const
{
    CardUseStruct use = card_use;
    ServerPlayer *zhanghe = use.from;
    Player::Phase phase = (Player::Phase)zhanghe->getMark("qiaobianPhase");
    if (phase == Player::Draw) {
        if (use.to.isEmpty())
            return;

        room->sortByActionOrder(use.to);
        foreach (ServerPlayer *p, use.to) {
            room->doAnimate(QSanProtocol::S_ANIMATE_INDICATE, zhanghe->objectName(), p->objectName());
        }
        foreach (ServerPlayer *target, use.to) {
            if (zhanghe->isAlive() && target->isAlive())
                room->cardEffect(this, zhanghe, target);
        }
    } else if (phase == Player::Play) {
        if (use.to.length() != 2)
            return;

        ServerPlayer *from = use.to.first();
        ServerPlayer *to = use.to.last();

        bool can_select = false;
        QList<int> disabled_ids;
        for (int i = 0; i < S_EQUIP_AREA_LENGTH; i++) {
            if (from->getEquip(i)){
                if (to->canSetEquip(i))
                    can_select = true;
                else
                    disabled_ids << from->getEquip(i)->getEffectiveId();
            }
        }

        foreach(const Card *card, from->getJudgingArea()){
            if (!Sanguosha->isProhibited(NULL, to, card))
                can_select = true;
            else
                disabled_ids << card->getEffectiveId();
        }

        if (can_select) {
            int card_id = room->askForCardChosen(zhanghe, from, "ej", "qiaobian", false, Card::MethodNone, disabled_ids);
            room->moveCardTo(Sanguosha->getCard(card_id), from, to, room->getCardPlace(card_id), CardMoveReason(CardMoveReason::S_REASON_TRANSFER, zhanghe->objectName(), "qiaobian", QString()));
        }
    }
}

void QiaobianAskCard::onEffect(const CardEffectStruct &effect) const
{
   Room *room = effect.from->getRoom();
    if (effect.from->canGetCard(effect.to, "h")) {
        int card_id = room->askForCardChosen(effect.from, effect.to, "h", "qiaobian", false, Card::MethodGet);
        CardMoveReason reason(CardMoveReason::S_REASON_EXTRACTION, effect.from->objectName());
        room->obtainCard(effect.from, Sanguosha->getCard(card_id), reason, false);
    }
}

class QiaobianAsk : public ZeroCardViewAsSkill
{
public:
    QiaobianAsk() : ZeroCardViewAsSkill("qiaobian_ask")
    {
        response_pattern = "@@qiaobian_ask";
    }

    virtual const Card *viewAs() const
    {
        return new QiaobianAskCard;
    }
};

Qiaobian::Qiaobian(const QString &owner) : TriggerSkill("qiaobian" + owner)
{
    events << EventPhaseChanging;
}

QStringList Qiaobian::triggerable(TriggerEvent, Room *room, ServerPlayer *player, QVariant &data, ServerPlayer * &) const
{
    PhaseChangeStruct change = data.value<PhaseChangeStruct>();
    room->setPlayerMark(player, "qiaobianPhase", (int)change.to);
    int index = 0;
    switch (change.to) {
        case Player::RoundStart:
        case Player::Start:
        case Player::Finish:
        case Player::NotActive: return QStringList();

        case Player::Judge: index = 1; break;
        case Player::Draw: index = 2; break;
        case Player::Play: index = 3; break;
        case Player::Discard: index = 4; break;
        case Player::PhaseNone: Q_ASSERT(false);
    }
    if (TriggerSkill::triggerable(player) && index > 0 && !player->isKongcheng() && !player->isSkipped(change.to))
        return QStringList(objectName());
    return QStringList();
}

bool Qiaobian::cost(TriggerEvent, Room *room, ServerPlayer *zhanghe, QVariant &data, ServerPlayer *) const
{
    PhaseChangeStruct change = data.value<PhaseChangeStruct>();
    static QStringList phase_strings;
    if (phase_strings.isEmpty())
        phase_strings << "round_start" << "start" << "judge" << "draw"
        << "play" << "discard" << "finish" << "not_active";
    int index = static_cast<int>(change.to);

    QString discard_prompt = QString("#qiaobian:::%1").arg(phase_strings[index]);

    if (room->askForDiscard(zhanghe, objectName(), 1, 1, true, false, discard_prompt, true)) {
        room->broadcastSkillInvoke(objectName(), zhanghe);
        return true;
    }
    return false;
}

bool Qiaobian::effect(TriggerEvent, Room *room, ServerPlayer *zhanghe, QVariant &data, ServerPlayer *) const
{
    PhaseChangeStruct change = data.value<PhaseChangeStruct>();
    zhanghe->skip(change.to);
    int index = 0;
    switch (change.to) {
        case Player::RoundStart:
        case Player::Start:
        case Player::Finish:
        case Player::NotActive: return false;

        case Player::Judge: index = 1; break;
        case Player::Draw: index = 2; break;
        case Player::Play: index = 3; break;
        case Player::Discard: index = 4; break;
        case Player::PhaseNone: Q_ASSERT(false);
    }
    if (index == 2 || index == 3) {
        QString use_prompt = QString("@qiaobian-%1").arg(index);
        room->askForUseCard(zhanghe, "@@qiaobian_ask", use_prompt, index);
    }
    return false;
}

class Duanliang : public OneCardViewAsSkill
{
public:
    Duanliang() : OneCardViewAsSkill("duanliang")
    {
        filter_pattern = "BasicCard,EquipCard|black";
        response_or_use = true;
    }

    virtual bool isEnabledAtPlay(const Player *xuhuang) const
    {
        return !xuhuang->hasFlag("DuanliangCannot");
    }

    virtual const Card *viewAs(const Card *originalCard) const
    {
        SupplyShortage *shortage = new SupplyShortage(originalCard->getSuit(), originalCard->getNumber());
        shortage->setSkillName(objectName());
        shortage->setShowSkill(objectName());
        shortage->addSubcard(originalCard);
        shortage->setFlags("Global_NoDistanceChecking");

        return shortage;
    }
};

class JushouSelect : public OneCardViewAsSkill
{
public:
    JushouSelect() : OneCardViewAsSkill("jushou_select")
    {
        response_pattern = "@@jushou_select!";
    }

    bool viewFilter(const Card *to_select) const
    {
        if (to_select->isEquipped()) return false;
        if (to_select->getTypeId() == Card::TypeEquip)
            return to_select->isAvailable(Self);
        return !Self->isJilei(to_select);
    }

    virtual const Card *viewAs(const Card *originalCard) const
    {
        DummyCard *select = new DummyCard;
        select->addSubcard(originalCard);
        return select;
    }
};

class Jushou : public PhaseChangeSkill
{
public:
    Jushou() : PhaseChangeSkill("jushou")
    {
        frequency = Frequent;
    }

    virtual QStringList triggerable(TriggerEvent, Room *, ServerPlayer *player, QVariant &, ServerPlayer * &) const
    {
        return (PhaseChangeSkill::triggerable(player) && player->getPhase() == Player::Finish) ? QStringList(objectName()) : QStringList();
    }

    virtual bool cost(TriggerEvent, Room *room, ServerPlayer *player, QVariant &data, ServerPlayer *) const
    {
        if (player->askForSkillInvoke(this, data)) {
            room->broadcastSkillInvoke(objectName(), player);
            return true;
        }
        return false;
    }

    virtual bool onPhaseChange(ServerPlayer *caoren) const
    {
        Room *room = caoren->getRoom();
        QList<ServerPlayer *> to_count, players = room->getAlivePlayers();
        foreach (ServerPlayer *p, players) {
            if (!p->hasShownOneGeneral()) continue;
            bool no_friend = true;
            foreach (ServerPlayer *p2, to_count) {
                if (p2->isFriendWith(p)) {
                    no_friend = false;
                    break;
                }
            }
            if (no_friend)
                to_count << p;
        }

        int x = to_count.length();

        caoren->drawCards(x, objectName());

        const Card *card = NULL;
        foreach (int id, caoren->handCards()) {
            const Card *c = Sanguosha->getCard(id);
            if (JushouFilter(caoren, c)) {
                card = c;
                break;
            }
        }
        if (card == NULL) return false;
        const Card *to_select = room->askForCard(caoren, "@@jushou_select!", "@jushou", QVariant(), Card::MethodNone);
        if (to_select != NULL)
            card = Sanguosha->getCard(to_select->getEffectiveId());
        if (card->getTypeId() == Card::TypeEquip)
            room->useCard(CardUseStruct(card, caoren, caoren));
        else
            room->throwCard(card, caoren);
        if (x > 2)
            caoren->turnOver();
        return false;
    }

private:

    static bool JushouFilter(ServerPlayer *caoren, const Card *to_select)
    {
        if (to_select->getTypeId() == Card::TypeEquip)
            return to_select->isAvailable(caoren);
        return !caoren->isJilei(to_select);
    }
};

QiangxiCard::QiangxiCard()
{
}

void QiangxiCard::extraCost(Room *room, const CardUseStruct &card_use) const
{
    if (card_use.card->getSubcards().isEmpty())
        room->loseHp(card_use.from);

    SkillCard::extraCost(room, card_use);
}

void QiangxiCard::onEffect(const CardEffectStruct &effect) const
{
    effect.to->getRoom()->damage(DamageStruct("qiangxi", effect.from, effect.to));
}

class Qiangxi : public ViewAsSkill
{
public:
    Qiangxi() : ViewAsSkill("qiangxi")
    {
    }

    virtual bool isEnabledAtPlay(const Player *player) const
    {
        return !player->hasUsed("QiangxiCard");
    }

    virtual bool viewFilter(const QList<const Card *> &selected, const Card *to_select) const
    {
        return selected.isEmpty() && to_select->isKindOf("Weapon") && !Self->isJilei(to_select);
    }

    virtual const Card *viewAs(const QList<const Card *> &cards) const
    {
        if (cards.isEmpty()) {
            QiangxiCard *card = new QiangxiCard;
            card->setShowSkill(objectName());
            return card;
        } else if (cards.length() == 1) {
            QiangxiCard *card = new QiangxiCard;
            card->addSubcards(cards);
            card->setShowSkill(objectName());
            return card;
        } else
            return NULL;
    }

    virtual int getEffectIndex(const ServerPlayer *, const Card *card) const
    {
        return 2 - card->subcardsLength();
    }
};

QuhuCard::QuhuCard()
{
}

bool QuhuCard::targetFilter(const QList<const Player *> &targets, const Player *to_select, const Player *Self) const
{
    return targets.isEmpty() && to_select->getHp() > Self->getHp() && Self->canPindianTo(to_select);
}

void QuhuCard::onEffect(const CardEffectStruct &effect) const
{
    if (effect.from->canPindianTo(effect.to)) {
        bool success = effect.from->pindian(effect.to, "quhu");
        Room *room = effect.to->getRoom();
        if (success) {
            QList<ServerPlayer *> players = room->getOtherPlayers(effect.to), wolves;
            foreach (ServerPlayer *player, players) {
                if (effect.to->inMyAttackRange(player))
                    wolves << player;
            }

            if (wolves.isEmpty()) {
                LogMessage log;
                log.type = "#QuhuNoWolf";
                log.from = effect.from;
                log.to << effect.to;
                room->sendLog(log);

                return;
            }

            ServerPlayer *wolf = room->askForPlayerChosen(effect.from, wolves, "quhu", QString("@quhu-damage:%1").arg(effect.to->objectName()));

            room->damage(DamageStruct("quhu", effect.to, wolf));
        } else {
            room->damage(DamageStruct("quhu", effect.to, effect.from));
        }
    }
}

class Quhu : public ZeroCardViewAsSkill
{
public:
    Quhu() : ZeroCardViewAsSkill("quhu")
    {
    }

    virtual bool isEnabledAtPlay(const Player *player) const
    {
        return !player->hasUsed("QuhuCard") && !player->isKongcheng();
    }

    virtual const Card *viewAs() const
    {
        QuhuCard *card = new QuhuCard;
        card->setShowSkill(objectName());
        return card;
    }
};

class Jieming : public MasochismSkill
{
public:
    Jieming() : MasochismSkill("jieming")
    {

    }

    virtual QStringList triggerable(TriggerEvent , Room *, ServerPlayer *player, QVariant &, ServerPlayer * &) const
    {
        if (TriggerSkill::triggerable(player))
            return QStringList(objectName());

        return QStringList();
    }


    virtual bool cost(TriggerEvent, Room *room, ServerPlayer *player, QVariant &, ServerPlayer *) const
    {
        if (!player->isAlive())
            return false;

        ServerPlayer *target = room->askForPlayerChosen(player, room->getAlivePlayers(), objectName(), "jieming-invoke", true, true);
        if (target != NULL) {
            room->broadcastSkillInvoke(objectName(), (target == player ? 2 : 1), player);

            QStringList target_list = player->tag["jieming_target"].toStringList();
            target_list.append(target->objectName());
            player->tag["jieming_target"] = target_list;

            return true;
        }
        return false;
    }

    virtual void onDamaged(ServerPlayer *xunyu, const DamageStruct &) const
    {
        QStringList target_list = xunyu->tag["jieming_target"].toStringList();
        QString target_name = target_list.last();
        target_list.removeLast();
        xunyu->tag["jieming_target"] = target_list;

        ServerPlayer *to = NULL;

        foreach (ServerPlayer *p, xunyu->getRoom()->getPlayers()) {
            if (p->objectName() == target_name) {
                to = p;
                break;
            }
        }

        if (to != NULL)
            to->fillHandCards(qMin(5, to->getMaxHp()));
    }
};

class Xingshang : public TriggerSkill
{
public:
    Xingshang() : TriggerSkill("xingshang")
    {
        events << Death;
        frequency = Frequent;
    }

    virtual QStringList triggerable(TriggerEvent, Room *, ServerPlayer *player, QVariant &data, ServerPlayer * &) const
    {
        DeathStruct death = data.value<DeathStruct>();
        ServerPlayer *dead = death.who;
        if (dead->isNude() || player == dead)
            return QStringList();
        return (TriggerSkill::triggerable(player) && player->isAlive()) ? QStringList(objectName()) : QStringList();
    }

    virtual bool cost(TriggerEvent, Room *room, ServerPlayer *player, QVariant &data, ServerPlayer *) const
    {
        if (player->askForSkillInvoke(this, data)) {
            room->broadcastSkillInvoke(objectName(), player);
            return true;
        }
        return false;
    }

    virtual bool effect(TriggerEvent, Room *room, ServerPlayer *caopi, QVariant &data, ServerPlayer *) const
    {
        DeathStruct death = data.value<DeathStruct>();
        ServerPlayer *player = death.who;
        if (player->isNude() || caopi == player)
            return false;
        DummyCard dummy(player->handCards());
        dummy.addSubcards(player->getEquips());
        if (dummy.subcardsLength() > 0) {
            CardMoveReason reason(CardMoveReason::S_REASON_RECYCLE, caopi->objectName());
            room->obtainCard(caopi, &dummy, reason, false);
        }
        return false;
    }
};

class Fangzhu : public MasochismSkill
{
public:
    Fangzhu() : MasochismSkill("fangzhu")
    {
    }

    virtual bool cost(TriggerEvent, Room *room, ServerPlayer *player, QVariant &, ServerPlayer *) const
    {
        ServerPlayer *to = room->askForPlayerChosen(player, room->getOtherPlayers(player), objectName(),
                "fangzhu-invoke", true, true);
        if (to != NULL) {
            room->broadcastSkillInvoke(objectName(), player);
            //player->tag["fangzhu_invoke"] = QVariant::fromValue(to);
            QStringList target_list = player->tag["fangzhu_target"].toStringList();
            target_list.append(to->objectName());
            player->tag["fangzhu_target"] = target_list;
            return true;
        }
        return false;
    }

    virtual void onDamaged(ServerPlayer *caopi, const DamageStruct &) const
    {
        //ServerPlayer *to = caopi->tag["fangzhu_invoke"].value<ServerPlayer *>();
        QStringList target_list = caopi->tag["fangzhu_target"].toStringList();
        QString target_name = target_list.takeLast();
        caopi->tag["fangzhu_target"] = target_list;
        ServerPlayer *to = NULL;
        foreach (ServerPlayer *p, caopi->getRoom()->getAllPlayers()) {
            if (p->objectName() == target_name) {
                to = p;
                break;
            }
        }

        if (to) {
            Room *room = caopi->getRoom();
            int x = caopi->getLostHp();
            if (x > 0 && room->askForDiscard(to, "fangzhu_discard", x, x, true, true, "@fangzhu-discard:::"+QString::number(x)))
                room->loseHp(to);
            else {
                if (caopi->isAlive() && x > 0)
                    to->drawCards(x, objectName());
                to->turnOver();
            }

        }
    }
};

Xiaoguo::Xiaoguo(const QString &owner) : PhaseChangeSkill("xiaoguo" + owner)
{
}

TriggerList Xiaoguo::triggerable(TriggerEvent , Room *room, ServerPlayer *player, QVariant &) const
{
    TriggerList skill_list;
    if (player != NULL && player->isAlive() && player->getPhase() == Player::Finish) {
        QList<ServerPlayer *> yuejins = room->findPlayersBySkillName(objectName());
        foreach (ServerPlayer *yuejin, yuejins) {
            if (yuejin != NULL && player != yuejin && !yuejin->isKongcheng())
                skill_list.insert(yuejin, QStringList(objectName()));
        }
    }
    return skill_list;
}

bool Xiaoguo::cost(TriggerEvent, Room *room, ServerPlayer *player, QVariant &, ServerPlayer *ask_who) const
{
    if (room->askForCard(ask_who, ".Basic", "@xiaoguo:"+player->objectName(), QVariant(), objectName())) {
        room->doAnimate(QSanProtocol::S_ANIMATE_INDICATE, ask_who->objectName(), player->objectName());
        room->broadcastSkillInvoke(objectName(), ask_who);
        return true;
    }
    return false;
}

bool Xiaoguo::effect(TriggerEvent, Room *room, ServerPlayer *player, QVariant &, ServerPlayer *ask_who) const
{
    if (player->isDead()) return false;
    if (room->askForCard(player, ".Equip", "@xiaoguo-discard", QVariant()))
        ask_who->drawCards(1, objectName());
    else
        room->damage(DamageStruct("xiaoguo", ask_who, player));

    return false;
}

bool Xiaoguo::onPhaseChange(ServerPlayer *) const
{
    return false;
}

void StandardPackage::addWeiGenerals()
{
    General *caocao = new General(this, "caocao", "wei"); // WEI 001
    caocao->addCompanion("dianwei");
    caocao->addCompanion("xuchu");
    caocao->addSkill(new Jianxiong);

    General *simayi = new General(this, "simayi", "wei", 3); // WEI 002
    simayi->addSkill(new Fankui);
    simayi->addSkill(new Guicai);

    General *xiahoudun = new General(this, "xiahoudun", "wei", 5); // WEI 003
    xiahoudun->addCompanion("xiahouyuan");
    xiahoudun->addSkill(new Ganglie);

    General *zhangliao = new General(this, "zhangliao", "wei"); // WEI 004
    zhangliao->addSkill(new Tuxi);

    General *xuchu = new General(this, "xuchu", "wei"); // WEI 005
    xuchu->addSkill(new Luoyi);
    xuchu->addSkill(new LuoyiDamage);
    insertRelatedSkills("luoyi", "#luoyi-damage");

    General *guojia = new General(this, "guojia", "wei", 3); // WEI 006
    guojia->addSkill(new Tiandu);
    guojia->addSkill(new Yiji);

    General *zhenji = new General(this, "zhenji", "wei", 3, false); // WEI 007
    zhenji->addSkill(new Qingguo);
    zhenji->addSkill(new Luoshen);

    General *xiahouyuan = new General(this, "xiahouyuan", "wei"); // WEI 008
    xiahouyuan->addSkill(new Shensu);

    General *zhanghe = new General(this, "zhanghe", "wei"); // WEI 009
    zhanghe->addSkill(new Qiaobian);

    General *xuhuang = new General(this, "xuhuang", "wei"); // WEI 010
    xuhuang->addSkill(new Duanliang);

    General *caoren = new General(this, "caoren", "wei"); // WEI 011
    caoren->addSkill(new Jushou);

    General *dianwei = new General(this, "dianwei", "wei"); // WEI 012
    dianwei->addSkill(new Qiangxi);

    General *xunyu = new General(this, "xunyu", "wei", 3); // WEI 013
    xunyu->addSkill(new Quhu);
    xunyu->addSkill(new Jieming);

    General *caopi = new General(this, "caopi", "wei", 3); // WEI 014
    caopi->addCompanion("zhenji");
    caopi->addSkill(new Xingshang);
    caopi->addSkill(new Fangzhu);

    General *yuejin = new General(this, "yuejin", "wei", 4); // WEI 016
    yuejin->addSkill(new Xiaoguo);

    addMetaObject<ShensuCard>();
    addMetaObject<QiaobianAskCard>();
    addMetaObject<QiangxiCard>();
    addMetaObject<QuhuCard>();

    skills << new JushouSelect << new QiaobianAsk;
}
