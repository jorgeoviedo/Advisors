MqlTradeRequest _req;
MqlTradeResult  _res;
#include <Components\ZigZag.mqh>
#include <Components\OrderGraph.mqh>
#include <Components\OrderManager.mqh>

void OnTimer()
{    readZZ();
     checkZigZagWith(High,ORDER_TYPE_SELL);
     checkZigZagWith(Low, ORDER_TYPE_BUY );
     printZZ();
}

void checkZigZagWith(double &checkData[], ENUM_ORDER_TYPE type)
{    if(evalZZ(checkData))
     {  if(PositionsTotal()==0)
        {  stepForOpenOrder(type, _req, _res);
           writeLogOrder(_req, _res);
           paintOrder(_req);        
        }
        else
        {  if(!(_req.type == type))
           {  stepForDeleteOrder(_req, _res);
              writeLogOrder(_req, _res);
              paintOrder(_req);
              stepForOpenOrder(type, _req, _res);
              writeLogOrder(_req, _res);
              paintOrder(_req);
           }
        }        
     }
}

void OnInit()
{    ResetLastError();
     if (EventSetTimer(getEventTimer(_Period)))
     {   instanceZZ();
         instanceLogOrder();
     }
     else
     {   EventKillTimer();
         Print("Error: ", __FUNCTION__, __LINE__, GetLastError());
     }
}

void OnDeinit(const int reason)
{    EventKillTimer();
     FileClose(handleFile);
}

void OnTick()
{    Comment(StringFormat("ASK=%.6f  \nBID=%.6f  \nSPREAD=%G", 
     SymbolInfoDouble( Symbol(),SYMBOL_ASK), 
     SymbolInfoDouble( Symbol(),SYMBOL_BID), 
     SymbolInfoInteger(Symbol(),SYMBOL_SPREAD)));
}