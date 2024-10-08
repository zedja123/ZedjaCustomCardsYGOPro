--Prismiant Destroyer
function c27000008.initial_effect(c)
	-- Special Summon itself if you control only "Prismiant" monsters
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(27000008,0))
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(c27000008.spcon)
	e1:SetCountLimit(1,27000008)
	c:RegisterEffect(e1)

	-- Special Summon 1 "Prismiant" monster from your GY and discard 1 card from your hand
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(27000008,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_HANDES)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetTarget(c27000008.gytg)
	e2:SetOperation(c27000008.gyop)
	e2:SetCountLimit(1,27000008+1)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e3)
end

function c27000008.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)>0
		and not Duel.IsExistingMatchingCard(c27000008.spfilter,tp,LOCATION_MZONE,0,1,nil)
end

function c27000008.spfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0xf10)
end

function c27000008.spfilter2(c)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0xf10)
end

function c27000008.gytg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c27000008.spfilter2,tp,LOCATION_GRAVE,0,1,nil)
		and Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE)
	Duel.SetOperationInfo(0,CATEGORY_HANDES,nil,0,tp,1)
end

function c27000008.gyop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c27000008.spfilter2,tp,LOCATION_GRAVE,0,1,1,nil)
	if #g>0 and Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)~=0 then
		Duel.BreakEffect()
		Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_EFFECT+REASON_DISCARD)
	end
end