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

#include "card.h"
#include "settings.h"
#include "engine.h"
#include "client.h"
#include "room.h"
#include "structs.h"
#include "lua-wrapper.h"
#include "standard.h"
#include "roomthread.h"

#include <QFile>

const int Card::S_UNKNOWN_CARD_ID = -1;

const Card::Suit Card::AllSuits[4] = {
    Card::Spade,
    Card::Club,
    Card::Heart,
    Card::Diamond
};

Card::Card(Suit suit, int number, bool target_fixed)
    :target_fixed(target_fixed), mute(false),
    will_throw(true), has_preact(false), can_recast(false), transferable(false),
    m_suit(suit), m_number(number), m_id(-1)
{
    handling_method = will_throw ? Card::MethodDiscard : Card::MethodUse;
}

QString Card::getSuitString() const
{
    return Suit2String(getSuit());
}

QString Card::Suit2String(Suit suit)
{
    switch (suit) {
        case Spade: return "spade";
        case Heart: return "heart";
        case Club: return "club";
        case Diamond: return "diamond";
        case NoSuitBlack: return "no_suit_black";
        case NoSuitRed: return "no_suit_red";
        default: return "no_suit";
    }
}

bool Card::isRed() const
{
    return getColor() == Red;
}

bool Card::isBlack() const
{
    return getColor() == Black;
}

int Card::getId() const
{
    return m_id;
}

void Card::setId(int id)
{
    this->m_id = id;
}

int Card::getEffectiveId() const
{
    if (isVirtualCard()) {
        if (subcards.isEmpty())
            return -1;
        else
            return subcards.first();
    } else
        return m_id;
}

int Card::getNumber() const
{
    if (m_number > 0) return m_number;
    if (isVirtualCard()) {
        if (subcardsLength() == 0 || subcardsLength() >= 2)
            return 0;
        else {
            int num = 0;
            foreach (int id, subcards)
                num += Sanguosha->getCard(id)->getNumber();
            num = qMin(num, 13);
            return num;
        }
    } else
        return m_number;
}

void Card::setNumber(int number)
{
    this->m_number = number;
}

QString Card::getNumberString() const
{
    int number = getNumber();
//    if (isVirtualCard()) {
//        if (subcardsLength() == 0 || subcardsLength() >= 2) number = 0;
//    }
    if (number == 10)
        return "10";
    else {
        static const char *number_string = "-A23456789-JQK";
        return QString(number_string[number]);
    }
}

Card::Suit Card::getSuit() const
{
    if (m_suit != NoSuit && m_suit != SuitToBeDecided)
        return m_suit;
    if (isVirtualCard()) {
        if (subcardsLength() == 0)
            return NoSuit;
        else if (subcardsLength() == 1)
            return Sanguosha->getCard(subcards.first())->getSuit();
        else {
            Color color = Colorless;
            foreach (int id, subcards) {
                Color color2 = Sanguosha->getCard(id)->getColor();
                if (color == Colorless)
                    color = color2;
                else if (color != color2)
                    return NoSuit;
            }
            return (color == Red) ? NoSuitRed : NoSuitBlack;
        }
    } else
        return m_suit;
}

void Card::setSuit(Suit suit)
{
    this->m_suit = suit;
}

bool Card::sameColorWith(const Card *other) const
{
    return getColor() == other->getColor();
}

Card::Color Card::getColor() const
{
    switch (getSuit()) {
        case Spade:
        case Club:
        case NoSuitBlack:
            return Black;
        case Heart:
        case Diamond:
        case NoSuitRed:
            return Red;
        default:
            return Colorless;
    }
}

bool Card::isEquipped() const
{
    return Self->hasEquip(this);
}

bool Card::match(const QString &pattern) const
{
    QStringList patterns = pattern.split("+");
    foreach(const QString &ptn, patterns)
    {
        if (objectName() == ptn || getType() == ptn || getSubtype() == ptn)
            return true;
    }
    return false;
}

bool Card::CompareByNumber(const Card *a, const Card *b)
{
    static Suit new_suits[] = {Spade, Heart, Club, Diamond, NoSuitBlack, NoSuitRed, NoSuit};
    Suit suit1 = new_suits[a->getSuit()];
    Suit suit2 = new_suits[b->getSuit()];

    if (a->m_number != b->m_number)
        return a->m_number < b->m_number;
    else
        return suit1 < suit2;
}

