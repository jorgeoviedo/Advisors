MqlTradeRequest _req;
MqlTradeResult  _res;
#include <Components\ZigZag.mqh>
#include <Components\OrderManager.mqh>

void OnInit()
{    ResetLastError();
     if (EventSetTimer(orderGetEventTimer(_Period)))
     {   ZZinstance();
         orderInstanceLog();
     }
     else
     {   EventKillTimer();
         Print("Error: ", __FUNCTION__, __LINE__, GetLastError());
     }
}

void OnTimer()
{    ZZread();
     if (PositionsTotal()==0)
     {   if (ZZeval(High)) 
         {   orderOpen(ORDER_TYPE_SELL, _req, _res);
         }
         else if (ZZeval(Low))
         {        orderOpen(ORDER_TYPE_BUY, _req, _res);
         }
     }
     orderCheckModSLTP(_req, _res);
}

void OnTick()
{    orderGetInfoOnTick();
}

void OnDeinit(const int reason)
{    EventKillTimer();
     FileClose(handleFile);
}

//+------------------------------------------------------------------+
//| TradeTransaction function                                        |
//+------------------------------------------------------------------+
void OnTradeTransaction(const MqlTradeTransaction &trans,
                        const MqlTradeRequest &request,
                        const MqlTradeResult &result)
  {
//--- get transaction type as enumeration value 
   ENUM_TRADE_TRANSACTION_TYPE type=(ENUM_TRADE_TRANSACTION_TYPE)trans.type;
//--- if the transaction is the request handling result, only its name is displayed
   //if(type==TRADE_TRANSACTION_DEAL_ADD)
    // {
      Print(EnumToString(type));
      //--- display the handled request string name
      //Print("------------RequestDescription\r\n",RequestDescription(request));
      //--- display request result description
      Print("------------ResultDescription\r\n",TradeResultDescription(result));
      //--- store the order ticket for its deletion at the next handling in OnTick()
//     }
   //else // display the full description for transactions of another type
//--- display description of the received transaction in the Journal
      //Print("------------TransactionDescription\r\n",TransactionDescription(trans));
 
//---     
  }
//+------------------------------------------------------------------+
//|  Returns transaction textual description                         |
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
//--- return the obtained string
   return desc;
  }
//+------------------------------------------------------------------+
//|  Returns the trade request textual description                   |
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
//--- return the obtained string
   return desc;
  }
//+------------------------------------------------------------------+
//|  Returns the textual description of the request handling result  |
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
//--- return the obtained string
   return desc;
  }
