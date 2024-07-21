--Wiccanthrope Reason
function c27000106.initial_effect(c)
	-- Xyz Summon from Deck
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(27000106,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,27000106)
	e1:SetTarget(c27000106.target)
	e1:SetOperation(c27000106.activate)
	c:RegisterEffect(e1)
	
	-- Add "Wiccanthrope" Spell when banished
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(27000106,1))
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_REMOVE)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1,27000106+1)
	e2:SetTarget(c27000106.thtg)
	e2:SetOperation(c27000106.thop)
	c:RegisterEffect(e2)
end


function c27000106.filter(c,e)
return c:IsFaceup() and c:IsCanBeEffectTarget(e)
end
function c27000106.xyzfilter(c,mg,tp)
return c:IsXyzSummonable(mg,mg,1,2) and Duel.GetLocationCountFromEx(tp,tp,mg,c)>0
end
function c27000106.rescon(sg,e,tp,mg)
return Duel.IsExistingMatchingCard(c27000106.xyzfilter,tp,LOCATION_EXTRA,0,1,nil,sg,tp)
end
function c27000106.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
if chkc then return false end
local g=Duel.GetMatchingGroup(c27000106.filter,tp,LOCATION_MZONE,0,nil,e)
if chk==0 then return aux.SelectUnselectGroup(g,e,tp,1,2,c27000106.rescon,0) end
local sg=aux.SelectUnselectGroup(g,e,tp,1,2,c27000106.rescon,1,tp,HINTMSG_XMATERIAL,c27000106.rescon)
Duel.SetTargetCard(sg)
Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c27000106.activate(e,tp,eg,ep,ev,re,r,rp)
local g=Duel.GetTargetCards(e):Filter(Card.IsFaceup,nil)
if #g<1 then return end
local xyzg=Duel.GetMatchingGroup(c27000106.xyzfilter,tp,LOCATION_EXTRA,0,nil,g,tp)
if #xyzg>0 then
Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
local xyz=xyzg:Select(tp,1,1,nil):GetFirst()
Duel.XyzSummon(tp,xyz,nil,g)
end
end

function c27000106.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c27000106.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end

function c27000106.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c27000106.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if #g>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end