bool Card::CompareBySuit(const Card *a, const Card *b)
{
    static Suit new_suits[] = {Spade, Heart, Club, Diamond, NoSuitBlack, NoSuitRed, NoSuit};
    Suit suit1 = new_suits[a->getSuit()];
    Suit suit2 = new_suits[b->getSuit()];

    if (suit1 != suit2)
        return suit1 < suit2;
    else
        return a->m_number < b->m_number;
}

bool Card::CompareByType(const Card *a, const Card *b)
{
    int order1 = a->getTypeId();
    int order2 = b->getTypeId();
    if (order1 != order2)
        return order1 < order2;
    else {
        static QStringList basic;
        if (basic.isEmpty())
            basic << "slash" << "thunder_slash" << "fire_slash" << "jink" << "peach" << "analeptic";
        switch (a->getTypeId()) {
            case TypeBasic: {
                foreach (const QString &object_name, basic) {
                    if (a->objectName() == object_name) {
                        if (b->objectName() == object_name)
                            return CompareBySuit(a, b);
                        else
                            return true;
                    }
                    if (b->objectName() == object_name)
                        return false;
                }
                return CompareBySuit(a, b);
                break;
            }
            case TypeTrick: {
                if (a->objectName() == b->objectName())
                    return CompareBySuit(a, b);
                else
                    return a->objectName() < b->objectName();
                break;
            }
            case TypeEquip: {
                const EquipCard *eq_a = qobject_cast<const EquipCard *>(a->getRealCard());
                const EquipCard *eq_b = qobject_cast<const EquipCard *>(b->getRealCard());
                if (eq_a->location() == eq_b->location()) {
                    if (eq_a->isKindOf("Weapon")) {
                        const Weapon *wep_a = qobject_cast<const Weapon *>(a->getRealCard());
                        const Weapon *wep_b = qobject_cast<const Weapon *>(b->getRealCard());
                        if (wep_a->getRange() == wep_b->getRange())
                            return CompareBySuit(a, b);
                        else
                            return wep_a->getRange() < wep_b->getRange();
                    } else {
                        if (a->objectName() == b->objectName())
                            return CompareBySuit(a, b);
                        else
                            return a->objectName() < b->objectName();
                    }
                } else {
                    return eq_a->location() < eq_b->location();
                }
                break;
            }
            default:
                return CompareBySuit(a, b);
        }
    }
}

bool Card::isNDTrick() const
{
    return getTypeId() == TypeTrick && !isKindOf("DelayedTrick");
}

QString Card::getPackage() const
{
    if (parent())
        return parent()->objectName();
    else
        return QString();
}

QString Card::getFullName(bool include_suit) const
{
    QString name = getName();
    if (include_suit) {
        QString suit_name = Sanguosha->translate(getSuitString());
        return QString("%1%2 %3").arg(suit_name).arg(getNumberString()).arg(name);
    } else
        return QString("%1 %2").arg(getNumberString()).arg(name);
}

QString Card::getLogName() const
{
    QString suit_char;
    QString number_string;

    switch (getSuit()) {
        case Spade:
        case Heart:
        case Club:
        case Diamond: {
            suit_char = QString("<img src='image/system/log/%1.png' height = 12/>").arg(getSuitString());
            break;
        }
        case NoSuitRed: {
            suit_char = tr("NoSuitRed");
            break;
        }
        case NoSuitBlack: {
            suit_char = tr("NoSuitBlack");
            break;
        }
        case NoSuit: {
            suit_char = tr("NoSuit");
            break;
        }
        default:
            break;
    }

    if (m_number > 0 && m_number <= 13)
        number_string = getNumberString();

    return QString("%1[%2%3]").arg(getName()).arg(suit_char).arg(number_string);
}

QString Card::getCommonEffectName() const
{
    return QString();
}

QString Card::getName() const
{
    return Sanguosha->translate(objectName());
}

bool Card::sameCardNameWith(const Card *other) const
{
    if (isKindOf("Slash") && other->isKindOf("Slash")) return true;
    if (isKindOf("Nullification") && other->isKindOf("Nullification")) return true;
    return objectName() == other->objectName();
}

QString Card::getSkillName(bool removePrefix) const
{
    if (m_skillName.startsWith("_") && removePrefix)
        return m_skillName.mid(1);
    else
        return m_skillName;
}

void Card::setSkillName(const QString &name)
{
    this->m_skillName = name;
}

void Card::setSkillPosition(const QString &position)
{
    this->m_skill_position = position;
}

