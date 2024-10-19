--Build Driver - Love and Peace
function c27000406.initial_effect(c)
	-- Activate: Target 1 "Build Rider" Link monster you control
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_DESTROY+CATEGORY_RECOVER)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCountLimit(1,27000406+1)
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

function c27000406.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
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
end

