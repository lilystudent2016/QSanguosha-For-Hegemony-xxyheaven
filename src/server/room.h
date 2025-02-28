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

#ifndef _ROOM_H
#define _ROOM_H

class TriggerSkill;
class ProhibitSkill;
class Scenario;
class TrickCard;
class GeneralSelector;
class RoomThread;

struct lua_State;
struct LogMessage;

#include "serverplayer.h"
#include "protocol.h"
#include "roomstate.h"

#include <QMutex>
#include <QStack>
#include <QWaitCondition>
#include <QThread>

typedef QMap<const ServerPlayer *, QStringList> SPlayerDataMap;

typedef int LuaFunction;

class Room : public QThread
{
    Q_OBJECT
    Q_ENUMS(GuanxingType)
    Q_ENUMS(ChoosingType)

public:
    enum GuanxingType
    {
        GuanxingUpOnly = 1, GuanxingBothSides = 0, GuanxingDownOnly = -1
    };

    enum ChoosingType
    {
        OnebyOne = 0, NoLimited = 1
    };

    friend class RoomThread;

    typedef void (Room::*Callback)(ServerPlayer *, const QVariant &);
    typedef bool (Room::*ResponseVerifyFunction)(ServerPlayer *, const QVariant &, void *);

    explicit Room(QObject *parent, const QString &mode);
    ~Room();
    ServerPlayer *addSocket(ClientSocket *socket);
    inline int getId() const
    {
        return _m_Id;
    }
    bool isFull() const;
    bool isFinished() const;
    bool canPause(ServerPlayer *p) const;
    void tryPause();
    int getLack() const;
    QString getMode() const;
    const Scenario *getScenario() const;
    RoomThread *getThread() const;
    ServerPlayer *getCurrent() const;
    void setCurrent(ServerPlayer *current);
    int alivePlayerCount() const;
    QList<ServerPlayer *> getOtherPlayers(ServerPlayer *except, bool include_dead = false) const;
    QList<ServerPlayer *> getPlayers() const;
    QList<ServerPlayer *> getAllPlayers(bool include_dead = false) const;
    QList<ServerPlayer *> getAlivePlayers() const;
    void output(const QString &message);
    void outputEventStack();
    void enterDying(ServerPlayer *player, DamageStruct *reason);
    ServerPlayer *getCurrentDyingPlayer() const;
    void killPlayer(ServerPlayer *victim, DamageStruct *reason = NULL);
    void revivePlayer(ServerPlayer *player);
    QStringList aliveRoles(ServerPlayer *except = NULL) const;
    void enterBattleRoyalMode();
    void gameOver(const QString &winner);
    void slashEffect(const SlashEffectStruct &effect);
    void slashResult(const SlashEffectStruct &effect, const Card *jink);
    void attachSkillToPlayer(ServerPlayer *player, const QString &skill_name);
    void detachSkillFromPlayer(ServerPlayer *player, const QString &skill_name, bool is_equip = false, bool acquire_only = false, bool head = true);
    void handleAcquireDetachSkills(ServerPlayer *player, const QStringList &skill_names, bool acquire_only = false);
    void handleAcquireDetachSkills(ServerPlayer *player, const QString &skill_names, bool acquire_only = false);
    void setPlayerFlag(ServerPlayer *player, const QString &flag);
    void setPlayerProperty(ServerPlayer *player, const char *property_name, const QVariant &value);
    void setPlayerMark(ServerPlayer *player, const QString &mark, int value);
    void addPlayerMark(ServerPlayer *player, const QString &mark, int add_num = 1);
    void removePlayerMark(ServerPlayer *player, const QString &mark, int remove_num = 1);
    void addPlayerTip(ServerPlayer *player, const QString &mark);
    void setPlayerCardLimitation(ServerPlayer *player, const QString &limit_list, const QString &pattern, bool single_turn);
    void removePlayerCardLimitation(ServerPlayer *player, const QString &limit_list, const QString &pattern);
    void clearPlayerCardLimitation(ServerPlayer *player, bool single_turn);
    void setPlayerDisableShow(ServerPlayer *player, const QString &flags, const QString &reason);
    void removePlayerDisableShow(ServerPlayer *player, const QString &reason);
    void setCardFlag(const Card *card, const QString &flag, ServerPlayer *who = NULL);
    void setCardFlag(int card_id, const QString &flag, ServerPlayer *who = NULL);
    void clearCardFlag(const Card *card, ServerPlayer *who = NULL);
    void clearCardFlag(int card_id, ServerPlayer *who = NULL);
    bool useCard(const CardUseStruct &card_use, bool add_history = true);
    void damage(const DamageStruct &data);
    void sendDamageLog(const DamageStruct &data);
    void loseHp(ServerPlayer *victim, int lose = 1);
    void loseMaxHp(ServerPlayer *victim, int lose = 1);
    void applyDamage(ServerPlayer *victim, const DamageStruct &damage);
    void recover(ServerPlayer *player, const RecoverStruct &recover, bool set_emotion = false);
    bool cardEffect(const Card *card, ServerPlayer *from, ServerPlayer *to, bool multiple = false);
    bool cardEffect(const CardEffectStruct &effect);
    bool isJinkEffected(ServerPlayer *user, const Card *jink);
    void judge(JudgeStruct &judge_struct);
    void sendJudgeResult(const JudgeStruct *judge);
    QList<int> getNCards(int n, bool update_pile_number = true, bool from_up = true);
    ServerPlayer *getLord(const QString &kingdom, bool include_death = false) const;
    AskForMoveCardsStruct askForArrangeCards(ServerPlayer *zhuge, const QList<int> &cards, GuanxingType guanxing_type = GuanxingBothSides);
    void guanxingFinish(ServerPlayer *zhuge, const QList<int> &upcards, const QList<int> &downcards);
    void askForGuanxing(ServerPlayer *zhuge, const QList<int> &cards, GuanxingType guanxing_type = GuanxingBothSides);
    AskForMoveCardsStruct askForMoveCards(ServerPlayer *zhuge, const QList<int> &upcards, const QList<int> &downcards, bool visible, const QString &reason,
        const QString &pattern, const QString &skillName, int min_num, int max_num, bool can_refuse = true, bool moverestricted = false,const QList<int> &notify_visible_list = QList<int>());
    void returnToTopDrawPile(const QList<int> &cards);
    void returnCardToDrawPile(int card_id, int index = 0);
    int getRandomCardInPile(QString pattern, bool drawpile);
    int doGongxin(ServerPlayer *shenlvmeng, ServerPlayer *target, QList<int> enabled_ids = QList<int>(), const QString &skill_name = "shangyi");
    int drawCard(bool from_up = true);
    void fillAG(const QList<int> &card_ids, ServerPlayer *who = NULL, const QList<int> &disabled_ids = QList<int>(), QList<ServerPlayer *> watchers = QList<ServerPlayer *>());
    void takeAG(ServerPlayer *player, int card_id, bool move_cards = true);
    void clearAG(ServerPlayer *player = NULL);
    void provide(const Card *card);
    QList<ServerPlayer *> getLieges(const QString &kingdom, ServerPlayer *lord) const;
    void sendLog(const LogMessage &log, QList<ServerPlayer *> players = QList<ServerPlayer *>());
    void sendLog(const LogMessage &log, ServerPlayer *player);
    void sendCompulsoryTriggerLog(ServerPlayer *player, const QString &skill_name, bool notify_skill = true);
    void showCard(ServerPlayer *player, int card_id, ServerPlayer *only_viewer = NULL);
    void showCard(ServerPlayer *player, QList<int> card_ids, ServerPlayer *only_viewer = NULL);
    void showAllCards(ServerPlayer *player, ServerPlayer *to = NULL);
    void retrial(const Card *card, ServerPlayer *player, JudgeStruct *judge, const QString &skill_name, bool exchange = false); //retrial move only, dont really do the retrial

