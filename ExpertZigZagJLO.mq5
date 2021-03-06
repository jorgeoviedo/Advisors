//+-------------------------------------------------------------------------------------------------------------------+
//|                                                                                                  ExpertZigZagJLO  |
//+-------------------------------------------------------------------------------------------------------------------+
#include <Components\Order.mqh>
#include <Components\ZigZag.mqh>
Order order;
ZigZag indicator;
//+-------------------------------------------------------------------------------------------------------------------+
//| OnInit()                                                                                                          |
//+-------------------------------------------------------------------------------------------------------------------+
void OnInit() {
	if (EventSetTimer(order.orderGetEventTimer(_Period))) {
		indicator.instance();
		order.orderInstanceLog();
	}
}
//+-------------------------------------------------------------------------------------------------------------------+
//| OnTimer()                                                                                                         |
//+-------------------------------------------------------------------------------------------------------------------+
void OnTimer() {
	if ((PositionsTotal() == 0) && (indicator.evalToOpenPosition() != NULL)) {
		order.orderOpen(indicator.getResEvalToOpenPosition());
	} else {
		order.orderCheckModSLTP();
	}
}
//+-------------------------------------------------------------------------------------------------------------------+
//| OnTick()                                                                                                          |
//+-------------------------------------------------------------------------------------------------------------------+
void OnTick() {
	order.orderGetInfoOnTick();
}
//+-------------------------------------------------------------------------------------------------------------------+
//| OnDeinit()                                                                                                        |
//+-------------------------------------------------------------------------------------------------------------------+
void OnDeinit(const int reason) {
	EventKillTimer();
	FileClose(order.getHandle());
}
//+-------------------------------------------------------------------------------------------------------------------+
//| OnTradeTransaction()                                                                                              |
//+-------------------------------------------------------------------------------------------------------------------+
void OnTradeTransaction(const MqlTradeTransaction &_trans, const MqlTradeRequest &_req, const MqlTradeResult &_res) {
   order.orderPaint();
}
//+-------------------------------------------------------------------------------------------------------------------+
//| end                                                                                                               |
//+-------------------------------------------------------------------------------------------------------------------+