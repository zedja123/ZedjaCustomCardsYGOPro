--The Ashens Cinder
function c27000202.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOKEN+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetTarget(c27000202.target)
	e1:SetOperation(c27000202.activate)
	c:RegisterEffect(e1)
	
	--Special Summon from S/T Zone or GY
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_FZONE)
	e2:SetCountLimit(1,27000202+1)
	e2:SetTarget(c27000202.sptg)
	e2:SetOperation(c27000202.spop)
	c:RegisterEffect(e2)
	
	--Activate from Deck
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetCountLimit(1,27000202+2)
	e3:SetCost(aux.bfgcost)
	e3:SetTarget(c27000202.tftg)
	e3:SetOperation(c27000202.tfop)
	c:RegisterEffect(e3)
end
function c27000202.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsPlayerCanSpecialSummonMonster(tp,27000211,0,TYPE_TOKEN,2000,2000,5,RACE_ZOMBIE,ATTRIBUTE_LIGHT) end
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
end

function c27000202.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	if Duel.IsPlayerCanSpecialSummonMonster(tp,27000211,0,TYPE_TOKEN,2000,2000,5,RACE_ZOMBIE,ATTRIBUTE_LIGHT) then
		local token=Duel.CreateToken(tp,27000211)
		Duel.SpecialSummon(token,0,tp,tp,false,false,POS_FACEUP)
	end
end

function c27000202.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and
		Duel.IsExistingTarget(Card.IsMonster,tp,LOCATION_SZONE,LOCATION_SZONE,1,nil) or
		Duel.IsExistingMatchingCard(Card.IsRace,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,nil,RACE_ZOMBIE) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_SZONE+LOCATION_GRAVE)
end

function c27000202.spop(e,tp,eg,ep,ev,re,r,rp)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if ft<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,Card.IsMonster,tp,LOCATION_SZONE,LOCATION_SZONE,1,1,nil)
	if #g==0 then
		g=Duel.SelectMatchingCard(tp,Card.IsRace,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,1,nil,RACE_ZOMBIE)
	end
	if #g>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end

function c27000202.filter(c,tp)
	return c:IsCode(id) and c:GetActivateEffect():IsActivatable(tp,true,true)
end
function c27000202.tftg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c27000202.filter,tp,LOCATION_DECK,0,1,nil,tp) end
	if not Duel.CheckPhaseActivity() then Duel.RegisterFlagEffect(tp,CARD_MAGICAL_MIDBREAKER,RESET_CHAIN,0,1) end
end
function c27000202.tfop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
	local tc=Duel.SelectMatchingCard(tp,c27000202.filter,tp,LOCATION_DECK,0,1,1,nil,tp):GetFirst()
	Duel.ActivateFieldSpell(tc,e,tp,eg,ep,ev,re,r,rp)
end