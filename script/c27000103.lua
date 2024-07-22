--Wiccanthrope Befaist
function c27000103.initial_effect(c)
	-- Special Summon from GY if you control a "Wiccanthrope" monster, except "Wiccanthrope Befaist"
	local e1 = Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(27000103, 0))
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetCode(EFFECT_SPSUMMON_PROC)
    e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
    e1:SetRange(LOCATION_GRAVE)
	e1:SetCondition(c27000103.spcon)
	e1:SetCountLimit(1,27000103)
	c:RegisterEffect(e1)

	-- If this card is Summoned: Add 1 "Wiccanthrope" Spell/Trap from your Deck to your hand
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(27000103,1))
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetCountLimit(1,27000103+1)
	e2:SetTarget(c27000103.thtg)
	e2:SetOperation(c27000103.thop)
	c:RegisterEffect(e2)
	local e4 = e2:Clone()
	e4:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e4)
	-- During Main Phase: Banish 1 Spell from your hand/field or GY; Destroy 1 card on the field
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(27000103,2))
	e3:SetCategory(CATEGORY_REMOVE+CATEGORY_DESTROY)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,27000103+2)
	e3:SetCondition(c27000103.bancon)
	e3:SetTarget(c27000103.destg)
	e3:SetOperation(c27000103.desop)
	c:RegisterEffect(e3)
end



-- Special Summon from GY if you control a "Wiccanthrope" monster, except "Wiccanthrope Befaist"

function c27000103.filter(c)
	return c:IsFaceup() and c:IsSetCard(0xf11) and not c:IsCode(27000103)
end

function c27000103.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c27000103.spfilter,tp,LOCATION_MZONE,0,1,nil)
end

-- If this card is Summoned: Add 1 "Wiccanthrope" Spell/Trap from your Deck to your hand
function c27000103.thfilter(c)
	return c:IsSetCard(0xf11) and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsAbleToHand()
end

function c27000103.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c27000103.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end

function c27000103.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c27000103.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if #g>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end

-- During Main Phase: Banish 1 Spell from your hand/field or GY; Destroy 1 card on the field

function c27000103.bancon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsMainPhase()
end

function c27000103.banfilter(c)
	return c:IsType(TYPE_SPELL) and c:IsAbleToRemove()
end

function c27000103.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c27000103.banfilter,tp,LOCATION_HAND+LOCATION_ONFIELD+LOCATION_GRAVE,0,1,nil)
		and Duel.IsExistingMatchingCard(aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,tp,LOCATION_HAND+LOCATION_ONFIELD+LOCATION_GRAVE)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,nil,1,0,0)
end

function c27000103.desop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g1=Duel.SelectMatchingCard(tp,c27000103.banfilter,tp,LOCATION_HAND+LOCATION_ONFIELD+LOCATION_GRAVE,0,1,1,nil)
	if #g1>0 and Duel.Remove(g1,POS_FACEUP,REASON_EFFECT)>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
		local g2=Duel.SelectMatchingCard(tp,aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
		if #g2>0 then
			Duel.Destroy(g2,REASON_EFFECT)
		end
	end
end
