--Moon Burst: The Helpful Pony
function c210424261.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c)
			--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetCategory(CATEGORY_POSITION)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetRange(LOCATION_PZONE)
	e1:SetCountLimit(1,210424269)
	e1:SetTarget(c210424261.target)
	e1:SetOperation(c210424261.activate)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_BE_BATTLE_TARGET)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e2:SetCondition(c210424261.battlecon)
	c:RegisterEffect(e2)
	local e3=e1:Clone()
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_CHAIN_SOLVING)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e3:SetCondition(c210424261.pendcon)
	c:RegisterEffect(e3)
		--NS/Monster Search
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_TOHAND)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_SUMMON_SUCCESS)
	e4:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e4:SetCountLimit(1,210424270)
	e4:SetTarget(c210424261.scon)
	e4:SetOperation(c210424261.sop)
	c:RegisterEffect(e4)
	local e5=e4:Clone()
	e5:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e5)
			--add atk
	local e6=Effect.CreateEffect(c)
	e6:SetDescription(aux.Stringid(4066,0))
	e6:SetCategory(CATEGORY_ATKCHANGE)
	e6:SetType(EFFECT_TYPE_QUICK_O)
	e6:SetCode(EVENT_BECOME_TARGET)
	e6:SetRange(LOCATION_MZONE)
	e6:SetProperty(EFFECT_FLAG_DELAY)
	e6:SetCountLimit(1,210424271)
	e6:SetCondition(c210424261.swapcon)
    e6:SetOperation(c210424261.atkop)
	c:RegisterEffect(e6)
end
function c210424261.pendfilter(c,tp)
	return c:IsFaceup() and c:IsControler(tp) and c:IsLocation(LOCATION_ONFIELD) and c:IsSetCard(0x666)
end
function c210424261.pendcon(e,tp,eg,ep,ev,re,r,rp)
		if not re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then return false end
	local g=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
	return g and g:IsExists(c210424261.pendfilter,1,nil,tp)
end
function c210424261.battlecon(e,tp,eg,ep,ev,re,r,rp)
	local ec=eg:GetFirst()
	return ec:IsFaceup() and ec:IsControler(tp) and ec:IsSetCard(0x666)
end
function c210424261.swapcon(e,tp,eg,ep,ev,re,r,rp)
		return eg:IsContains(e:GetHandler())
end
function c210424261.atkfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x666) and c:IsType(TYPE_MONSTER)
end
function c210424261.atkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(c210424261.atkfilter,tp,LOCATION_MZONE,0,nil)
	local tc=g:GetFirst()
	while tc do
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(500)
		e1:SetLabelObject(tc)
		e1:SetReset(RESET_PHASE+PHASE_END+RESET_OPPO_TURN,1)
		tc:RegisterEffect(e1)
		tc=g:GetNext()
	end
end
function c210424261.sfilter(c,tpe)
	return c:IsSetCard(0x666) and c:IsFaceup() and c:IsType(TYPE_MONSTER) and c:IsType(TYPE_PENDULUM) and c:IsAbleToHand()
end
function c210424261.scon(e,tp,eg,ep,ev,re,r,rp,chk)
	local tpe=e:GetLabel()
	if chk==0 then return Duel.IsExistingMatchingCard(c210424261.sfilter,tp,LOCATION_GRAVE+LOCATION_EXTRA,0,1,nil,tpe) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_GRAVE+LOCATION_EXTRA)
end
function c210424261.sop(e,tp,eg,ep,ev,re,r,rp)
	local tpe=e:GetLabel()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c210424261.sfilter,tp,LOCATION_GRAVE+LOCATION_EXTRA,0,1,1,nil,tpe)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c210424261.filter1(c)
	return c:IsFaceup() and c:IsSetCard(0x666) and c:IsType(TYPE_MONSTER) and c:IsCanChangePosition()
end
function c210424261.filter2(c)
	return c:IsFaceup() and c:IsType(TYPE_MONSTER) and c:IsCanChangePosition()
end
function c210424261.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	if chk==0 then return Duel.IsExistingTarget(c210424261.filter1,tp,LOCATION_MZONE,0,1,nil) 
		and Duel.IsExistingTarget(c210424261.filter2,tp,0,LOCATION_MZONE,1,nil)  end
Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_POSCHANGE)
	local g1=Duel.SelectTarget(tp,c210424261.filter1,tp,LOCATION_MZONE,0,1,1,nil,ft)
	e:SetLabelObject(g1:GetFirst())
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_POSCHANGE)
	local g2=Duel.SelectTarget(tp,c210424261.filter2,tp,0,LOCATION_MZONE,1,1,nil)
	g1:Merge(g2)
	Duel.SetOperationInfo(0,CATEGORY_POSITION,g1,2,0,0)
end
function c210424261.activate(e,tp,eg,ep,ev,re,r,rp)
if not e:GetHandler():IsRelateToEffect(e) then return end
		local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	if g:GetCount()==2 then
		Duel.ChangePosition(g,POS_FACEUP_DEFENSE,POS_FACEUP_ATTACK,POS_FACEUP_ATTACK,POS_FACEUP_ATTACK)
		end
	end