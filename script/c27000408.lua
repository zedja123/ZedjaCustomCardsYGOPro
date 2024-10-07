--Build Driver - Sky Wall
function c27000408.initial_effect(c)
	-- Activate: Add 1 "Build Rider" monster from Deck to hand
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,27000408+1)
	e1:SetOperation(c27000408.activate)
	c:RegisterEffect(e1)

	--Atk up
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetRange(LOCATION_FZONE)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetCondition(c27000408.con)
	e2:SetTarget(function(e,c) return c:IsSetCard(0xf15) end)
	e2:SetValue(500)
	c:RegisterEffect(e2)

	-- End Phase: Set 1 "Build Driver" card from GY or banished to your field
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_LEAVE_GRAVE)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_PHASE+PHASE_END)
	e3:SetRange(LOCATION_FZONE)
	e3:SetCountLimit(1,27000408+2)
	e3:SetTarget(c27000408.settg)
	e3:SetOperation(c27000408.setop)
	c:RegisterEffect(e3)
end

-- e1: Add 1 "Build Rider" monster from Deck to hand
function c27000408.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
local g=Duel.GetMatchingGroup(c27000408.thfilter,tp,LOCATION_DECK,0,nil)
	if #g>0 and Duel.SelectYesNo(tp,aux.Stringid(27000408,0)) then
local g=Duel.SelectMatchingCard(tp,c27000408.thfilter,tp,LOCATION_DECK,0,1,1,nil)
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c27000408.thfilter(c)
	return c:IsSetCard(0xf15) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end

-- e2: "Build Rider" monsters gain 500 ATK during Battle Phase
function c27000408.con(e)
	local ph=Duel.GetCurrentPhase()
	local tp=Duel.GetTurnPlayer()
	return tp==e:GetHandlerPlayer() and ph>=PHASE_BATTLE_START and ph<=PHASE_END
end

-- Apply the ATK boost to "Build Rider" monsters you control
function c27000408.atkop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c27000408.atkfilter, tp, LOCATION_MZONE, 0, nil)
	local tc=g:GetFirst()
	while tc do
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(500)
		e1:SetReset(RESET_EVENT + RESETS_STANDARD + RESET_PHASE + PHASE_END) -- Reset at the end of the turn
		tc:RegisterEffect(e1)
		tc=g:GetNext()
	end
end

-- Filter function for "Build Rider" monsters
function c27000408.atkfilter(c)
	return c:IsSetCard(0xf15) and c:IsFaceup()
end
-- e3: Set 1 "Build Driver" card from GY or banished to your field during End Phase
function c27000408.settg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c27000408.setfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil) end
end
function c27000408.setop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	local g=Duel.SelectMatchingCard(tp,c27000408.setfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,1,nil)
	if #g>0 then
		Duel.SSet(tp,g:GetFirst())
	end
end
function c27000408.setfilter(c)
	return c:IsSetCard(0xf15) and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsSSetable()
end