QString Card::getSkillPosition() const
{
    return m_skill_position;
}

QString Card::getDescription(bool yellow) const
{
    QString desc = Sanguosha->translate(":" + objectName());
    if (desc == ":" + objectName())
        return desc;
    foreach (const QString &skill_type, Sanguosha->getSkillColorMap().keys()) {
        QString to_replace = Sanguosha->translate(skill_type);
        if (to_replace == skill_type) continue;
        QString color_str = Sanguosha->getSkillColor(skill_type).name();
        if (desc.contains(to_replace))
            desc.replace(to_replace, QString("<font color=%1><b>%2</b></font>").arg(color_str)
            .arg(to_replace));
    }

    for (int i = 0; i < 6; i++) {
        Card::Suit suit = (Card::Suit)i;
        QString str = Card::Suit2String(suit);
        QString to_replace = Sanguosha->translate(str);
        bool red = suit == Card::Heart
            || suit == Card::Diamond
            || suit == Card::NoSuitRed;
        if (to_replace == str) continue;
        if (desc.contains(to_replace)) {
            if (red)
                desc.replace(to_replace, QString("<font color=#FF0000>%1</font>").arg(Sanguosha->translate(str + "_char")));
            else
                desc.replace(to_replace, QString("<font color=#000000><span style=background-color:white>%1</span></font>").arg(Sanguosha->translate(str + "_char")));
        }
    }

    desc.replace("\n", "<br/>");
    if (isTransferable()) {
        desc += "<br/><br/>";
        desc += Sanguosha->translate("is_transferable");
    }
    return tr("<font color=%1><b>[%2]</b> %3</font>").arg(yellow ? "#FFFF33" : "#FF0080").arg(getName()).arg(desc);
}

QString Card::toString(bool hidden) const
{
    Q_UNUSED(hidden);
    if (!isVirtualCard())
        return QString::number(m_id);
    else
        return QString("%1:%2[%3:%4]=%5&%6")
        .arg(objectName()).arg(m_skillName)
        .arg(getSuitString()).arg(getNumberString()).arg(subcardString())
        .arg(show_skill);
}

QString Card::toRealString() const
{
    return QString("%1:%2[%3:%4]=%5&")
            .arg(objectName()).arg(getSkillName())
            .arg(getSuitString()).arg(getNumberString())
            .arg(getEffectiveId());
}

QString Card::getEffectName() const
{
    QString name = objectName();
    for (int i = 0; i < name.length(); i++) {
        QChar ch = name[i];
        if (ch.isUpper()) {
            name[i] = ch.toLower();
            if (i != 0)
                name.insert(i, "_");
            break;
        }
    }
    return name;
}

bool Card::isTransferable() const
{
    return transferable;
}

void Card::setTransferable(const bool transferbale)
{
    this->transferable = transferbale;
}

QString Card::subcardString() const
{
    if (subcards.isEmpty())
        return ".";

    QStringList str;
    foreach (int subcard, subcards)
        str << QString::number(subcard);

    return str.join("+");
}

void Card::addSubcards(const QList<const Card *> &cards)
{
    foreach (const Card *card, cards)
        subcards.append(card->getId());
}

void Card::addSubcards(const QList<int> &subcards_list)
{
    subcards.append(subcards_list);
}

int Card::subcardsLength() const
{
    return subcards.length();
}

bool Card::isVirtualCard() const
{
    return m_id < 0;
}

