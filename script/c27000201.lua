-- The Last Soul of Ashens
function c27000201.initial_effect(c)
	-- Special Summon from Deck or GY
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,27000201+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c27000201.target)
	e1:SetOperation(c27000201.activate)
	c:RegisterEffect(e1)

	-- Banish from GY
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOGRAVE)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,27000201+EFFECT_COUNT_CODE_OATH)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(c27000201.gytg)
	e2:SetOperation(c27000201.gyop)
	c:RegisterEffect(e2)
end

function c27000201.spfilter(c,e,tp)
	return c:IsSetCard(0xf12) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end

function c27000201.gyfilter(c,e,tp)
	return c:IsRace(RACE_ZOMBIE) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end

function c27000201.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local b1=Duel.IsExistingMatchingCard(c27000201.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp)
	local b2=Duel.IsExistingMatchingCard(c27000201.gyfilter,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,nil,e,tp) and Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)==0
	if chk==0 then return b1 or b2 end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
end

function c27000201.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local b1=Duel.IsExistingMatchingCard(c27000201.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp)
	local b2=Duel.IsExistingMatchingCard(c27000201.gyfilter,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,nil,e,tp) and Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)==0
	if not (b1 or b2) then return end

	local opt=0
	if b1 and b2 then
		opt=Duel.SelectOption(tp,aux.Stringid(id,1),aux.Stringid(id,2))
	elseif b1 then
		opt=0
	else
		opt=1
	end

	if opt==0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,c27000201.spfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
		if #g>0 then
			Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
		end
	else
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,c27000201.gyfilter,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,1,nil,e,tp)
		if #g>0 then
			Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
		end
	end

	-- Restrict Special Summons to Zombie-Type monsters for the rest of the turn
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c27000201.splimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end

function c27000201.splimit(e,c,sump,sumtype,sumpos,targetp,se)
	return not c:IsRace(RACE_ZOMBIE) and not c:IsType(TYPE_TOKEN)
end

function c27000201.gytg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c27000201.tgfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,2,PLAYER_ALL,LOCATION_DECK)
end

function c27000201.tgfilter(c)
	return c:IsRace(RACE_ZOMBIE) and c:IsAbleToGrave()
end

function c27000201.gyop(e,tp,eg,ep,ev,re,r,rp)
	local g1=Duel.SelectMatchingCard(tp,c27000201.tgfilter,tp,LOCATION_DECK,0,1,1,nil)
	local g2=Duel.SelectMatchingCard(1-tp,c27000201.tgfilter,tp,0,LOCATION_DECK,1,1,nil)
	g1:Merge(g2)
	if #g1>0 then
		Duel.SendtoGrave(g1,REASON_EFFECT)
	end
end