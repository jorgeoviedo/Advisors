#include <Components\ZigZag.mqh>
#include <Components\OrderManager.mqh>
ENUM_ORDER_TYPE resEvalToOpenPosition;

void OnInit() {
     ResetLastError();
     if (EventSetTimer(orderGetEventTimer(_Period))) {
         zzInstance();
         orderInstanceLog();
     } else {
         EventKillTimer();
         Print("Error: ", __FUNCTION__, __LINE__, GetLastError());
     }
}

void OnTimer() {
     if (PositionsTotal() == 0) {
         resEvalToOpenPosition = zzEvalToOpenPosition();
         if (resEvalToOpenPosition != NULL) {
             orderOpen(ORDER_TYPE_SELL);
         }
     } else {
         orderCheckModSLTP();
     }
}

void OnTick() {
     orderGetInfoOnTick();
}

void OnDeinit(const int reason) {
     EventKillTimer();
     FileClose(handleFile);
}

void OnTradeTransaction(const MqlTradeTransaction &_trans, const MqlTradeRequest &_req, const MqlTradeResult &_res) {
   if (((ENUM_TRADE_TRANSACTION_TYPE)_trans.type == TRADE_TRANSACTION_REQUEST) &&
       ((ENUM_TRADE_REQUEST_ACTIONS)_req.action == TRADE_ACTION_DEAL) &&
        (_res.retcode == TRADE_RETCODE_DONE)) {
         orderPaint();
    } else {
         if ((ENUM_TRADE_TRANSACTION_TYPE)_trans.type == TRADE_TRANSACTION_DEAL_ADD) { 
            Print("------------TransactionDescription\r\n",TransactionDescription(_trans));
            Print("------------RequestDescription\r\n",RequestDescription(_req));
            Print("------------ResultDescription\r\n",TradeResultDescription(_res));
            orderPaint();
      }
   }
}

//+------------------------------------------------------------------+
//| Devuelve la descripción textual de la transacción |
//+------------------------------------------------------------------+
string TransactionDescription(const MqlTradeTransaction &trans)
 {
//--- 
string desc=EnumToString(trans.type)+"\r\n";
 desc+="Symbol: "+trans.symbol+"\r\n";
 desc+="Deal ticket: "+(string)trans.deal+"\r\n";
 desc+="Deal type: "+EnumToString(trans.deal_type)+"\r\n";
 desc+="Order ticket: "+(string)trans.order+"\r\n";
 desc+="Order type: "+EnumToString(trans.order_type)+"\r\n";
 desc+="Order state: "+EnumToString(trans.order_state)+"\r\n";
 desc+="Order time type: "+EnumToString(trans.time_type)+"\r\n";
 desc+="Order expiration: "+TimeToString(trans.time_expiration)+"\r\n";
 desc+="Price: "+StringFormat("%G",trans.price)+"\r\n";
 desc+="Price trigger: "+StringFormat("%G",trans.price_trigger)+"\r\n";
 desc+="Stop Loss: "+StringFormat("%G",trans.price_sl)+"\r\n";
 desc+="Take Profit: "+StringFormat("%G",trans.price_tp)+"\r\n";
 desc+="Volume: "+StringFormat("%G",trans.volume)+"\r\n";
//--- devolvemos la cadena obtenida
return desc;
 }
//+------------------------------------------------------------------+
//| Devuelve la descripción textual de la solicitud comercial |
//+------------------------------------------------------------------+
string RequestDescription(const MqlTradeRequest &_request)
 {
//---
string desc=EnumToString(_request.action)+"\r\n";
 desc+="Symbol: "+_request.symbol+"\r\n";
 desc+="Magic Number: "+StringFormat("%d",_request.magic)+"\r\n";
 desc+="Order ticket: "+(string)_request.order+"\r\n";
 desc+="Order type: "+EnumToString(_request.type)+"\r\n";
 desc+="Order filling: "+EnumToString(_request.type_filling)+"\r\n";
 desc+="Order time type: "+EnumToString(_request.type_time)+"\r\n";
 desc+="Order expiration: "+TimeToString(_request.expiration)+"\r\n";
 desc+="Price: "+StringFormat("%G",_request.price)+"\r\n";
 desc+="Deviation points: "+StringFormat("%G",_request.deviation)+"\r\n";
 desc+="Stop Loss: "+StringFormat("%G",_request.sl)+"\r\n";
 desc+="Take Profit: "+StringFormat("%G",_request.tp)+"\r\n";
 desc+="Stop Limit: "+StringFormat("%G",_request.stoplimit)+"\r\n";
 desc+="Volume: "+StringFormat("%G",_request.volume)+"\r\n";
 desc+="Comment: "+_request.comment+"\r\n";
//--- devolvemos la cadena obtenida
return desc;
 }
 
 //+------------------------------------------------------------------+
//| Devuelve la descripción textual del resultado de procesamiento |
//| de la solicitud |
//+------------------------------------------------------------------+
string TradeResultDescription(const MqlTradeResult &_result)
 {
//---
string desc="Retcode "+(string)_result.retcode+"\r\n";
 desc+="Request ID: "+StringFormat("%d",_result.request_id)+"\r\n";
 desc+="Order ticket: "+(string)_result.order+"\r\n";
 desc+="Deal ticket: "+(string)_result.deal+"\r\n";
 desc+="Volume: "+StringFormat("%G",_result.volume)+"\r\n";
 desc+="Price: "+StringFormat("%G",_result.price)+"\r\n";
 desc+="Ask: "+StringFormat("%G",_result.ask)+"\r\n";
 desc+="Bid: "+StringFormat("%G",_result.bid)+"\r\n";
 desc+="Comment: "+_result.comment+"\r\n";
//--- devolvemos la cadena obtenida
return desc;
 }