    // these 2 functions puts here, for convenience
    static void cancelTarget(CardUseStruct &use, const QString &name);
    static void cancelTarget(CardUseStruct &use, ServerPlayer *player);

    QList<ServerPlayer *> getUseExtraTargets(CardUseStruct card_use, bool distance_limited = true);
    QList<ServerPlayer *> getUseAliveTargets(CardUseStruct card_use);

    // Ask a player to send a server request and returns the client response. Call is blocking until client
    // replies or server times out, whichever is earlier.
    // @param player
    //        The server player to carry out the command.
    // @param command
    //        Command to be executed on client side.
    // @param arg
    //        Command args.
    // @param timeOut
    //        Maximum milliseconds that server should wait for client response before returning.
    // @param wait
    //        If true, return immediately after sending the request without waiting for client reply.
    // @return True if the a valid response is returned from client.
    // Usage note: when you need a round trip request-response vector with a SINGLE client, use this command
    // with wait = true and read the reponse from player->getClientReply(). If you want to initiate a poll
    // where more than one clients can respond simultaneously, you have to do it in two steps:
    // 1. Use this command with wait = false once for each client involved in the poll (or you can call this
    //    command only once in all with broadcast = true if the poll is to everypody).
    // 2. Call getResult(player, timeout) on each player to retrieve the result. Read manual for getResults
    //    before you use.
    bool doRequest(ServerPlayer *player, QSanProtocol::CommandType command, const QVariant &arg, time_t timeOut, bool wait);
    bool doRequest(ServerPlayer *player, QSanProtocol::CommandType command, const QVariant &arg, bool wait);

