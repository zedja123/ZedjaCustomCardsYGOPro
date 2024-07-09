--Wiccanthrope Befaist
function c270000103.initial_effect(c)
	-- Special Summon from GY if you control a "Wiccanthrope" monster, except "Wiccanthrope Befaist"
	local e1 = Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(270000103, 0))
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_GRAVE)
	e1:SetCondition(c270000103.spcon)
	e1:SetTarget(c270000103.sptg)
	e1:SetOperation(c270000103.spop)
	e1:SetCountLimit(1,270000103)
	c:RegisterEffect(e1)

	-- If this card is Summoned: Add 1 "Wiccanthrope" Spell/Trap from your Deck to your hand
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(270000103,1))
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetCountLimit(1,270000103+1)
	e2:SetTarget(c270000103.thtg)
	e2:SetOperation(c270000103.thop)
	c:RegisterEffect(e2)
	local e4 = e2:Clone()
	e4:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e4)
	-- During Main Phase: Banish 1 Spell from your hand/field or GY; Destroy 1 card on the field
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(270000103,2))
	e3:SetCategory(CATEGORY_REMOVE+CATEGORY_DESTROY)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,270000103+2)
	e3:SetCondition(c270000103.bancon)
	e3:SetTarget(c270000103.destg)
	e3:SetOperation(c270000103.desop)
	c:RegisterEffect(e3)
end



-- Special Summon from GY if you control a "Wiccanthrope" monster, except "Wiccanthrope Befaist"

function c270000103.filter(c)
	return c:IsFaceup() and c:IsSetCard(0xf11) and not c:IsCode(270000103)
end

function c270000103.spcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c270000103.filter,tp,LOCATION_MZONE,0,1,nil)
end

function c270000103.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,tp,LOCATION_GRAVE)
end

function c270000103.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 or not c:IsRelateToEffect(e) then return end
	Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
end

-- If this card is Summoned: Add 1 "Wiccanthrope" Spell/Trap from your Deck to your hand
function c270000103.thfilter(c)
	return c:IsSetCard(0xf11) and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsAbleToHand()
end

function c270000103.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c270000103.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end

function c270000103.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c270000103.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if #g>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end

-- During Main Phase: Banish 1 Spell from your hand/field or GY; Destroy 1 card on the field

function c270000103.bancon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsMainPhase()
end

function c270000103.banfilter(c)
	return c:IsType(TYPE_SPELL) and c:IsAbleToRemove()
end

function c270000103.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c270000103.banfilter,tp,LOCATION_HAND+LOCATION_ONFIELD+LOCATION_GRAVE,0,1,nil)
		and Duel.IsExistingMatchingCard(aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,tp,LOCATION_HAND+LOCATION_ONFIELD+LOCATION_GRAVE)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,nil,1,0,0)
end

function c270000103.desop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g1=Duel.SelectMatchingCard(tp,c270000103.banfilter,tp,LOCATION_HAND+LOCATION_ONFIELD+LOCATION_GRAVE,0,1,1,nil)
	if #g1>0 and Duel.Remove(g1,POS_FACEUP,REASON_EFFECT)>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
		local g2=Duel.SelectMatchingCard(tp,aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
		if #g2>0 then
			Duel.Destroy(g2,REASON_EFFECT)
		end
	end
end