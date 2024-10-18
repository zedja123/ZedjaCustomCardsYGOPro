--Build Rider - Rabbit Tank Sparkling
function c27000413.initial_effect(c)
	-- Link Summon
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0xf15),1,3)
	c:SetSPSummonOnce(27000413)

	-- Also FIRE Attribute
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE+LOCATION_GRAVE+LOCATION_REMOVED)
	e1:SetCode(EFFECT_ADD_ATTRIBUTE)
	e1:SetValue(ATTRIBUTE_FIRE)
	c:RegisterEffect(e1)

	-- Cannot be targeted by card effects
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e2:SetValue(aux.tgoval)
	c:RegisterEffect(e2)

	-- Gain ATK and attack all monsters once each during the Battle Phase
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCondition(c27000413.bpcon)
	e3:SetTarget(c27000413.bptg)
	e3:SetOperation(c27000413.bpoperation)
	e3:SetCountLimit(1,27000413+1) -- Once per turn
	c:RegisterEffect(e3)

	-- Prevent opponent's activation during Battle Phase if you control another "Build Rider"
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_CANNOT_ACTIVATE)
	e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e4:SetRange(LOCATION_MZONE)
	e4:SetTargetRange(0,1)
	e4:SetCondition(c27000413.actcon)
	e4:SetValue(c27000413.aclimit)
	c:RegisterEffect(e4)

	--Must be Link Summoned
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e5:SetCode(EFFECT_SPSUMMON_CONDITION)
	e5:SetValue(aux.lnklimit)
	c:RegisterEffect(e5)
end

-- Condition: Only activate during the Battle Phase
function c27000413.bpcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsBattlePhase()
end

-- Target: No specific targeting required
function c27000413.bptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
end

-- Operation: Gain ATK and attack all monsters once each
function c27000413.bpoperation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,0,LOCATION_MZONE,nil) -- Get all face-up monsters opponent controls
	if #g>0 then
		local atk=0
		local tc=g:GetFirst()
		-- Calculate total ATK gain (half the original ATK of all opponent's monsters)
		while tc do
			atk=atk+(tc:GetBaseAttack()/2)
			tc=g:GetNext()
		end
		-- Gain ATK
		if c:IsFaceup() and c:IsRelateToEffect(e) then
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_UPDATE_ATTACK)
			e1:SetValue(atk)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_BATTLE)
			c:RegisterEffect(e1)
		end
		-- Can attack all opponent's monsters once each
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_ATTACK_ALL)
		e2:SetValue(1) -- Allows it to attack all opponent's monsters
		e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		c:RegisterEffect(e2)
	end
end

-- Condition for preventing opponent's activation during Battle Phase
function c27000413.actcon(e)
	local ph=Duel.GetCurrentPhase()
	local tp=Duel.GetTurnPlayer()
	return ph>=PHASE_BATTLE_START and ph<=PHASE_BATTLE and Duel.IsExistingMatchingCard(aux.FaceupFilter(Card.IsSetCard,0xf15),e:GetHandlerPlayer(),LOCATION_MZONE,0,1,e:GetHandler()) 
end
function c27000413.aclimit(e,re,tp)
	return re:IsActiveType(TYPE_MONSTER+TYPE_SPELL+TYPE_TRAP) and re:IsHasType(EFFECT_TYPE_ACTIVATE)
end

