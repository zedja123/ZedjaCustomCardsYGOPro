-- Build Driver - Love and Peace
function c27000406.initial_effect(c)
	-- Activate: Target 1 "Build Rider" Link monster you control
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_DESTROY+CATEGORY_RECOVER)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCountLimit(1,{27000406,1})
	e1:SetTarget(c27000406.target)
	e1:SetOperation(c27000406.activate)
	c:RegisterEffect(e1)
end

function c27000406.filter(c)
	return c:IsSetCard(0xf15) and c:IsType(TYPE_LINK)
end

function c27000406.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_MZONE) end
	if chk==0 then return Duel.IsExistingTarget(c27000406.filter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.SelectTarget(tp,c27000406.filter,tp,LOCATION_MZONE,0,1,1,nil)
end

function c27000406.facedown(c)
	return c:IsFacedown()
end

function c27000406.faceup(c)
	return c:IsFaceup()
end

function c27000406.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	
	if not tc or not tc:IsRelateToEffect(e) then return end
	
	-- Apply effects based on the monster's attributes
	if tc:IsAttribute(ATTRIBUTE_FIRE) then
		-- FIRE: Gain 500 ATK
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(500)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
	end

	if tc:IsAttribute(ATTRIBUTE_WATER) then
		-- WATER: Gain 1000 LP
		Duel.Recover(tp,1000,REASON_EFFECT)
	end

	if tc:IsAttribute(ATTRIBUTE_EARTH) then
		-- EARTH: Destroy 1 face-up card your opponent controls
		if Duel.IsExistingMatchingCard(c27000406.faceup,tp,0,LOCATION_ONFIELD,1,nil) then
			-- Select and destroy 1 face-up card if found
			local g=Duel.SelectMatchingCard(tp,c27000406.faceup,tp,0,LOCATION_ONFIELD,1,1,nil)
			if #g>0 then
				Duel.HintSelection(g)
				Duel.Destroy(g,REASON_EFFECT)
			end
		end
	end

	if tc:IsAttribute(ATTRIBUTE_WIND) then
		-- WIND: Destroy 1 face-down card your opponent controls
		if Duel.IsExistingMatchingCard(c27000406.facedown,tp,0,LOCATION_ONFIELD,1,nil) then
			-- Select and destroy 1 face-down card if found
			local g=Duel.SelectMatchingCard(tp,c27000406.facedown,tp,0,LOCATION_ONFIELD,1,1,nil)
			if #g>0 then
				Duel.HintSelection(g)
				Duel.Destroy(g,REASON_EFFECT)
			end
		end
	end

	if tc:IsAttribute(ATTRIBUTE_LIGHT) then
		-- LIGHT: Attack directly
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_DIRECT_ATTACK)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
	end

	if tc:IsAttribute(ATTRIBUTE_DARK) then
		-- DARK: Inflict piercing battle damage
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_PIERCE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
	end
end