const Card *Card::Parse(const QString &card_str)
{
    static QMap<QString, Card::Suit> suit_map;
    if (suit_map.isEmpty()) {
        suit_map.insert("spade", Card::Spade);
        suit_map.insert("club", Card::Club);
        suit_map.insert("heart", Card::Heart);
        suit_map.insert("diamond", Card::Diamond);
        suit_map.insert("no_suit_red", Card::NoSuitRed);
        suit_map.insert("no_suit_black", Card::NoSuitBlack);
        suit_map.insert("no_suit", Card::NoSuit);
    }

    QStringList str_list = card_str.split("?");
    QString str = str_list.first();
    QString position = str_list.length() > 1 ? str_list.last() : QString();         //get skill postion info. by weirdouncle
    if (str.startsWith(QChar('@'))) {
        // skill card
        QRegExp pattern1("@(\\w+)=([^:]+)&(.*)(:.+)?");
        QRegExp pattern2("@(\\w+)=([^:]+)(:.+)?");
        QRegExp ex_pattern("@(\\w*)\\[(\\w+):(.+)\\]=([^:]+)&(.*)(:.+)?");

        QStringList texts;
        QString card_name, card_suit, card_number;
        QStringList subcard_ids;
        QString subcard_str;
        QString show_skill;
        QString user_string;

        if (pattern1.exactMatch(str)) {
            texts = pattern1.capturedTexts();
            card_name = texts.at(1);
            subcard_str = texts.at(2);
            show_skill = texts.at(3);
            user_string = texts.at(4);
        } else if (pattern2.exactMatch(str)) {
            texts = pattern2.capturedTexts();
            card_name = texts.at(1);
            subcard_str = texts.at(2);
            user_string = texts.at(3);
        } else if (ex_pattern.exactMatch(str)) {
            texts = ex_pattern.capturedTexts();
            card_name = texts.at(1);
            card_suit = texts.at(2);
            card_number = texts.at(3);
            subcard_str = texts.at(4);
            show_skill = texts.at(5);
            user_string = texts.at(6);
        } else
            return NULL;

        if (subcard_str != ".")
            subcard_ids = subcard_str.split("+");

        SkillCard *card = Sanguosha->cloneSkillCard(card_name);

        if (card == NULL)
            return NULL;

        card->addSubcards(StringList2IntList(subcard_ids));

        // skill name
        // @todo: This is extremely dirty and would cause endless troubles.
        QString skillName = card->getSkillName();
        if (skillName.isNull()) {
            skillName = card_name.remove("Card").toLower();
            card->setSkillName(skillName);
        }
        if (!card_suit.isEmpty())
            card->setSuit(suit_map.value(card_suit, Card::NoSuit));

        if (!card_number.isEmpty()) {
            int number = 0;
            if (card_number == "A")
                number = 1;
            else if (card_number == "J")
                number = 11;
            else if (card_number == "Q")
                number = 12;
            else if (card_number == "K")
                number = 13;
            else
                number = card_number.toInt();

            card->setNumber(number);
        }

        if (!show_skill.isEmpty())
            card->setShowSkill(show_skill);
        /*
                else if (!skillName.isEmpty())
                card->setShowSkill(skillName);
                */  // The deletion of this code is extremely dangerous, for all the card in server is created in this way.
        // I(Fs) deleted this in 2015/4/21, for it causes a bug that one cannot use the skill card as the cost.

        if (!user_string.isEmpty()) {
            user_string.remove(0, 1);
            card->setUserString(user_string);
        }
        card->deleteLater();
        card->setSkillPosition(position);
        return card;
    } else if (str.startsWith(QChar('$'))) {
        QString copy = str;
        copy.remove(QChar('$'));
        QStringList card_strs = copy.split("+");
        DummyCard *dummy = new DummyCard(StringList2IntList(card_strs));
        dummy->deleteLater();
        return dummy;
    } else if (str.startsWith(QChar('#'))) {
        LuaSkillCard *new_card = LuaSkillCard::Parse(str);
        new_card->deleteLater();
        new_card->setSkillPosition(position);
        return new_card;
    } else if (str.contains(QChar('='))) {
        QRegExp pattern("(\\w+):(\\w*)\\[(\\w+):(.+)\\]=(.+)&(.*)");
        if (!pattern.exactMatch(str))
            return NULL;

        QStringList texts = pattern.capturedTexts();
        QString card_name = texts.at(1);
        QString m_skillName = texts.at(2);
        QString suit_string = texts.at(3);
        QString number_string = texts.at(4);
        QString subcard_str = texts.at(5);
        QString show_skill = texts.at(6);
        QStringList subcard_ids;
        if (subcard_str != ".")
            subcard_ids = subcard_str.split("+");

        Suit suit = Card::NoSuit;
        DummyCard *dummy = new DummyCard(StringList2IntList(subcard_ids));
        if (suit_string == "to_be_decided")
            suit = dummy->getSuit();
        else
            suit = suit_map.value(suit_string, Card::NoSuit);
        dummy->deleteLater();

        int number = 0;
        if (number_string == "A")
            number = 1;
        else if (number_string == "J")
            number = 11;
        else if (number_string == "Q")
            number = 12;
        else if (number_string == "K")
            number = 13;
        else
            number = number_string.toInt();

        Card *card = Sanguosha->cloneCard(card_name, suit, number);
        if (card == NULL)
            return NULL;

        card->addSubcards(StringList2IntList(subcard_ids));
        card->setSkillName(m_skillName);
        card->setShowSkill(show_skill);
        card->deleteLater();
        card->setSkillPosition(position);
        return card;
    } else {
        bool ok;
        int card_id = str.toInt(&ok);
        if (ok)
            return Sanguosha->getCard(card_id)->getRealCard();
        else
            return NULL;
    }
}

