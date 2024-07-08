--Prismiant Tyrant
function c270000011.initial_effect(c)
    --link summon
    aux.AddLinkProcedure(c,c270000011.matfilter,1,1)
    c:EnableReviveLimit()
    
    -- Send 1 "Prismiant" monster from deck to GY when Link Summoned
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(270000011,0))
    e1:SetCategory(CATEGORY_TOGRAVE)
    e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e1:SetCode(EVENT_SPSUMMON_SUCCESS)
    e1:SetCondition(c270000011.tgcon)
    e1:SetTarget(c270000011.tgtg)
    e1:SetOperation(c270000011.tgop)
    e1:SetCountLimit(1,270000011)
    c:RegisterEffect(e1)
    
    -- Tribute this card to Special Summon 1 "Prismiant" monster from GY
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(270000011,1))
    e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e2:SetType(EFFECT_TYPE_IGNITION)
    e2:SetRange(LOCATION_MZONE)
    e2:SetCountLimit(1,270000011+1)
    e2:SetCost(c270000011.spcost)
    e2:SetTarget(c270000011.sptg)
    e2:SetOperation(c270000011.spop)
    c:RegisterEffect(e2)
end

function c270000011.matfilter(c,lc,sumtype,tp)
    return c:IsRace(RACE_ROCK,lc,sumtype,tp) and not c:IsCode(270000011)
end

function c270000011.tgcon(e,tp,eg,ep,ev,re,r,rp)
    return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK)
end

function c270000011.tgfilter(c)
    return c:IsSetCard(0xf10) and c:IsType(TYPE_MONSTER) and c:IsAbleToGrave()
end

function c270000011.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c270000011.tgfilter,tp,LOCATION_DECK,0,1,nil) end
    Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
end

function c270000011.tgop(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
    local g=Duel.SelectMatchingCard(tp,c270000011.tgfilter,tp,LOCATION_DECK,0,1,1,nil)
    if #g>0 then
        Duel.SendtoGrave(g,REASON_EFFECT)
    end
end

function c270000011.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return e:GetHandler():IsReleasable() end
    Duel.Release(e:GetHandler(),REASON_COST)
end

function c270000011.spfilter(c,e,tp)
    return c:IsSetCard(0xf10) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and not c:IsCode(270000011)
end

function c270000011.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
        and Duel.IsExistingMatchingCard(c270000011.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE)
end

function c270000011.spop(e,tp,eg,ep,ev,re,r,rp)
    if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local g=Duel.SelectMatchingCard(tp,c270000011.spfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
    if #g>0 then
        Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
    end
end