    // Broadcast a request to a list of players and get the client responses. Call is blocking until all client
    // replies or server times out, whichever is earlier. Check each player's m_isClientResponseReady to see if a valid
    // result has been received. The client response can be accessed by calling each player's getClientReply() function.
    // @param players
    //        The list of server players to carry out the command.
    // @param command
    //        Command to be executed on client side. Command arguments should be stored in players->m_commandArgs.
    // @param timeOut
    //        Maximum total milliseconds that server will wait for all clients to respond before returning. Any client
    //        response after the timeOut will be rejected.
    // @return True if the a valid response is returned from client.
    bool doBroadcastRequest(QList<ServerPlayer *> &players, QSanProtocol::CommandType command, time_t timeOut);
    bool doBroadcastRequest(QList<ServerPlayer *> &players, QSanProtocol::CommandType command);

    // Broadcast a request to a list of players and get the first valid client response. Call is blocking until the first
    // client response is received or server times out, whichever is earlier. Any client response is verified by the validation
    // function and argument passed in. When a response is verified to be invalid, the function will continue to wait for
    // the next client response.
    // @param validateFunc
    //        Validation function that verifies whether the reply is a valid one. The first parameter passed to the function
    //        is the response sender, the second parameter is the response content, the third parameter is funcArg passed in.
    // @return The player that first send a legal request to the server. NULL if no such request is received.
    ServerPlayer *doBroadcastRaceRequest(QList<ServerPlayer *> &players, QSanProtocol::CommandType command,
        time_t timeOut, ResponseVerifyFunction validateFunc = NULL, void *funcArg = NULL);

    // Notify a player of a event by sending S_SERVER_NOTIFICATION packets. No reply should be expected from
    // the client for S_SERVER_NOTIFICATION as it's a one way notice. Any message from the client in reply to this call
    // will be rejected.
    bool doNotify(ServerPlayer *player, QSanProtocol::CommandType command, const QVariant &arg);

    // Broadcast a event to a list of players by sending S_SERVER_NOTIFICATION packets. No replies should be expected from
    // the clients for S_SERVER_NOTIFICATION as it's a one way notice. Any message from the client in reply to this call
    // will be rejected.
    bool doBroadcastNotify(QSanProtocol::CommandType command, const QVariant &arg, ServerPlayer *except = NULL);
    bool doBroadcastNotify(const QList<ServerPlayer *> &players, QSanProtocol::CommandType command, const QVariant &arg);

    bool doNotify(ServerPlayer *player, int command, const char *arg);
    bool doBroadcastNotify(int command, const char *arg);
    bool doBroadcastNotify(const QList<ServerPlayer *> &players, int command, const char *arg);

    bool doNotify(ServerPlayer *player, int command, const QVariant &arg);
    bool doBroadcastNotify(int command, const QVariant &arg);
    bool doBroadcastNotify(const QList<ServerPlayer *> &players, int command, const QVariant &arg);

    // Ask a server player to wait for the client response. Call is blocking until client replies or server times out,
    // whichever is earlier.
    // @param player
    //        The server player to retrieve the client response.
    // @param timeOut
    //        Maximum milliseconds that server should wait for client response before returning.
    // @return True if the a valid response is returned from client.

    // Usage note: this function is only supposed to be either internally used by doRequest (wait = true) or externally
    // used in pair with doRequest (wait = false). Any other usage could result in unexpected synchronization errors.
    // When getResult returns true, it's guaranteed that the expected client response has been stored and can be accessed by
    // calling player->getClientReply(). If getResult returns false, the value stored in player->getClientReply() could be
    // corrupted or in response to an unrelevant server request. Therefore, if the return value is false, do not poke into
    // player->getClientReply(), use the default value directly. If the return value is true, the reply value should still be
    // examined as a malicious client can have tampered with the content of the package for cheating purposes.
    bool getResult(ServerPlayer *player, time_t timeOut);
    ServerPlayer *getRaceResult(QList<ServerPlayer *> &players, QSanProtocol::CommandType command, time_t timeOut,
        ResponseVerifyFunction validateFunc = NULL, void *funcArg = NULL);

    // Verification functions
    bool verifyNullificationResponse(ServerPlayer *, const QVariant &, void *);

    // Notification functions
    bool notifyMoveFocus(ServerPlayer *focus);
    bool notifyMoveFocus(ServerPlayer *focus, QSanProtocol::CommandType command);
    bool notifyMoveFocus(const QList<ServerPlayer *> &focuses, const QSanProtocol::Countdown &countdown, ServerPlayer *except = NULL);

