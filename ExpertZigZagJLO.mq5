//##########################################################################################################
#property copyright "Copyright 2013 ROBOT"                                                              //##
#property link      "http://www.google.com"                                                             //##
#property version   "1.00"                                                                              //##
//##########################################################################################################

MqlTradeRequest _req;
MqlTradeResult  _res;
#include <Components\Log.mqh>
#include <Components\Util.mqh>
#include <Components\ZigZag.mqh>
#include <Components\OrderGraph.mqh>
#include <Components\OrderManager.mqh>

//##########################################################################################################
//# Expert initialization (called execute change par or period)                                            #
//##########################################################################################################
void OnInit()
{    ResetLastError();
     if (EventSetTimer(getEventTimer(_Period)))
     {   instanceZizZagIndicator();
         instanceOrderLog();
     }
     else
     {   EventKillTimer();
         Print("Error: ", __FUNCTION__, __LINE__, GetLastError());
     }
}

//##########################################################################################################
//# Timer function                                                                                         #
//##########################################################################################################
void OnTimer()
{    readZigZagIndicator();
     printZigZagIndicator();
     checkZigZagWith(HighBuffer,ORDER_TYPE_SELL);
     checkZigZagWith(LowBuffer, ORDER_TYPE_BUY );
}

//##########################################################################################################
//# Order Logic                                                                                            #
//##########################################################################################################
void checkZigZagWith(double &checkData[], ENUM_ORDER_TYPE type)
{    if(evalZigZagIndicator(checkData))
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

//##########################################################################################################
//# Expert deinitialization (called close graphic)                                                         #
//##########################################################################################################
void OnDeinit(const int reason)
{    EventKillTimer();
     FileClose(handleFile);
}

//##########################################################################################################
//# Expert OnTick                                                                                          #
//##########################################################################################################
void OnTick()
{    Comment(getInfoOnTick());
}
//##########################################################################################################
//#  End Program                                                                                           #
//##########################################################################################################