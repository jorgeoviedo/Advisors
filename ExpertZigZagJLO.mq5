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

//void OnTradeTransaction(const MqlTradeTransaction &trans, const MqlTradeRequest &req, const MqlTradeResult &res) {
//     if (((ENUM_TRADE_TRANSACTION_TYPE)trans.type == TRADE_TRANSACTION_ORDER_ADD) ||
  //       ((ENUM_TRADE_TRANSACTION_TYPE)trans.type == TRADE_TRANSACTION_ORDER_DELETE)) {
    //     Print("------------ TransactionDescription\r\n",
      //   TransactionDescription(trans));
      //   Print("Estamos en el horno");
        // orderWriteLog(_req, _res);
         //orderPaint(_req);

void OnTradeTransaction(const MqlTradeTransaction &trans,
const MqlTradeRequest &request,
const MqlTradeResult &result)
 {
ENUM_TRADE_TRANSACTION_TYPE type=(ENUM_TRADE_TRANSACTION_TYPE)trans.type;
//--- si la transacción es el resultado de procesamiento de la solicitud, mostramos sólo su nombre
if(type==TRADE_TRANSACTION_REQUEST)
 {
Print(EnumToString(type));
//--- mostramos la descripción de la solicitud procesada
Print("------------RequestDescription\r\n",RequestDescription(request));
//--- mostramos la descripción del resultado de la solicitud
Print("------------ResultDescription\r\n",TradeResultDescription(result));
//--- recordamos el ticket de la orden para su eliminación durante el siguiente procesamiento en OnTick()
 }
else // para la transacción de otro tipo mostramos la descripción completa
//--- mostramos la descripción de la transacción recibida en el Diario
Print("------------TransactionDescription\r\n",TransactionDescription(trans));
//--- 
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
string RequestDescription(const MqlTradeRequest &request)
 {
//---
string desc=EnumToString(request.action)+"\r\n";
 desc+="Symbol: "+request.symbol+"\r\n";
 desc+="Magic Number: "+StringFormat("%d",request.magic)+"\r\n";
 desc+="Order ticket: "+(string)request.order+"\r\n";
 desc+="Order type: "+EnumToString(request.type)+"\r\n";
 desc+="Order filling: "+EnumToString(request.type_filling)+"\r\n";
 desc+="Order time type: "+EnumToString(request.type_time)+"\r\n";
 desc+="Order expiration: "+TimeToString(request.expiration)+"\r\n";
 desc+="Price: "+StringFormat("%G",request.price)+"\r\n";
 desc+="Deviation points: "+StringFormat("%G",request.deviation)+"\r\n";
 desc+="Stop Loss: "+StringFormat("%G",request.sl)+"\r\n";
 desc+="Take Profit: "+StringFormat("%G",request.tp)+"\r\n";
 desc+="Stop Limit: "+StringFormat("%G",request.stoplimit)+"\r\n";
 desc+="Volume: "+StringFormat("%G",request.volume)+"\r\n";
 desc+="Comment: "+request.comment+"\r\n";
//--- devolvemos la cadena obtenida
return desc;
 }
 
 //+------------------------------------------------------------------+
//| Devuelve la descripción textual del resultado de procesamiento |
//| de la solicitud |
//+------------------------------------------------------------------+
string TradeResultDescription(const MqlTradeResult &result)
 {
//---
string desc="Retcode "+(string)result.retcode+"\r\n";
 desc+="Request ID: "+StringFormat("%d",result.request_id)+"\r\n";
 desc+="Order ticket: "+(string)result.order+"\r\n";
 desc+="Deal ticket: "+(string)result.deal+"\r\n";
 desc+="Volume: "+StringFormat("%G",result.volume)+"\r\n";
 desc+="Price: "+StringFormat("%G",result.price)+"\r\n";
 desc+="Ask: "+StringFormat("%G",result.ask)+"\r\n";
 desc+="Bid: "+StringFormat("%G",result.bid)+"\r\n";
 desc+="Comment: "+result.comment+"\r\n";
//--- devolvemos la cadena obtenida
return desc;
 }