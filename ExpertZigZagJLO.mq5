MqlTradeRequest _req;
MqlTradeResult  _res;
#include <Components\ZigZag.mqh>
#include <Components\OrderManager.mqh>

void OnTimer()
{    readZZ();
     checkZZForOpen(High,ORDER_TYPE_SELL);
     checkZZForOpen(Low, ORDER_TYPE_BUY );
     orderCheckModSLTP(_req, _res);
     printZZ();
}

void checkZZForOpen(double &checkData[], ENUM_ORDER_TYPE type)
{    if(evalZZ(checkData))
     {  if(PositionsTotal()==0)
        {  orderOpen(type, _req, _res);
        }
        else
        {  if(!(_req.type == type))
           {  orderDelete(_req, _res);
           }
        }
     }
}

void OnInit()
{    ResetLastError();
     if(EventSetTimer(orderGetEventTimer(_Period)))
     {  instanceZZ();
        orderInstanceLog();
     }
     else
     {  EventKillTimer();
        Print("Error: ", __FUNCTION__, __LINE__, GetLastError());
     }
}

void OnDeinit(const int reason)
{    EventKillTimer();
     FileClose(handleFile);
}

void OnTick()
{    orderGetInfoOnTick();
}