Card *Card::Clone(const Card *card)
{
    Card::Suit suit = card->getSuit();
    int number = card->getNumber();

    QObject *card_obj = NULL;
    if (card->isKindOf("LuaBasicCard")) {
        const LuaBasicCard *lcard = qobject_cast<const LuaBasicCard *>(card);
        Q_ASSERT(lcard != NULL);
        card_obj = lcard->clone();
    } else if (card->isKindOf("LuaTrickCard")) {
        const LuaTrickCard *lcard = qobject_cast<const LuaTrickCard *>(card);
        Q_ASSERT(lcard != NULL);
        card_obj = lcard->clone();
    } else if (card->isKindOf("LuaWeapon")) {
        const LuaWeapon *lcard = qobject_cast<const LuaWeapon *>(card);
        Q_ASSERT(lcard != NULL);
        card_obj = lcard->clone();
    } else if (card->isKindOf("LuaArmor")) {
        const LuaArmor *lcard = qobject_cast<const LuaArmor *>(card);
        Q_ASSERT(lcard != NULL);
        card_obj = lcard->clone();
    } else if (card->isKindOf("LuaTreasure")) {
        const LuaTreasure *lcard = qobject_cast<const LuaTreasure *>(card);
        Q_ASSERT(lcard != NULL);
        card_obj = lcard->clone();
    } else {
        const QMetaObject *meta = card->metaObject();
        card_obj = meta->newInstance(Q_ARG(Card::Suit, suit), Q_ARG(int, number));
    }
    if (card_obj) {
        Card *new_card = qobject_cast<Card *>(card_obj);
        new_card->setId(card->getId());
        new_card->setObjectName(card->objectName());
        new_card->addSubcard(card->getId());
        new_card->setTransferable(card->isTransferable());
        return new_card;
    } else
        return NULL;
}

bool Card::targetFixed() const
{
    return target_fixed;
}

bool Card::targetsFeasible(const QList<const Player *> &targets, const Player *) const
{
    if (target_fixed)
        return true;
    else
        return !targets.isEmpty();
}

bool Card::targetRated(const Player *to_select, const Player *Self) const
{
    return to_select != Self;
}

bool Card::targetFilter(const QList<const Player *> &targets, const Player *to_select, const Player *Self) const
{
    return targets.isEmpty() && targetRated(to_select, Self);
}

bool Card::targetFilter(const QList<const Player *> &targets, const Player *to_select, const Player *Self, int &maxVotes) const
{
    bool canSelect = targetFilter(targets, to_select, Self);
    maxVotes = canSelect ? 1 : 0;
    return canSelect;
}

void Card::doPreAction(Room *, const CardUseStruct &) const
{
}