    // Notify client side to move cards from one place to another place. A movement should always be completed by
    // calling notifyMoveCards in pairs, one with isLostPhase equaling true followed by one with isLostPhase
    // equaling false. The two phase design is needed because the target player doesn't necessarily gets the
    // cards that the source player lost. Any trigger during the movement can cause either the target player to
    // be dead or some of the cards to be moved to another place before the target player actually gets it.
    // @param isLostPhase
    //        Specify whether this is a S_COMMAND_LOSE_CARD notification.
    // @param move
    //        Specify all movements need to be broadcasted.
    // @param forceVisible
    //        If true, all players will be able to see the face of card regardless of whether the movement is
    //        relevant or not.
    bool notifyMoveCards(bool isLostPhase, QList<CardsMoveStruct> move, bool forceVisible, QList<ServerPlayer *> players = QList<ServerPlayer *>());
    bool notifyProperty(ServerPlayer *playerToNotify, const ServerPlayer *propertyOwner, const char *propertyName, QString value = QString());
    bool notifyUpdateCard(ServerPlayer *player, int cardId, const Card *newCard);
    bool broadcastUpdateCard(const QList<ServerPlayer *> &players, int cardId, const Card *newCard);
    bool notifyResetCard(ServerPlayer *player, int cardId);
    bool broadcastResetCard(const QList<ServerPlayer *> &players, int cardId);

    bool broadcastProperty(ServerPlayer *player, const char *property_name, const QString &value = QString());
    void notifySkillInvoked(ServerPlayer *player, const QString &skill_name);
    void broadcastSkillInvoke(const QString &skillName, const ServerPlayer *who = NULL);
    void broadcastSkillInvoke(const QString &skillName, const QString &category);
    void broadcastSkillInvoke(const QString &skillName, int type, const ServerPlayer *who = NULL);
    void broadcastSkillInvoke(const QString &skillName, bool isMale, int type);
    void broadcastSkillInvoke(const QString &skillName, const QString &category, int type, const ServerPlayer *who = NULL, const QString &position = QString());
    void doLightbox(const QString &lightboxName, int duration = 2000);
    void doSuperLightbox(const QString &heroName, const QString &skillName);
    void doAnimate(QSanProtocol::AnimateType type, const QString &arg1 = QString(), const QString &arg2 = QString(),
        QList<ServerPlayer *> players = QList<ServerPlayer *>());

    inline void doAnimate(int type, const QString &arg1 = QString(), const QString &arg2 = QString(),
        QList<ServerPlayer *> players = QList<ServerPlayer *>())
    {
        doAnimate((QSanProtocol::AnimateType)type, arg1, arg2, players);
    }

    void doBattleArrayAnimate(ServerPlayer *player, ServerPlayer *target = NULL);
    void preparePlayers();
    void changePlayerGeneral(ServerPlayer *player, const QString &new_general);
    void changePlayerGeneral2(ServerPlayer *player, const QString &new_general);
    void filterCards(ServerPlayer *player, QList<const Card *> cards, bool refilter);

    void acquireSkill(ServerPlayer *player, const Skill *skill, bool open = true, bool head = true);
    void acquireSkill(ServerPlayer *player, const QString &skill_name, bool open = true, bool head = true);
    void adjustSeats();
    void swapPile();
    QList<int> getDiscardPile();
    inline QList<int> &getDrawPile()
    {
        return *m_drawPile;
    }
    inline const QList<int> &getDrawPile() const
    {
        return *m_drawPile;
    }
    inline QStringList getUsedGeneral()
    {
        return used_general;
    }
    void handleUsedGeneral(const QString &general);
    bool dropHuashenCard(ServerPlayer *p, const QString &name);
    bool dropHuashenCardbySkillName(ServerPlayer *p, const QString &name);
    int getCardFromPile(const QString &card_name);
    ServerPlayer *findPlayer(const QString &general_name, bool include_dead = false) const;
    QList<ServerPlayer *> findPlayersBySkillName(const QString &skill_name) const;
    ServerPlayer *findPlayerBySkillName(const QString &skill_name) const;
    ServerPlayer *findPlayerbyobjectName(const QString &objectname, bool include_dead = false) const;
    void installEquip(ServerPlayer *player, const QString &equip_name);
    void resetAI(ServerPlayer *player);
    void doDragonPhoenix(ServerPlayer *target, const QString &general1_name, const QString &general2_name, bool full_state = true,
                         const QString &kingdom = QString(), bool sendLog = true, const QString &show_flags = QString(), bool resetHp = false);
    void transformDeputyGeneral(ServerPlayer *player, const QString &general_name = QString(), bool show = true);
    void swapSeat(ServerPlayer *a, ServerPlayer *b);
    lua_State *getLuaState() const;
    void setFixedDistance(Player *from, const Player *to, int distance);
    ServerPlayer *getFront(ServerPlayer *a, ServerPlayer *b) const;
    void signup(ServerPlayer *player, const QString &screen_name, const QString &avatar, bool is_robot);
    ServerPlayer *getOwner() const;
    void updateStateItem();

    void reconnect(ServerPlayer *player, ClientSocket *socket);
    void marshal(ServerPlayer *player);

    void sortByActionOrder(QList<ServerPlayer *> &players);

    const ProhibitSkill *isProhibited(const Player *from, const Player *to, const Card *card, const QList<const Player *> &others = QList<const Player *>()) const;

    void setTag(const QString &key, const QVariant &value);
    QVariant getTag(const QString &key) const;
    void removeTag(const QString &key);

