-- Ashens Rulers - Lothric & Lorian
function c27000209.initial_effect(c)
	-- Link Summon
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsRace,RACE_ZOMBIE),1,2)

	-- Special Summon from GY
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1,27000209+1)
	e1:SetCondition(c27000209.spcon)
	e1:SetTarget(c27000209.sptg)
	e1:SetOperation(c27000209.spop)
	c:RegisterEffect(e1)

	-- Special Summon self from GY
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1,27000209+2)
	e2:SetCondition(c27000209.gycon)
	e2:SetTarget(c27000209.gytg)
	e2:SetOperation(c27000209.gyop)
	c:RegisterEffect(e2)
end

-- Check if this card was Link Summoned
function c27000209.spcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK)
end

-- Target 1 Zombie-Type monster in either player's GY for Special Summon
function c27000209.spfilter(c,e,tp,zone)
	return c:IsRace(RACE_ZOMBIE) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP,tp,zone)
end

function c27000209.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local zone=e:GetHandler():GetLinkedZone(tp)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and c27000209.spfilter(chkc,e,tp,zone) end
	if chk==0 then return Duel.IsExistingTarget(c27000209.spfilter,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,nil,e,tp,zone) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c27000209.spfilter,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,1,nil,e,tp,zone)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end

function c27000209.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) and Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP,c:GetLinkedZone(tp))>0 then
		-- Add any additional effects here if needed
	end
end

-- Check if this card was sent to the GY
function c27000209.gycon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsPreviousLocation(LOCATION_MZONE)
end

function c27000209.gytg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end

function c27000209.gyop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end