void Card::onUse(Room *room, const CardUseStruct &use) const
{
    CardUseStruct card_use = use;
    ServerPlayer *player = card_use.from;

    if (!card_use.card->getSkillPosition().isEmpty()) {                //for serveral purpose. by weidouncle
        QStringList skill_positions = room->getTag(card_use.card->getSkillName(true) + player->objectName()).toStringList();
        skill_positions.append(card_use.card->getSkillPosition());
        room->setTag(card_use.card->getSkillName(true) + player->objectName(), skill_positions);
    }
    room->sortByActionOrder(card_use.to);

    bool hidden = (card_use.card->getTypeId() == TypeSkill && !card_use.card->willThrow());
    LogMessage log;
    log.from = player;
    if (!card_use.card->targetFixed() || card_use.to.length() > 1 || !card_use.to.contains(card_use.from))
        log.to = card_use.to;
    log.type = "#UseCard";
    log.card_str = card_use.card->toString(hidden);
    room->sendLog(log);

    if (card_use.card->isKindOf("Collateral")) { // put it here for I don't wanna repeat these codes in Card::onUse
        ServerPlayer *victim = card_use.to.first()->tag["collateralVictim"].value<ServerPlayer *>();
        if (victim) {
            LogMessage log;
            log.type = "#CollateralSlash";
            log.from = card_use.from;
            log.to << victim;
            room->sendLog(log);
            room->doAnimate(QSanProtocol::S_ANIMATE_INDICATE, card_use.to.first()->objectName(), victim->objectName());
        }
    }

    QList<int> used_cards;
    QList<CardsMoveStruct> moves;
    if (card_use.card->isVirtualCard())
        used_cards.append(card_use.card->getSubcards());
    else
        used_cards << card_use.card->getEffectiveId();

    QVariant data = QVariant::fromValue(card_use);
    RoomThread *thread = room->getThread();
    Q_ASSERT(thread != NULL);
    thread->trigger(PreCardUsed, room, player, data);
    card_use = data.value<CardUseStruct>();

    room->setPlayerFlag(card_use.from, "HuanshenSkillChecking");
    if (card_use.card->getTypeId() != TypeSkill) {
        QString general;
        if (!card_use.card->getSkillPosition().isEmpty())
            general = card_use.card->getSkillPosition() == "left" ? player->getActualGeneral1Name() : player->getActualGeneral2Name();
        CardMoveReason reason(CardMoveReason::S_REASON_USE, player->objectName(), QString(), card_use.card->getSkillName(), general);
        if (card_use.to.size() == 1)
            reason.m_targetId = card_use.to.first()->objectName();
        reason.m_useStruct = card_use;
        foreach (int id, used_cards) {
            CardsMoveStruct move(id, NULL, Player::PlaceTable, reason);
            moves.append(move);
        }
        room->moveCardsAtomic(moves, true);
        // show general
        player->showSkill(card_use.card->showSkill(), card_use.card->getSkillPosition());                           //new function by weidouncle
    } else {
        const SkillCard *skill_card = qobject_cast<const SkillCard *>(card_use.card);
        if (skill_card)
            skill_card->extraCost(room, card_use);

        // show general
        player->showSkill(card_use.card->showSkill(), card_use.card->getSkillPosition());                           //new function by weidouncle

    }

    room->setPlayerFlag(card_use.from, "-HuanshenSkillChecking");
    if (!card_use.card->showSkill().isEmpty() && player->hasShownSkill("huashen"))
        room->dropHuashenCardbySkillName(player, card_use.card->showSkill());


    QStringList card_names, kingdoms;
    card_names << "RuleTheWorld" << "Conquering" << "ConsolidateCountry" << "Chaos";
    kingdoms << "wei" << "shu" << "wu" << "qun";
    QString card_name = card_use.card->getClassName();

    if (card_names.contains(card_name) && player->isAlive()) {

        QString kingdom = kingdoms.at(card_names.indexOf(card_name));

        if (!player->hasShownOneGeneral() && (player->canShowGeneral("h") || player->canShowGeneral("d"))) {
            QStringList choices;

            if (player->getKingdom() == kingdom) {
                ServerPlayer *lord = room->getLord(kingdom, true);
                bool can_show = (lord && lord->isAlive());
                if (lord == NULL) {
                    int num = 0;
                    QList<ServerPlayer *> all_players = room->getAllPlayers(true);
                    foreach (ServerPlayer *p, all_players) {
                        if (p->hasShownOneGeneral() && p->getRole() != "careerist" && p->getKingdom() == kingdom)
                            num++;
                    }
                    if (num < room->getPlayers().length() / 2)
                        can_show = true;
                }
                if (can_show) {
                    if (player->canShowGeneral("h") && player->getActualGeneral1()->getKingdom() != "careerist")
                        choices << "show_head";
                    if (player->canShowGeneral("d"))
                        choices << "show_deputy";
                }
            }

            choices << "cancel";

            QString choice = room->askForChoice(player, "trick_show", choices.join("+"), data,
                    "@trick-show:::"+use.card->objectName(), "show_head+show_deputy+cancel");

            if (choice == "show_head")
                player->showGeneral();
            else if (choice == "show_deputy")
                player->showGeneral(false);
        }

        if (use.from->getSeemingKingdom() == kingdom) {
            setFlags("CompleteEffect");
        }
    }

    if (!hasFlag("slashDisableExtraTarget"))
        thread->trigger(TargetSelected, room, player, data);

    thread->trigger(CardUsed, room, player, data);
    thread->trigger(CardFinished, room, player, data);

    QList<int> table_cardids = room->getCardIdsOnTable(this);
    if (!table_cardids.isEmpty()) {
        DummyCard dummy(table_cardids);
        CardMoveReason reason(CardMoveReason::S_REASON_USE, player->objectName(), QString(), this->getSkillName(), this->objectName());
        if (card_use.to.size() == 1) reason.m_targetId = card_use.to.first()->objectName();
        reason.m_useStruct = card_use;
        room->moveCardTo(&dummy, player, NULL, Player::DiscardPile, reason, true);
    }

    if (!card_use.card->getSkillPosition().isEmpty()) {
        QStringList skill_positions = room->getTag(card_use.card->getSkillName(true) + player->objectName()).toStringList();        //remove this record when finish
        if (!skill_positions.isEmpty()) {
            skill_positions.removeLast();
            room->setTag(card_use.card->getSkillName(true) + player->objectName(), skill_positions);
        }
    }
}