    void setEmotion(ServerPlayer *target, const QString &emotion, bool playback = false, int duration = 0);
    void setCardEmotion(ServerPlayer *target, const Card *card);

    Player::Place getCardPlace(int card_id) const;
    bool canFindCardPlace(int card_id) const;
    bool isAllOnPlace(const Card *virtual_card, Player::Place place) const;
    bool isAllOnPlace(const QList<int> &card_ids, Player::Place place) const;
    QList<int> getCardIdsOnTable(const Card *) const;
    QList<int> getCardIdsOnTable(const QList<int> &card_ids) const;
    ServerPlayer *getCardOwner(int card_id) const;
    void setCardMapping(int card_id, ServerPlayer *owner, Player::Place place);

    void drawCards(ServerPlayer *player, int n, const QString &reason = QString(), bool from_up = true);
    void drawCards(QList<ServerPlayer *> players, int n, const QString &reason = QString(), bool from_up = true);
    void drawCards(QList<ServerPlayer *> players, QList<int> n_list, const QString &reason = QString(), QList<bool> f_list = QList<bool>());
    void obtainCard(ServerPlayer *target, const Card *card, bool unhide = true);
    void obtainCard(ServerPlayer *target, int card_id, bool unhide = true);
    void obtainCard(ServerPlayer *target, const Card *card, const CardMoveReason &reason, bool unhide = true);

    void throwCard(int card_id, ServerPlayer *who, ServerPlayer *thrower = NULL, const QString &skill_name = QString());
    void throwCard(const Card *card, ServerPlayer *who, ServerPlayer *thrower = NULL, const QString &skill_name = QString());
    void throwCard(const Card *card, const CardMoveReason &reason, ServerPlayer *who, ServerPlayer *thrower = NULL, const QString &skill_name = QString());

    void moveCardTo(const Card *card, ServerPlayer *dstPlayer, Player::Place dstPlace, bool forceMoveVisible = false);
    void moveCardTo(const Card *card, ServerPlayer *dstPlayer, Player::Place dstPlace, const CardMoveReason &reason,
        bool forceMoveVisible = false);
    void moveCardTo(const Card *card, ServerPlayer *srcPlayer, ServerPlayer *dstPlayer, Player::Place dstPlace,
        const CardMoveReason &reason, bool forceMoveVisible = false);
    void moveCardTo(const Card *card, ServerPlayer *srcPlayer, ServerPlayer *dstPlayer, Player::Place dstPlace,
        const QString &pileName, const CardMoveReason &reason, bool forceMoveVisible = false);
    void moveCardsAtomic(QList<CardsMoveStruct> cards_move, bool forceMoveVisible);
    void moveCardsAtomic(CardsMoveStruct cards_move, bool forceMoveVisible);
    void moveCards(CardsMoveStruct cards_move, bool forceMoveVisible, bool ignoreChanges = true);
    void moveCards(QList<CardsMoveStruct> cards_moves, bool forceMoveVisible, bool ignoreChanges = true);

    QList<CardsMoveOneTimeStruct> moveCardsSub(CardsMoveStruct cards_move, bool forceMoveVisible);
    QList<CardsMoveOneTimeStruct> moveCardsSub(QList<CardsMoveStruct> cards_moves, bool forceMoveVisible);

    QVariant changeMoveData(QVariant data, CardsMoveStruct cards_move);
    QVariant changeMoveData(QVariant data, QList<CardsMoveStruct> cards_move);
    QVariant changeMoveData(QVariant data, QList<int> ids);
    QVariant cheakMoveData(QVariant data);

    // interactive methods
    void activate(ServerPlayer *player, CardUseStruct &card_use);
    void askForLuckCard();
    Card::Suit askForSuit(ServerPlayer *player, const QString &reason);
    QString askForKingdom(ServerPlayer *player);
    bool askForSkillInvoke(ServerPlayer *player, const QString &skill_name, const QVariant &data = QVariant(), bool notify_skill = true);
    QString askForChoice(ServerPlayer *player, const QString &skill_name, const QString &choices, const QVariant &data = QVariant(), const QString &prompt = QString(), QString all_choices = QString());
    bool askForDiscard(ServerPlayer *target, const QString &reason, int discard_num, int min_num, bool optional = false, bool include_equip = false, const QString &prompt = QString(), bool notify_skill = false);
    QList<int> askForExchange(ServerPlayer *player, const QString &reason, int exchange_num, int min_num = 0, const QString &prompt = QString(),
        const QString &expand_pile = QString(), const QString &pattern = QString());
    bool askForNullification(const Card *trick, ServerPlayer *from, ServerPlayer *to, bool positive);
    bool isCanceled(const CardEffectStruct &effect);
    int askForCardChosen(ServerPlayer *player, ServerPlayer *who, const QString &flags, const QString &reason,
        bool handcard_visible = false, Card::HandlingMethod method = Card::MethodNone, const QList<int> &disabled_ids = QList<int>());
    QList<int> askForCardsChosen(ServerPlayer *chooser, ServerPlayer *choosee, const QStringList &handle_list,const QString &reason);
    QList<const Card*> askForCardsChosen(ServerPlayer *chooser, ServerPlayer *choosee, const QString &handle_string, const QString &reason);

