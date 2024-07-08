--Wiccanthrope Spedallacer
function c270000109.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,nil,4,2,nil,nil,nil,nil,false,c270000109.xyzcheck)
	c:EnableReviveLimit()
	-- XYZ Summoned effect
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(270000109,0))
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1,270000109)
	e1:SetTarget(c270000109.thtg)
	e1:SetOperation(c270000109.thop)
	c:RegisterEffect(e1)
	-- Quick effect
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(270000109,1))
	e2:SetCategory(CATEGORY_DISABLE)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,270000109+1)
	e2:SetCost(c270000109.detachcost)
	e2:SetTarget(c270000109.detachtg)
	e2:SetOperation(c270000109.detachop)
	c:RegisterEffect(e2)
end

function c270000109.xyzfilter(c,xyz,tp)
	return c:IsSetCard(0xf11,xyz,SUMMON_TYPE_XYZ,tp)
end
function c270000109.xyzcheck(g,tp,xyz)
	return g:IsExists(c270000109.xyzfilter,1,nil,xyz,tp)
end

-- XYZ Summoned effect: Add "Wiccanthrope" card from GY to hand
function c270000109.thfilter(c)
	return c:IsSetCard(0xf11) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c270000109.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c270000109.thfilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_GRAVE)
end
function c270000109.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c270000109.thfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	if #g>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end

-- Quick effect: Negate effects and inflict damage
function c270000109.detachcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end

function c270000109.banfilter(c)
	return c:IsType(TYPE_SPELL) and c:IsAbleToRemoveAsCost()
end

function c270000109.setfilter(c)
	return c:IsQuickPlaySpell() and c:IsSSetable() and c:IsSetCard(0xf11)
end
function c270000109.detachtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() end
	if chk==0 then return Duel.IsExistingTarget(Card.IsNegatable,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil)
		and Duel.IsExistingMatchingCard(c270000109.banfilter,tp,LOCATION_HAND+LOCATION_ONFIELD+LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_NEGATE)
	local g=Duel.SelectTarget(tp,Card.IsNegatable,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,g,1,0,0)
end

function c270000109.detachop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsFaceup() and tc:IsRelateToEffect(e) then
		local c=e:GetHandler()
		--Negate its effects
		Duel.NegateRelatedChain(tc,RESET_TURN_SET)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_DISABLE)
		tc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		e2:SetValue(RESET_TURN_SET+RESETS_STANDARD)
		tc:RegisterEffect(e2)
		if tc and Card.IsCanBeDisabledByEffect(tc,e,REASON_EFFECT)~=0 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
			local g=Duel.SelectMatchingCard(tp,c270000109.banfilter,tp,LOCATION_HAND+LOCATION_ONFIELD+LOCATION_GRAVE,0,1,1,nil)
			Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
            Duel.BreakEffect()			
			Duel.Hint(HINT_CARD,0,id)
			Duel.Damage(1-tp,500,REASON_EFFECT)
			
		end
	end
end