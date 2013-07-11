MqlTradeRequest _req;
MqlTradeResult  _res;
#include <Components\ZigZag.mqh>
#include <Components\OrderManager.mqh>

void OnTimer()
{    readZZ();
     checkZZForOpen(High,ORDER_TYPE_SELL);
     checkZZForOpen(Low, ORDER_TYPE_BUY );
     checkOrderForModifySLTP(_req, _res);
     printZZ();
}

void checkZZForOpen(double &checkData[], ENUM_ORDER_TYPE type)
{    if(evalZZ(checkData))
     {  if(PositionsTotal()==0)
        {  lastAccountProfit = 0;
           setOrderOpen(type, _req, _res);
           executeOrder(_req, _res);
           writeLogOrder(_req, _res);
           paintOrder(_req);
        }
        else
        {  if(!(_req.type == type))
           {  setOrderDelete(_req);
              executeOrder(_req, _res);
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
{    Comment(StringFormat("ASK=%.6f  \nBID=%.6f  \nSPREAD=%G  \nPATRIMONIO=%G  \nBENEFICIO=%G  \nLAST PROFIT:%G", 
     SymbolInfoDouble( Symbol(),SYMBOL_ASK), 
     SymbolInfoDouble( Symbol(),SYMBOL_BID), 
     SymbolInfoInteger(Symbol(),SYMBOL_SPREAD),
     AccountInfoDouble(ACCOUNT_EQUITY),
     AccountInfoDouble(ACCOUNT_PROFIT),
     lastAccountProfit));
}