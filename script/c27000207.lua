-- Ashens Ruler - Sulyvahn
function c27000207.initial_effect(c)
	-- Ashens cards cannot be destroyed by card effects
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(LOCATION_ONFIELD,0)
	e1:SetTarget(c27000207.indestg)
	e1:SetValue(1)
	c:RegisterEffect(e1)

	-- Special Summon from Deck or GY
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_HAND)
	e2:SetCountLimit(1,27000207)
	e2:SetCondition(c27000207.spcon)
	e2:SetCost(c27000207.spcost)
	e2:SetTarget(c27000207.sptg)
	e2:SetOperation(c27000207.spop)
	c:RegisterEffect(e2)

	-- Replace destruction or banishment
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_SEND_REPLACE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTarget(c27000207.reptg)
	e3:SetValue(c27000207.repval)
	e3:SetOperation(c27000207.repop)
	c:RegisterEffect(e3)
end

function c27000207.indestg(e,c)
	return c:IsSetCard(0xf12)
end

function c27000207.cfilter(c)
	return c:IsFacedown() or not c:IsRace(RACE_ZOMBIE)
end

function c27000207.spcon(e,tp,eg,ep,ev,re,r,rp)
	return not Duel.IsExistingMatchingCard(c27000207.cfilter,tp,LOCATION_MZONE,0,1,nil)
end

function c27000207.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsDiscardable() end
	Duel.SendtoGrave(e:GetHandler(),REASON_COST+REASON_DISCARD)
end

function c27000207.spfilter(c,e,tp)
	return c:IsSetCard(0xf12) and not c:IsCode(id) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end

function c27000207.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c27000207.spfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
end

function c27000207.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c27000207.spfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil,e,tp)
	if #g>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
		e1:SetTargetRange(1,0)
		e1:SetTarget(c27000207.splimit)
		e1:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e1,tp)
	end
end

function c27000207.splimit(e,c)
	return not c:IsRace(RACE_ZOMBIE) and not c:IsType(TYPE_TOKEN)
end

-- Replacement effect target
function c27000207.repfilter(c,tp)
	return c:IsFaceup() and c:IsControler(tp) and c:IsOnField() and (c:IsSetCard(0xf12) or c:IsRace(RACE_ZOMBIE)) and not c:IsReason(REASON_REPLACE) and c:IsReasonPlayer(1-tp) and c:IsReason(REASON_EFFECT) and c:GetDestination()&(LOCATION_GRAVE|LOCATION_REMOVED)>0
end

-- Replacement effect target check
function c27000207.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsAbleToGrave() and eg:IsExists(c27000207.repfilter,1,nil,tp) end
	return Duel.SelectEffectYesNo(tp,c,aux.Stringid(27000207,0))
end

-- Replacement effect value
function c27000207.repval(e,c)
	return c27000207.repfilter(c,e:GetHandlerPlayer())
end
function c27000207.repop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_EFFECT+REASON_REPLACE)
end