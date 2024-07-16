--Prismiant Predominant
function c27000009.initial_effect(c)
    -- Special Summon itself if you control only "Prismiant" monsters
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(27000009,0))
    e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e1:SetType(EFFECT_TYPE_QUICK_O)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetRange(LOCATION_HAND)
    e1:SetCondition(c27000009.spcon)
    e1:SetTarget(c27000009.sptg)
    e1:SetOperation(c27000009.spop)
    e1:SetCountLimit(1,27000009)
    c:RegisterEffect(e1)

    -- Destroy 1 card on the field when Normal Summoned
    local e2 = Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(27000009,1))
    e2:SetCategory(CATEGORY_DESTROY)
    e2:SetType(EFFECT_TYPE_SINGLE + EFFECT_TYPE_TRIGGER_O)
    e2:SetCode(EVENT_SUMMON_SUCCESS)
    e2:SetProperty(EFFECT_FLAG_DELAY)
    e2:SetCountLimit(1,27000009+1)
    e2:SetTarget(c27000009.destg)
    e2:SetOperation(c27000009.desop)
    c:RegisterEffect(e2)
end

function c27000009.spcon(e, tp, eg, ep, ev, re, r, rp)
    local g = Duel.GetFieldGroup(tp, LOCATION_MZONE, 0)
    return #g > 0 and g:FilterCount(Card.IsSetCard, nil, 0xf10) == #g
end
------COISA DO HOP EAR SQUADRON
function c27000009.synfilter(c,e,tp)
    return c:IsSynchroSummonable(nil)
end

function c27000009.scfilter1(c,tp,mc)
    return c:IsFaceup()
        and Duel.IsExistingMatchingCard(c27000009.scfilter2,tp,LOCATION_EXTRA,0,1,nil,tp,Group.FromCards(c,mc))
end
function c27000009.scfilter2(c,tp,mg)
    return Duel.GetLocationCountFromEx(tp,tp,mg,c)>0 and c:IsSynchroSummonable(nil,mg)
end
function c27000009.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    local c=e:GetHandler()
    if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c27000009.scfilter1(chkc,tp,c) end
    if chk==0 then return Duel.IsPlayerCanSpecialSummonCount(tp,2)
        and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
        and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
        and Duel.IsExistingTarget(c27000009.scfilter1,tp,LOCATION_MZONE,0,1,nil,tp,c) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c27000009.spop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if not c:IsRelateToEffect(e) or Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
    if Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)>0 then
        local g=Duel.GetMatchingGroup(c27000009.synfilter,tp,LOCATION_EXTRA,0,nil,e,tp)
        if #g>0 then
            Duel.BreakEffect()
            Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
            local sc=g:Select(tp,1,1,nil):GetFirst()
            Duel.SynchroSummon(tp,sc,nil)
        end
    end
end
--------
function c27000009.destg(e, tp, eg, ep, ev, re, r, rp, chk, chkc)
    if chkc then return chkc:IsOnField() end
    if chk == 0 then return Duel.IsExistingTarget(Card.IsDestructable, tp, LOCATION_ONFIELD, LOCATION_ONFIELD, 1, nil) end
    Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_DESTROY)
    local g = Duel.SelectTarget(tp, Card.IsDestructable, tp, LOCATION_ONFIELD, LOCATION_ONFIELD, 1, 1, nil)
    Duel.SetOperationInfo(0, CATEGORY_DESTROY, g, 1, 0, 0)
end

function c27000009.desop(e, tp, eg, ep, ev, re, r, rp)
    local tc = Duel.GetFirstTarget()
    if tc and tc:IsRelateToEffect(e) then
        Duel.Destroy(tc, REASON_EFFECT)
    end
end
function c27000009.sctg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c27000009.scfilter,tp,LOCATION_EXTRA,0,1,nil) end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c27000009.scop(e,tp,eg,ep,ev,re,r,rp)
    local g=Duel.GetMatchingGroup(c27000009.scfilter,tp,LOCATION_EXTRA,0,nil)
    if #g>0 then
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
        local sg=g:Select(tp,1,1,nil)
        Duel.SynchroSummon(tp,sg:GetFirst(),nil)
    end
end