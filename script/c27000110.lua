--Wiccanthrope Sperelfler
function c27000110.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,nil,5,2,c27000110.ovfilter,aux.Stringid(27000110,0))
	c:EnableReviveLimit()
	-- ATK/DEF boost for Banished Spells
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(LOCATION_MZONE,0)
	e1:SetTarget(c27000110.atktg)
	e1:SetValue(c27000110.atkval)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_UPDATE_DEFENSE)
	c:RegisterEffect(e2)
	-- Quick Effect: Detach material, Special Summon from GY, banish Spell, attach Spell from Deck
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(27000110,1))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_REMOVE)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,27000110)
	e3:SetCost(c27000110.spcost)
	e3:SetTarget(c27000110.sptg)
	e3:SetOperation(c27000110.spop)
	c:RegisterEffect(e3)
end

function c27000110.ovfilter(c,tp,lc)
	return c:IsFaceup() and c:IsRankBelow(4) and c:IsSetCard(0xf11,lc,SUMMON_TYPE_XYZ,tp)
end

-- ATK/DEF boost function
function c27000110.atktg(e,c)
	return c:IsSetCard(0xf11) and c:IsType(TYPE_MONSTER)
end

function c27000110.atkspellbanish(c)
	return c:IsType(TYPE_SPELL) and c:IsFaceup()
end

function c27000110.atkval(e,c)
	return Duel.GetMatchingGroupCount(c27000110.atkspellbanish,e:GetHandlerPlayer(),LOCATION_REMOVED,LOCATION_REMOVED,nil)*300
end

function c27000110.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end

function c27000110.spfilter(c,e,tp)
	return c:IsSetCard(0xf11) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end

function c27000110.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c27000110.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE)
end

function c27000110.banfilter(c)
	return c:IsType(TYPE_SPELL) and c:IsAbleToRemoveAsCost()
end

function c27000110.attachfilter(c)
	return c:IsType(TYPE_SPELL)
end

function c27000110.xyzfilter(c,tp)
	return c:IsType(TYPE_XYZ) and c:IsControler(tp)
end

function c27000110.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c27000110.spfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	local tc=g:GetFirst()
	if tc and Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)~=0 then
		-- Banish it when it leaves the field
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_LEAVE_FIELD_REDIRECT)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
		e1:SetReset(RESET_EVENT+RESETS_REDIRECT)
		e1:SetValue(LOCATION_REMOVED)
		tc:RegisterEffect(e1,true)
		-- Optional banish Spell and attach Spell from Deck
		if Duel.IsExistingMatchingCard(c27000110.banfilter,tp,LOCATION_HAND+LOCATION_ONFIELD+LOCATION_GRAVE,0,1,nil) 
			and Duel.SelectYesNo(tp,aux.Stringid(27000110,2)) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
			local sg=Duel.SelectMatchingCard(tp,c27000110.banfilter,tp,LOCATION_HAND+LOCATION_ONFIELD+LOCATION_GRAVE,0,1,1,nil)
			if Duel.Remove(sg,POS_FACEUP,REASON_COST)~=0 then
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
				local tg=Duel.SelectMatchingCard(tp,c27000110.attachfilter,tp,LOCATION_DECK,0,1,1,nil)
				if #tg>0 and Duel.IsExistingMatchingCard(c27000110.xyzfilter,tp,LOCATION_MZONE,0,1,nil,tp) then
					Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
					local xyz=Duel.SelectMatchingCard(tp,c27000110.xyzfilter,tp,LOCATION_MZONE,0,1,1,nil,tp):GetFirst()
					if xyz then
						Duel.Overlay(xyz,tg)
					end
				end
			end
		end
	end
end