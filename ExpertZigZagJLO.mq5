MqlTradeRequest _req;
MqlTradeResult  _res;
#include <Components\Log.mqh>
#include <Components\ZigZag.mqh>
#include <Components\OrderGraph.mqh>
#include <Components\OrderManager.mqh>

void OnInit()
{    ResetLastError();
     if (EventSetTimer(getEventTimer(_Period)))
     {   instanceZZ();
         instanceLog();
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
{    Comment(getInfoOnTick());
}

void OnTimer()
{    readZZ();
     printZZ();
     checkZigZagWith(High,ORDER_TYPE_SELL);
     checkZigZagWith(Low, ORDER_TYPE_BUY );
}

void checkZigZagWith(double &checkData[], ENUM_ORDER_TYPE type)
{    if(evalZZ(checkData))
     {  if(PositionsTotal()==0)
        {  stepForOpenOrder(type, _req, _res);
           writeLog(_req, _res);
           paintOrder(_req);        
        }
        else
        {  if(!(_req.type == type))
           {  stepForDeleteOrder(_req, _res);
              writeLog(_req, _res);
              paintOrder(_req);
              stepForOpenOrder(type, _req, _res);
              writeLog(_req, _res);
              paintOrder(_req);
           }
        }        
     }
}