    const Card *askForCard(ServerPlayer *player, const QString &pattern, const QString &prompt, const QVariant &data, const QString &skill_name);
    const Card *askForCard(ServerPlayer *player, const QString &pattern, const QString &prompt, const QVariant &data = QVariant(),
        Card::HandlingMethod method = Card::MethodDiscard, ServerPlayer *to = NULL, bool isRetrial = false,
        const QString &skill_name = QString(), bool isProvision = false);
    const Card *askForUseCard(ServerPlayer *player, const QString &pattern, const QString &prompt, int notice_index = -1,
        Card::HandlingMethod method = Card::MethodUse, bool addHistory = true);
    const Card *askForUseSlashTo(ServerPlayer *slasher, ServerPlayer *victim, const QString &prompt,
        bool distance_limit = true, bool disable_extra = false, bool addHistory = false);
    const Card *askForUseSlashTo(ServerPlayer *slasher, QList<ServerPlayer *> victims, const QString &prompt,
        bool distance_limit = true, bool disable_extra = false, bool addHistory = false);
    QList<int> GlobalCardChosen(ServerPlayer *player, QList<ServerPlayer *> targets, const QString &flags, const QString &skillName, const QString &prompt, int min = 0, int max = 0,
        ChoosingType type = OnebyOne, bool handcard_visible = false, Card::HandlingMethod method = Card::MethodNone, const QList<int> &disabled_ids = QList<int>(), bool notify_skill = false);
    int askForAG(ServerPlayer *player, const QList<int> &card_ids, bool refusable, const QString &reason);
    const Card *askForCardShow(ServerPlayer *player, ServerPlayer *requestor, const QString &reason);
    bool askForYiji(ServerPlayer *guojia, QList<int> &cards, const QString &skill_name = QString(),
        bool is_preview = false, bool visible = false, bool optional = true, int max_num = -1,
        QList<ServerPlayer *> players = QList<ServerPlayer *>(), CardMoveReason reason = CardMoveReason(),
        const QString &prompt = QString(),const QString &expand_pile = QString(), bool notify_skill = false);
    QList<const Card *> askForPindianRace(ServerPlayer *from, const QList<ServerPlayer *> &to, const QString &reason, const Card *card = NULL);
    ServerPlayer *askForPlayerChosen(ServerPlayer *player, const QList<ServerPlayer *> &targets, const QString &reason,
        const QString &prompt = QString(), bool optional = false, bool notify_skill = false);

    QList<ServerPlayer *> askForPlayersChosen(ServerPlayer *player, const QList<ServerPlayer *> &targets,
                                              const QString &reason,int min_num = 0, int max_num = 2, const QString &prompt = QString(),
                                              bool notify_skill = false);

    QString askForGeneral(ServerPlayer *player, const QStringList &generals, const QString &default_choice = QString(), bool single_result = true, const QString &skill_name = QString(), const QVariant &data = QVariant(), bool can_convert = false, bool same_kingdom = true);
    QString askForGeneral(ServerPlayer *player, const QString &generals, const QString &default_choice = QString(), bool single_result = true, const QString &skill_name = QString(), const QVariant &data = QVariant(), bool can_convert = false);
    const Card *askForSinglePeach(ServerPlayer *player, ServerPlayer *dying);
    QString askForTriggerOrder(ServerPlayer *player, const QString &reason, SPlayerDataMap &skills, bool optional = true, const QVariant &data = QVariant());
    void addPlayerHistory(ServerPlayer *player, const QString &key, int times = 1);

    //just for convenience

    void notifyMoveToPile(ServerPlayer *player, const QList<int> &cards,const QString &reason, Player::Place place, bool in, bool is_visible);

    QList <int> notifyChooseCards(ServerPlayer *player, const QList<int> &cards,
                                  const QString &reason, Player::Place notify_from_place,
                                  Player::Place notify_to_place, int max_num,
                                  int min_num = 0, const QString &prompt = QString(),const QString &pattern = QString());

    //notification callbacks
    void toggleReadyCommand(ServerPlayer *player, const QVariant &);
    void speakCommand(ServerPlayer *player, const QVariant &message);
    void trustCommand(ServerPlayer *player, const QVariant &arg = QVariant());
    void pauseCommand(ServerPlayer *player, const QVariant &arg = QVariant());
    void addRobotCommand(ServerPlayer *player, const QVariant &arg = QVariant());
    void fillRobotsCommand(ServerPlayer *player, const QVariant &arg = QVariant());
    void mirrorGuanxingStepCommand(ServerPlayer *player, const QVariant &arg);
    void mirrorMoveCardsStepCommand(ServerPlayer *player, const QVariant &arg);
    void onPindianReply(ServerPlayer *, const QVariant &arg);
    void changeSkinCommand(ServerPlayer *player, const QVariant &arg);