void Card::use(Room *room, ServerPlayer *source, QList<ServerPlayer *> &targets) const
{
    QStringList nullified_list = room->getTag("CardUseNullifiedList").toStringList();
    bool all_nullified = nullified_list.contains("_ALL_TARGETS");

    foreach (ServerPlayer *target, targets) {
        CardEffectStruct effect;
        effect.card = this;
        effect.from = source;
        effect.to = target;
        effect.multiple = (targets.length() > 1);
        effect.nullified = (all_nullified || nullified_list.contains(target->objectName()));

        QVariantList players;
        for (int i = targets.indexOf(target); i < targets.length(); i++) {
            if (!nullified_list.contains(targets.at(i)->objectName()) && !all_nullified)
                players.append(QVariant::fromValue(targets.at(i)));
        }
        room->setTag("targets" + this->toString(), QVariant::fromValue(players));

        room->cardEffect(effect);
    }

    room->removeTag("targets" + this->toString());
}

void Card::onEffect(const CardEffectStruct &) const
{
}

bool Card::isCancelable(const CardEffectStruct &) const
{
    return false;
}

QString Card::showSkill() const
{
    return show_skill;
}

void Card::setShowSkill(const QString &skill_name)
{
    show_skill = skill_name;
}

void Card::addSubcard(int card_id)
{
    if (card_id < 0)
        qWarning("%s", qPrintable(tr("Subcard must not be virtual card!")));
    else
        subcards << card_id;
}

void Card::addSubcard(const Card *card)
{
    //addSubcard(card->getEffectiveId());
    if (!card->isVirtualCard())
        addSubcard(card->getId());
    else
        addSubcards(card->getSubcards());
}

QList<int> Card::getSubcards() const
{
    return subcards;
}

void Card::clearSubcards()
{
    subcards.clear();
}

bool Card::isAvailable(const Player *player) const
{
    return !player->isCardLimited(this, handling_method)
        || (can_recast && !player->isCardLimited(this, Card::MethodRecast));
}

const Card *Card::validate(CardUseStruct &) const
{
    return this;
}

const Card *Card::validateInResponse(ServerPlayer *) const
{
    return this;
}

void Card::validateAfter(CardUseStruct &) const
{

}

void Card::validateInResponseAfter(ServerPlayer *) const
{

}

bool Card::isMute() const
{
    return mute;
}

bool Card::willThrow() const
{
    return will_throw;
}

bool Card::canRecast() const
{
    return can_recast;
}

bool Card::hasPreAction() const
{
    return has_preact;
}

Card::HandlingMethod Card::getHandlingMethod() const
{
    return handling_method;
}

void Card::setCanRecast(bool can)
{
    can_recast = can;
}

void Card::setFlags(const QString &flag) const
{
    static char symbol_c = '-';

    if (flag.isEmpty())
        return;
    else if (flag == ".")
        flags.clear();
    else if (flag.startsWith(symbol_c)) {
        QString copy = flag;
        copy.remove(symbol_c);
        flags.removeOne(copy);
    } else if (!flags.contains(flag))
        flags << flag;
}

bool Card::hasFlag(const QString &flag) const
{
    return flags.contains(flag);
}

void Card::clearFlags() const
{
    flags.clear();
}

void Card::setTag(const QString &key, const QVariant &data) const
{
    tag[key] = data;
}

void Card::removeTag(const QString &key) const
{
    tag.remove(key);
}

void Card::copyFrom(const Card *card)
{
    Q_ASSERT(card != this);
    m_suit = card->getSuit();
    m_number = card->getNumber();
    subcards = card->getSubcards();
    m_skillName = card->getSkillName(false);
    flags = card->getFlags();
    tag = QVariantMap(card->tag);
}

// ---------   Skill card     ------------------

SkillCard::SkillCard() : Card(NoSuit, 0)
{
}

