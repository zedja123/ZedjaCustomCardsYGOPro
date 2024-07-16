--Prismiant Tactical Revenge
function c27000004.initial_effect(c)
	-- Negate effect and shuffle into Deck
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_NEGATE+CATEGORY_TODECK)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_CHAINING)
	e1:SetCountLimit(1,27000004+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(c27000004.negcon)
	e1:SetTarget(c27000004.negtg)
	e1:SetOperation(c27000004.negop)
	c:RegisterEffect(e1)
	-- Add 1 banished "Prismiant" card to hand
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(27000004,1))
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetHintTiming(TIMING_END_PHASE)
	e2:SetCountLimit(1,27000004+1)
	e2:SetCondition(c27000004.setcond)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(c27000004.thtg)
	e2:SetOperation(c27000004.thtop)
	c:RegisterEffect(e2)
end

function c27000004.setcond(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentPhase()==PHASE_END
end

function c27000004.thfilter(c)
	return c:IsSetCard(0xf10) and c:IsAbleToHand() and c:IsFaceup() and not c:IsCode(27000004)
end

function c27000004.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c27000004.thfilter,tp,LOCATION_REMOVED,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_REMOVED)
end

function c27000004.thtop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c27000004.thfilter,tp,LOCATION_REMOVED,0,1,1,nil)
	if #g>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end

function c27000004.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(0xf10) and c:IsType(TYPE_SYNCHRO)
end

function c27000004.negcon(e,tp,eg,ep,ev,re,r,rp)
	return ep~=tp and Duel.IsChainNegatable(ev) and Duel.IsExistingMatchingCard(c27000004.cfilter,tp,LOCATION_MZONE,0,1,nil)
end

function c27000004.negtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
end

function c27000004.negop(e,tp,eg,ep,ev,re,r,rp)
	local ec=re:GetHandler()
	if Duel.NegateActivation(ev) and ec:IsRelateToEffect(re) then
		ec:CancelToGrave(false)
		Duel.SendtoDeck(ec,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)
	end
end