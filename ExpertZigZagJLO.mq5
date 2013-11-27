//+---------------------------------------------------------------------------+
//|                                                          ExpertZigZagJLO  |
//|                                                                           |
//+---------------------------------------------------------------------------+
#include <Components\Order.mqh>
#include <Components\ZigZag.mqh>
Order order;
ZigZag indicator;
//+---------------------------------------------------------------------------+
//| OnInit()                                                                  |
//+---------------------------------------------------------------------------+
void OnInit() {
     ResetLastError();
     if (EventSetTimer(order.orderGetEventTimer(_Period))) {
         indicator.instance();
         order.orderInstanceLog();
     } else {
         EventKillTimer();
         Print("Error: ", __FUNCTION__, __LINE__, GetLastError());
     }
}
//+---------------------------------------------------------------------------+
//| OnTimer()                                                                 |
//+---------------------------------------------------------------------------+
void OnTimer() {
     if ((PositionsTotal() == 0) && (indicator.evalToOpenPosition() != NULL)) {
          order.orderOpen(indicator.getResEvalToOpenPosition());
     } else {
          order.orderCheckModSLTP();
     }
}
//+---------------------------------------------------------------------------+
//| OnTick()                                                                  |
//+---------------------------------------------------------------------------+
void OnTick() {
     order.orderGetInfoOnTick();
}
//+---------------------------------------------------------------------------+
//| OnDeinit()                                                                |
//+---------------------------------------------------------------------------+
void OnDeinit(const int reason) {
     EventKillTimer();
     FileClose(order.getHandleFile());
}
//+---------------------------------------------------------------------------+
//| OnTradeTransaction()                                                      |
//+---------------------------------------------------------------------------+
void OnTradeTransaction(const MqlTradeTransaction &_t, 
                        const MqlTradeRequest &_req, 
                        const MqlTradeResult &_res) {
     if (((ENUM_TRADE_TRANSACTION_TYPE)_t.type == TRADE_TRANSACTION_REQUEST) &&
         ((ENUM_TRADE_REQUEST_ACTIONS)_req.action == TRADE_ACTION_DEAL) &&
          (_res.retcode == TRADE_RETCODE_DONE)) {
           order.orderPaint();
   }
}
//+---------------------------------------------------------------------------+
//| end                                                                       |
//+---------------------------------------------------------------------------+
