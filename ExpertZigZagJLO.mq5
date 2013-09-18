MqlTradeRequest _req;
MqlTradeResult _res;
#include <Components\ZigZag.mqh>
#include <Components\OrderManager.mqh>

void OnInit() {
     ResetLastError();
     if (EventSetTimer(orderGetEventTimer(_Period))) {
         ZZinstance();
         orderInstanceLog();
     }
     else {
         EventKillTimer();
         Print("Error: ", __FUNCTION__, __LINE__, GetLastError());
     }
}

void OnTimer() {
     ZZread();
     if (PositionsTotal() == 0) {
         if (ZZeval(High)) {
             orderOpen(ORDER_TYPE_SELL, _req, _res);
         }
         else if (ZZeval(Low)) {
             orderOpen(ORDER_TYPE_BUY, _req, _res);
         }
     }
     orderCheckModSLTP(_req, _res);
}

void OnTick() {
     orderGetInfoOnTick();
}

void OnDeinit(const int reason) {
     EventKillTimer();
     FileClose(handleFile);
}

void OnTradeTransaction(const MqlTradeTransaction &trans, const MqlTradeRequest &req, const MqlTradeResult &res) {
     if (((ENUM_TRADE_TRANSACTION_TYPE)trans.type == TRADE_TRANSACTION_ORDER_ADD) ||
         ((ENUM_TRADE_TRANSACTION_TYPE)trans.type == TRADE_TRANSACTION_ORDER_DELETE)) {
         Print("------------ TransactionDescription\r\n",
         TransactionDescription(trans));
         Print("Estamos en el horno");
         orderWriteLog(_req, _res);
         orderPaint(_req);
     }
}


//+------------------------------------------------------------------+
//| Devuelve la descripción literal de la transacción |
//+------------------------------------------------------------------+
string TransactionDescription(const MqlTradeTransaction &trans,
const bool detailed=true)
 {
//--- preparamos la cadena para el retorno desde la función
string desc=EnumToString(trans.type)+"\r\n";
//--- en el modo detallado agregamos el máximo de información
if(detailed)
 {
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
 }
//--- devolvemos la cadena obtenida
return desc;
 }
//+---