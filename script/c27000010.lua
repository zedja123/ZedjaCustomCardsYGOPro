--Prismiant Vibranirror
function c27000010.initial_effect(c)
    --synchro summon
    aux.AddSynchroProcedure(c,nil,aux.NonTuner(nil),1)
    c:EnableReviveLimit()
    
    -- Destroy all cards on the field, except "Prismiant" monsters
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(27000010,0))
    e1:SetCategory(CATEGORY_DESTROY)
    e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
    e1:SetCountLimit(1,27000010)
    e1:SetCondition(c27000010.descon)
    e1:SetTarget(c27000010.destg)
    e1:SetOperation(c27000010.desop)
    c:RegisterEffect(e1)

    -- Quick Effect to increase ATK
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(27000010,1))
    e2:SetType(EFFECT_TYPE_QUICK_O)
    e2:SetCode(EVENT_FREE_CHAIN)
    e2:SetRange(LOCATION_MZONE)
    e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e2:SetCountLimit(1,27000010+1)
    e2:SetTarget(c27000010.atktg)
    e2:SetOperation(c27000010.atkop)
    c:RegisterEffect(e2)
end

function c27000010.descon(e,tp,eg,ep,ev,re,r,rp)
    return e:GetHandler():IsSummonType(SUMMON_TYPE_SYNCHRO)
end

function c27000010.destg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return true end
    local g=Duel.GetMatchingGroup(c27000010.desfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil,tp)
    Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,#g,0,0)
end

function c27000010.desfilter(c,tp)
    return not (c:IsControler(tp) and c:IsSetCard(0xf10) and c:IsType(TYPE_MONSTER))
end

function c27000010.desop(e,tp,eg,ep,ev,re,r,rp)
    local g=Duel.GetMatchingGroup(c27000010.desfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil,tp)
    Duel.Destroy(g,REASON_EFFECT)
end

function c27000010.atktg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and chkc:IsSetCard(0xf10) end
    if chk==0 then return Duel.IsExistingTarget(Card.IsSetCard,tp,LOCATION_MZONE,0,1,nil,0xf10) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
    Duel.SelectTarget(tp,Card.IsSetCard,tp,LOCATION_MZONE,0,1,1,nil,0xf10)
end

function c27000010.atkop(e,tp,eg,ep,ev,re,r,rp)
    local tc=Duel.GetFirstTarget()
    if tc and tc:IsRelateToEffect(e) and tc:IsFaceup() then
        local e1=Effect.CreateEffect(e:GetHandler())
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetCode(EFFECT_UPDATE_ATTACK)
        e1:SetValue(1000)
        e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
        tc:RegisterEffect(e1)
    end
end