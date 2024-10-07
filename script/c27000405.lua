--Build Driver - All Right!
function c27000405.initial_effect(c)
	-- Tribute 1 "Build Rider" monster, Special Summon from Extra Deck
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,27000405+1)
	e1:SetTarget(c27000405.sptg1)
	e1:SetOperation(c27000405.spop1)
	c:RegisterEffect(e1)
	
	-- GY effect: Shuffle banished/GY monster into Deck, Special Summon from Extra Deck
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TODECK+CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,27000405+2)
	e2:SetCondition(c27000405.gycon)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(c27000405.sptg2)
	e2:SetOperation(c27000405.spop2)
	c:RegisterEffect(e2)
end

-- e1: Tribute 1 "Build Rider" monster, Special Summon from Extra Deck
function c27000405.spfilter1(c,e,tp)
	return c:IsSetCard(0xf15) and Duel.GetLocationCountFromEx(tp,tp,c)>0
		and Duel.IsExistingMatchingCard(c27000405.spfilter2,tp,LOCATION_EXTRA,0,1,nil,e,tp)
end
function c27000405.spfilter2(c,e,tp)
	return c:IsSetCard(0xf15) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c27000405.sptg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckReleaseGroup(tp,c27000405.spfilter1,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c27000405.spop1(e,tp,eg,ep,ev,re,r,rp)
	local rg=Duel.SelectReleaseGroup(tp,c27000405.spfilter1,1,1,nil,e,tp)
	if #rg>0 and Duel.Release(rg,REASON_EFFECT)~=0 then
		local g=Duel.SelectMatchingCard(tp,c27000405.spfilter2,tp,LOCATION_EXTRA,0,1,1,nil,e,tp)
		if #g>0 then
			Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
		end
	end
end

-- e2: Shuffle banished/GY monster into Deck, Special Summon from Extra Deck
function c27000405.gycon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnCount()~=e:GetHandler():GetTurnID()
end
function c27000405.spfilter3(c,e,tp)
	return c:IsSetCard(0xf15) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c27000405.tdfilter(c)
	return c:IsSetCard(0xf15) and c:IsAbleToDeck() and c:IsType(TYPE_MONSTER)
end
function c27000405.sptg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c27000405.tdfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil)
		and Duel.IsExistingMatchingCard(c27000405.spfilter3,tp,LOCATION_EXTRA,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,1,tp,LOCATION_GRAVE+LOCATION_REMOVED)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c27000405.spop2(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(tp,c27000405.tdfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,1,nil)
	if #g>0 and Duel.SendtoDeck(g,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)~=0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sg=Duel.SelectMatchingCard(tp,c27000405.spfilter3,tp,LOCATION_EXTRA,0,1,1,nil,e,tp)
		if #sg>0 then
			Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)
		end
	end
end
