#FF0000//+------------------------------------------------------------------+
//| XAUUSD M5 Scalping EA v2                                        |
//+------------------------------------------------------------------+
#include <Trade/Trade.mqh>
CTrade trade;

input double LotSize = 0.01;
input int StopLossPoints = 500;
input int TakeProfitPoints = 1500;
input bool EnableBuy = true;
input bool EnableSell = true;
input bool OnePositionOnly = true;

bool HasPosition()
{
   return PositionSelect(_Symbol);
}

bool BullishEngulfing()
{
   double o1=iOpen(_Symbol,PERIOD_M1,1);
   double c1=iClose(_Symbol,PERIOD_M1,1);
   double o2=iOpen(_Symbol,PERIOD_M1,2);
   double c2=iClose(_Symbol,PERIOD_M1,2);
   return (c2<o2 && c1>o1 && c1>o2 && o1<c2);
}

bool BearishEngulfing()
{
   double o1=iOpen(_Symbol,PERIOD_M1,1);
   double c1=iClose(_Symbol,PERIOD_M1,1);
   double o2=iOpen(_Symbol,PERIOD_M1,2);
   double c2=iClose(_Symbol,PERIOD_M1,2);
   return (c2>o2 && c1<o1 && c1<o2 && o1>c2);
}

datetime lastBar=0;

void OnTick()
{
   if(_Symbol!="XAUUSD.vxc") return;

   datetime currentBar=iTime(_Symbol,PERIOD_M1,0);
   if(currentBar==lastBar) return;
   lastBar=currentBar;

   if(OnePositionOnly && HasPosition()) return;

   double ask=SymbolInfoDouble(_Symbol,SYMBOL_ASK);
   double bid=SymbolInfoDouble(_Symbol,SYMBOL_BID);

   if(EnableBuy && BullishEngulfing())
   {
      double sl=ask-(StopLossPoints*_Point);
      double tp=ask+(TakeProfitPoints*_Point);
      trade.Buy(LotSize,_Symbol,ask,sl,tp,"M1 Buy");
   }

   if(EnableSell && BearishEngulfing())
   {
      double sl=bid+(StopLossPoints*_Point);
      double tp=bid-(TakeProfitPoints*_Point);
      trade.Sell(LotSize,_Symbol,bid,sl,tp,"M1 Sell");
   }
}