    void processClientReply(ServerPlayer *player, const QSanProtocol::Packet &packet);

    //cheat commands executed via speakCommand
    QHash<QString, Callback> cheatCommands;
    void broadcastRoles(ServerPlayer *, const QVariant &target);
    void showHandCards(ServerPlayer *player, const QVariant &target);
    void showPrivatePile(ServerPlayer *player, const QVariant &args);
    void setAIDelay(ServerPlayer *, const QVariant &delay);
    void setGameMode(ServerPlayer *, const QVariant &mode);
    void pause(ServerPlayer *player, const QVariant &);
    void resume(ServerPlayer *player, const QVariant &);

    void broadcast(const QSanProtocol::AbstractPacket *packet, ServerPlayer *except = NULL);
    void networkDelayTestCommand(ServerPlayer *player, const QVariant &);
    inline RoomState *getRoomState()
    {
        return &_m_roomState;
    }
    inline Card *getCard(int cardId) const
    {
        return _m_roomState.getCard(cardId);
    }
    inline void resetCard(int cardId)
    {
        _m_roomState.resetCard(cardId);
    }
    void updateCardsOnLose(const CardsMoveStruct &move);
    void updateCardsOnGet(const CardsMoveStruct &move);

    void chooseGenerals(QList<ServerPlayer *> &assign_players, bool has_assign = false, bool is_scenario = false);

protected:
    virtual void run();
    int _m_Id;

private:
    struct _MoveSourceClassifier
    {
        inline _MoveSourceClassifier(const CardsMoveStruct &move)
        {
            m_from = move.from; m_from_place = move.from_place;
            m_from_pile_name = move.from_pile_name; m_from_player_name = move.from_player_name;
        }
        inline void copyTo(CardsMoveStruct &move) const
        {
            move.from = m_from; move.from_place = m_from_place;
            move.from_pile_name = m_from_pile_name; move.from_player_name = m_from_player_name;
        }
        inline bool operator ==(const _MoveSourceClassifier &other) const
        {
            return m_from == other.m_from && m_from_place == other.m_from_place
                && m_from_pile_name == other.m_from_pile_name && m_from_player_name == other.m_from_player_name;
        }
        inline bool operator <(const _MoveSourceClassifier &other) const
        {
            return m_from < other.m_from || m_from_place < other.m_from_place
                || m_from_pile_name < other.m_from_pile_name || m_from_player_name < other.m_from_player_name;
        }
        Player *m_from;
        Player::Place m_from_place;
        QString m_from_pile_name;
        QString m_from_player_name;
    };

    struct _MoveMergeClassifier
    {
        inline _MoveMergeClassifier(const CardsMoveStruct &move)
        {
            m_from = move.from; m_to = move.to;
            m_to_place = move.to_place;
            m_to_pile_name = move.to_pile_name;

            m_origin_from = move.origin_from;
            m_origin_to = move.origin_to;
            m_origin_to_place = move.origin_to_place;
            m_origin_to_pile_name = move.origin_to_pile_name;
        }
        inline bool operator ==(const _MoveMergeClassifier &other) const
        {
            return m_from == other.m_from && m_to == other.m_to
                && m_to_place == other.m_to_place && m_to_pile_name == other.m_to_pile_name;
        }
        inline bool operator < (const _MoveMergeClassifier &other) const
        {
            return m_from < other.m_from || m_to < other.m_to
                || m_to_place < other.m_to_place || m_to_pile_name < other.m_to_pile_name;
        }
        Player *m_from;
        Player *m_to;
        Player::Place m_to_place;
        QString m_to_pile_name;

        Player *m_origin_from;
        Player *m_origin_to;
        Player::Place m_origin_to_place;
        QString m_origin_to_pile_name;
    };

    struct _MoveSeparateClassifier
    {
        inline _MoveSeparateClassifier(const CardsMoveOneTimeStruct &moveOneTime, int index)
        {
            m_from = moveOneTime.from; m_to = moveOneTime.to;
            m_from_place = moveOneTime.from_places[index]; m_to_place = moveOneTime.to_place;
            m_from_pile_name = moveOneTime.from_pile_names[index]; m_to_pile_name = moveOneTime.to_pile_name;
            m_open = moveOneTime.open[index];
            m_reason = moveOneTime.reason;
            m_is_last_handcard = moveOneTime.is_last_handcard;
        }

