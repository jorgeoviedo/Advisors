MqlTradeRequest _req;
MqlTradeResult  _res;
#include <Components\ZigZag.mqh>
#include <Components\OrderManager.mqh>

void OnTimer()
{    readZZ();
     if(evalZZ(High)) 
     {  orderCheckForOpen(ORDER_TYPE_SELL, _req, _res);
     }
     else if(evalZZ(Low))
     {  orderCheckForOpen(ORDER_TYPE_BUY, _req, _res);
     }
     orderCheckModSLTP(_req, _res);
     //printZZ();
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