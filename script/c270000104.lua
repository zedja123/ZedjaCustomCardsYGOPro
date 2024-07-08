--Wiccanthrope Walioright
function c270000104.initial_effect(c)
	-- Special Summon from hand if you control a "Wiccanthrope" monster, except "Wiccanthrope Walioright"
	local e1 = Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(270000104, 0))
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(c270000104.spcon)
	e1:SetTarget(c270000104.sptg)
	e1:SetOperation(c270000104.spop)
	e1:SetCountLimit(1,270000104)
	c:RegisterEffect(e1)

	-- If this card is Summoned: Add 1 "Wiccanthrope" monster from your Deck to your hand
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(270000104,1))
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetCountLimit(1,270000104+1)
	e2:SetTarget(c270000104.thtg)
	e2:SetOperation(c270000104.thop)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e3)
	-- Shuffle up to 3 cards from GY or Banished into the Deck
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(270000104,2))
	e4:SetCategory(CATEGORY_TODECK)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(1,270000104+2)
	e4:SetCondition(c270000104.tdcon)
	e4:SetCost(c270000104.tdcost)
	e4:SetTarget(c270000104.tdtg)
	e4:SetOperation(c270000104.tdop)
	c:RegisterEffect(e4)
end

function c270000104.filter(c)
	return c:IsFaceup() and c:IsSetCard(0xf11) and not c:IsCode(270000104)
end
function c270000104.spcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c270000104.filter,tp,LOCATION_MZONE,0,1,nil)
end

function c270000104.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,tp,LOCATION_HAND)
end

function c270000104.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 or not c:IsRelateToEffect(e) then return end
	Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
end

function c270000104.thfilter(c)
	return c:IsSetCard(0xf11) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end

function c270000104.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c270000104.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end

function c270000104.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c270000104.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if #g>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end

---- shuffle bla
function c270000104.tdcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsMainPhase()
end

function c270000104.banfilter(c,tp)
	return c:IsType(TYPE_SPELL) and c:IsAbleToRemoveAsCost() and Duel.IsExistingMatchingCard(c270000104.tdfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,LOCATION_REMOVED,1,c)
end

function c270000104.tdcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c270000104.banfilter,tp,LOCATION_HAND+LOCATION_ONFIELD+LOCATION_GRAVE,0,1,nil,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c270000104.banfilter,tp,LOCATION_HAND+LOCATION_ONFIELD+LOCATION_GRAVE,0,1,1,nil,tp)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
	e:SetLabelObject(g:GetFirst())
end

function c270000104.tdfilter(c,exclude)
	return c:IsAbleToDeck() and c:IsFaceup() and c~=exclude
end

function c270000104.tdtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local exclude=e:GetLabelObject()
	if chk==0 then return Duel.IsExistingMatchingCard(c270000104.tdfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,LOCATION_REMOVED,1,nil,exclude) end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,1,tp,LOCATION_GRAVE+LOCATION_REMOVED)
end

function c270000104.tdop(e,tp,eg,ep,ev,re,r,rp)
	local exclude=e:GetLabelObject()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(tp,c270000104.tdfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,LOCATION_REMOVED,1,3,nil,exclude)
	if #g>0 then
		Duel.SendtoDeck(g,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)
	end
end