        inline bool operator ==(const _MoveSeparateClassifier &other) const
        {
            return m_from == other.m_from && m_to == other.m_to
                && m_from_place == other.m_from_place && m_to_place == other.m_to_place
                && m_from_pile_name == other.m_from_pile_name && m_to_pile_name == other.m_to_pile_name
                && m_open == other.m_open && m_reason == other.m_reason && m_is_last_handcard == other.m_is_last_handcard;
        }
        inline bool operator < (const _MoveSeparateClassifier &other) const
        {
            return m_from < other.m_from && m_to < other.m_to
                && m_from_place < other.m_from_place && m_to_place < other.m_to_place
                && m_from_pile_name < other.m_from_pile_name && m_to_pile_name < other.m_to_pile_name
                && m_open < other.m_open && m_is_last_handcard < other.m_is_last_handcard;
        }
        Player *m_from;
        Player *m_to;
        Player::Place m_from_place, m_to_place;
        QString m_from_pile_name, m_to_pile_name;
        bool m_open;
        CardMoveReason m_reason;
        bool m_is_last_handcard;
    };

    int _m_lastMovementId;
    void _fillMoveInfo(CardsMoveStruct &moves, int card_index) const;
    QList<CardsMoveOneTimeStruct> _mergeMoves(QList<CardsMoveStruct> cards_moves);
    QList<CardsMoveStruct> _separateMoves(QList<CardsMoveOneTimeStruct> moveOneTimes);
    void _moveCards(QList<CardsMoveStruct> cards_moves, bool forceMoveVisible, bool ignoreChanges);
    QStringList _chooseDefaultGenerals(ServerPlayer *player) const;
    bool _setPlayerGeneral(ServerPlayer *player, const QString &generalName, bool isFirst);
    QString mode;
    QList<ServerPlayer *> m_players, m_alivePlayers;
    QStringList used_general;
    int player_count;
    ServerPlayer *current;
    QList<int> pile1, pile2;
    QList<int> table_cards;
    QList<int> *m_drawPile, *m_discardPile;
    QStack<DamageStruct> m_damageStack;
    bool game_started;
    bool game_finished;
    bool game_paused;
    QWaitCondition m_waitCond;
    mutable QMutex m_mutex;
    lua_State *L;
    QList<AI *> ais;

    RoomThread *thread;
    QSemaphore _m_semRaceRequest; // When race starts, server waits on his semaphore for the first replier
    QSemaphore _m_semRoomMutex; // Provide per-room  (rather than per-player) level protection of any shared variables


    QHash<QSanProtocol::CommandType, Callback> interactions;
    QHash<QSanProtocol::CommandType, Callback> callbacks;
    QHash<QSanProtocol::CommandType, QSanProtocol::CommandType> m_requestResponsePair;
    // Stores the expected client response for each server request, any unmatched client response will be discarded.

    QTime _m_timeSinceLastSurrenderRequest; // Timer used to ensure that surrender polls are not initiated too frequently
    bool _m_isFirstSurrenderRequest; // We allow the first surrender poll to go through regardless of the timer.

    //helper variables for race request function
    bool _m_raceStarted;
    ServerPlayer *_m_raceWinner;
    ServerPlayer *_m_AIraceWinner;

    QMap<int, Player::Place> place_map;
    QMap<int, ServerPlayer *> owner_map;

    const Card *provided;
    bool has_provided;

    QVariantMap tag;
    const Scenario *scenario;

    bool m_surrenderRequestReceived;
    bool _virtual;
    RoomState _m_roomState;

    GeneralSelector *m_generalSelector;

    static QString generatePlayerName();
    void prepareForStart();
    void assignGeneralsForPlayers(const QList<ServerPlayer *> &to_assign);
    AI *cloneAI(ServerPlayer *player);
    void broadcast(const QByteArray &message, ServerPlayer *except = NULL);
    void initCallbacks();
    QString askForOrder(ServerPlayer *player);

    //process client requests
    void processRequestCheat(ServerPlayer *player, const QVariant &arg);
    void processRequestSurrender(ServerPlayer *player, const QVariant &);
    void processRequestPreshow(ServerPlayer *player, const QVariant &arg);

    bool makeSurrender(ServerPlayer *player);
    bool makeCheat(ServerPlayer *player);
    void makeDamage(const QString &source, const QString &target, QSanProtocol::CheatCategory nature, int point);
    void makeKilling(const QString &killer, const QString &victim);
    void makeReviving(const QString &name);
    void doScript(const QString &script);

    //helper functions and structs
    struct _NullificationAiHelper
    {
        const Card *m_trick;
        ServerPlayer *m_from;
        ServerPlayer *m_to;
    };
    bool _askForNullification(const Card *trick, ServerPlayer *from, ServerPlayer *to, bool positive, _NullificationAiHelper helper);
    QList<CardsMoveStruct> _breakDownCardMoves(QList<CardsMoveStruct> &cards_moves);

private slots:
    void endaskfornull();
    void reportDisconnection();
    void processClientPacket(const QSanProtocol::Packet &packet);
    void reportInvalidPacket(const QByteArray &message);
    void assignRoles();
    void startGame();


signals:
    void room_message(const QString &msg);
    void game_start();
    void game_over(const QString &winner);
};

typedef Room *RoomStar;
Q_DECLARE_METATYPE(RoomStar)

#endif