void SkillCard::setUserString(const QString &user_string)
{
    this->user_string = user_string;
}

QString SkillCard::getUserString() const
{
    return user_string;
}

QString SkillCard::getType() const
{
    return "skill_card";
}

QString SkillCard::getSubtype() const
{
    return "skill_card";
}

Card::CardType SkillCard::getTypeId() const
{
    return Card::TypeSkill;
}

QString SkillCard::toString(bool hidden) const
{
    QString str;
    if (!hidden)
        str = QString("@%1[%2:%3]=%4&%5")
        .arg(metaObject()->className()).arg(getSuitString())
        .arg(getNumberString()).arg(subcardString()).arg(show_skill);
    else
        str = QString("@%1[no_suit:-]=.&%2").arg(metaObject()->className()).arg(show_skill);

    if (!user_string.isEmpty())
        return QString("%1:%2").arg(str).arg(user_string);
    else
        return str;
}

void SkillCard::extraCost(Room *room, const CardUseStruct &card_use) const
{
    if (card_use.card->willThrow()) {
        QString general;
        if (!card_use.card->getSkillPosition().isEmpty())
            general = card_use.card->getSkillPosition() == "left" ? card_use.from->getActualGeneral1Name() : card_use.from->getActualGeneral2Name();
        CardMoveReason reason(CardMoveReason::S_REASON_THROW, card_use.from->objectName(), QString(), card_use.card->getSkillName(), general);
        room->moveCardTo(this, card_use.from, NULL, Player::DiscardPile, reason, true);
    }
}

// ---------- Dummy card      -------------------

DummyCard::DummyCard() : SkillCard()
{
    target_fixed = true;
    handling_method = Card::MethodNone;
    setObjectName("dummy");
}

DummyCard::DummyCard(const QList<int> &subcards) : SkillCard()
{
    target_fixed = true;
    handling_method = Card::MethodNone;
    setObjectName("dummy");
    foreach(int id, subcards)
        this->subcards.append(id);
}

QString DummyCard::getType() const
{
    return "dummy_card";
}

QString DummyCard::getSubtype() const
{
    return "dummy_card";
}

QString DummyCard::toString(bool hidden) const
{
    Q_UNUSED(hidden)
        return "$" + subcardString();
}

ArraySummonCard::ArraySummonCard(const QString &name)
    : SkillCard()
{
    setObjectName(name);
    m_skillName = name;
    mute = true;
    target_fixed = true;
    handling_method = Card::MethodNone;
}

const Card *ArraySummonCard::validate(CardUseStruct &card_use) const
{
    const BattleArraySkill *skill = qobject_cast<const BattleArraySkill *>(Sanguosha->getTriggerSkill(objectName()));
    if (skill) {
        card_use.from->showSkill(skill->objectName(), card_use.card->getSkillPosition());                           //new function by weidouncle

        QString name = objectName();
        name[0] = name[0].toUpper();
        name += "SummonCard";
        card_use.from->getRoom()->addPlayerHistory(card_use.from, name);

        skill->summonFriends(card_use.from);
    }
    return NULL;
}

ShowDistanceCard::ShowDistanceCard()
    : SkillCard()
{
    mute = true;
    target_fixed = true;
    handling_method = Card::MethodNone;
}

const Card *ShowDistanceCard::validate(CardUseStruct &card_use) const
{
    QString skill_name = showSkill();   //damn it again!
    const Skill *skill = Sanguosha->getSkill(skill_name);
    if (skill) {
        card_use.from->showGeneral(card_use.from->inHeadSkills(skill));
    }
    return NULL;
}

TransferCard::TransferCard()
{
    will_throw = false;
    mute = true;
    handling_method = Card::MethodNone;
}

bool TransferCard::targetFilter(const QList<const Player *> &targets, const Player *to_select, const Player *Self) const
{
    if (!targets.isEmpty() || to_select == Self)
        return false;
    if (!Self->hasShownOneGeneral())
        return !to_select->hasShownOneGeneral();
    return !to_select->isFriendWith(Self);
}

void TransferCard::onEffect(const CardEffectStruct &effect) const
{
    bool draw = effect.to->hasShownOneGeneral();
    CardMoveReason reason(CardMoveReason::S_REASON_GIVE, effect.from->objectName(), effect.to->objectName(), "transfer", QString());
    effect.to->getRoom()->obtainCard(effect.to, this, reason);
    if (draw)
        effect.from->drawCards(subcardsLength(), "transfer");
}
