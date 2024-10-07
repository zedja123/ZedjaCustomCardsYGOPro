--Build Driver - Oh, No!
function c27000409.initial_effect(c)
	-- Negate activation and destroy
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_CHAINING)
	e1:SetCondition(c27000409.negcon)
	e1:SetTarget(c27000409.negtg)
	e1:SetOperation(c27000409.negop)
	e1:SetCountLimit(1,27000409+1)
	c:RegisterEffect(e1)
	
	-- Make target DARK during Battle Phase
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,27000409+2)
	e2:SetCondition(c27000409.attcon)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(c27000409.atttg)
	e2:SetOperation(c27000409.attop)
	c:RegisterEffect(e2)
end

-- e1: Negate activation and destroy
function c27000409.negcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsChainNegatable(ev) and Duel.IsExistingMatchingCard(c27000409.cfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c27000409.cfilter(c)
	return c:IsSetCard(0xf15) and c:IsType(TYPE_LINK) and c:IsLinkAbove(2)
end
function c27000409.negtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
	end
end
function c27000409.negop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re) then
		Duel.Destroy(eg,REASON_EFFECT)
	end
end

-- e2: Make target DARK during Battle Phase
function c27000409.attcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsBattlePhase()
end
function c27000409.atttg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c27000409.attfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c27000409.attfilter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,c27000409.attfilter,tp,LOCATION_MZONE,0,1,1,nil)
end
function c27000409.attfilter(c)
	return c:IsFaceup() and c:IsSetCard(0xf15)
end
function c27000409.attop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) and tc:IsFaceup() then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_ADD_ATTRIBUTE)
		e1:SetValue(ATTRIBUTE_DARK)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
	end
end
