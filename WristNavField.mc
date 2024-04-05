import Toybox.Graphics;
import Toybox.WatchUi;
import Toybox.Position;
import Toybox.Sensor;
import Toybox.Timer;
import Toybox.Application;
import Toybox.Math;
import Toybox.Attention;
import Toybox.Lang;
import Toybox.System;
var posnInfo = null;
var zoom = 300;
var timer;
var NumPick = 0;
var Map = null;
var MapArr = null;
var gw = null;
var gh = null;
var updatePos = 1;
var Lon = null;
var Lat = null;
var headingOld = null;
var startLat = null;
var startLon = null;
var oSB = null;
var oSBdc = null;
  var uxl = null;
 var uyl = null;
 var p = null;
class MapviewerView extends WatchUi.View {
var list =  [[:UA_M,:UA_M1,:UA_M2,:UA_M3],[:UA_H,:UA_H1],[:TR_M,:TR_M1,:TR_M2,:TR_M3],[:TR_H,:TR_H1,:TR_H2],[:SK_M],[:SK_H],[:SI_M],[:SI_H],[:SE_M,:SE_M1,:SE_M2],[:SE_H,:SE_H],[:RS_M,:RS_M1],[:RS_H],[:RO_M,:RO_M1],[:RO_H,:RO_H1],[:PT_M,:PT_M1],[:PT_H],[:PL_M,:PL_M1,:PL_M2,:PL_M3,:PL_M4],[:PL_H,:PL_H1],[:NO_M,:NO_M1],[:NO_H,:NO_H1],[:NL_M],[:NL_H],[:MT_M],[:MT_H],[:MK_M],[:MK_H],[:ME_M],[:ME_H],[:MD_M],[:MD_H],[:LV_M],[:LV_H],[:LU_M],[:LU_H],[:LT_M],[:LT_H],[:IT_M,:IT_M1,:IT_M2,:IT_M3,:IT_M4,:SM_M],[:IT_H,:IT_H1,:IT_H2],[:IS_M,:IS_M1],[:IS_H],[:IE_M,:IE_M1],[:IE_H],[:HU_M,:HU_M1],[:HU_H],[:HR_M],[:HR_H],[:GR_M,:GR_M1,:CY_M],[:GR_H],[:GE_M,:AZ_H],[:GE_H],[:GB_M,:GB_M1,:GB_M2,:GB_M3,:GB_M4,:GB_M5,:IM_M],[:GB_H,:GB_H1,:GB_H2],[:FR_M,:FR_M1,:FR_M2,:FR_M3,:FR_M4,:FR_M5,:FR_M6,:MC_M],[:FR_H,:FR_H1,:FR_H2,:FR_H3],[:FI_M,:FI_M1,:FI_M2],[:FI_H,:FI_H1],[:ES_M,:ES_M1,:ES_M2,:ES_M3],[:ES_H,:ES_H1,:ES_H2],[:EE_M],[:EE_H],[:DK_M,:DK_M1],[:DK_H],[:DE_M,:DE_M1,:DE_M2,:DE_M3,:DE_M4,:DE_M5,:DE_M6,:DE_M7,:DE_M8],[:DE_H,:DE_H1,:DE_H2],[:CZ_M,:CZ_M1],[:CZ_H],[:CH_M,:LI_M],[:CH_H],[:BY_M,:BY_M1],[:BY_H],[:BG_M,:BG_M1],[:BG_H],[:BE_M],[:BE_H],[:BA_M],[:BA_H],[:AT_M],[:AT_H],[:AM_M],[:AM_H],[:AL_M],[:AL_H]];       
       
function initialize() {
        View.initialize();
        
      
    }
    
      function onLayout(dc) {
     if (timer != null) {timer = null;}
      gw = dc.getWidth();
      gh = dc.getHeight();
      
      MapviewerView.GenerateBitmap();
        timer = new Timer.Timer();
  timer.start(method(:timerCallback), 10000, true);
        }

   

function timerCallback() as Void {
  WatchUi.requestUpdate();

}

function GenerateBitmap(){
if (Toybox.Graphics has :createBufferedBitmap) {
oSB = Graphics.createBufferedBitmap.get(
{:width=>gw - 20,
:height=>gh - 20,
:palette=>[
Graphics.COLOR_TRANSPARENT,
Graphics.COLOR_WHITE,
Graphics.COLOR_BLACK,
Graphics.COLOR_YELLOW]
} );

}
else {
if (WatchUi has :getSubscreen){
oSB = new Graphics.BufferedBitmap({:width=>gw-30,
:height=>gh - 30,
:palette=>[
Graphics.COLOR_WHITE,
Graphics.COLOR_BLACK
]
});}
else {
oSB = new Graphics.BufferedBitmap({:width=>gw-30,
:height=>gh - 30,
:palette=>[
Graphics.COLOR_TRANSPARENT,
Graphics.COLOR_WHITE,
Graphics.COLOR_BLACK,
Graphics.COLOR_YELLOW,
Graphics.COLOR_RED
]
});
}}
oSBdc = oSB.getDc();

}

function drawMap(dc){
var py = null;
var px = null;
var pyOld = null;
var pxOld = null; 




if (MapArr != null) {

   for (var i=0; i<MapArr.size();i++){
   var arr = MapArr[i];

      for (var j=0; j<arr.size();j+=2){
       
     
      var long = arr[j];
      var lat = arr[j+1];
      var pixelsLon = (long - startLon) * zoom + (gw/2);
      var pixelsLat = (startLat - lat) * zoom + (gh/2);
      
      py = pixelsLat.toNumber();
      px = pixelsLon.toNumber();
      
  
       if (j == 0){
       pxOld = null;
       pyOld = null;
       }
       
       if (pxOld != null){
  if (j != 0) {
     if (NumPick >= col) {
  
       oSBdc.setPenWidth(3);
       if (WatchUi has :getSubscreen){
        oSBdc.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_BLACK);
       }
       else {
             oSBdc.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_BLACK);
       }
    }
       else {
      
       oSBdc.setPenWidth(4);
       if (WatchUi has :getSubscreen){
       oSBdc.setPenWidth(6);
        oSBdc.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_BLACK);
       }
       else{

       oSBdc.setColor(Graphics.COLOR_YELLOW, Graphics.COLOR_YELLOW);}
       
       }
   }
       
       
       
      
     
      
               oSBdc.drawLine(pxOld, pyOld, px,py);
       if (WatchUi has :getSubscreen && NumPick < col){
        oSBdc.setPenWidth(3);
               oSBdc.drawLine(pxOld, pyOld, px,py);}
}
   
   pxOld = px;
   pyOld = py;
   
   }


   
  if (i == (MapArr.size() - 1)){
  if (NumPick != (Map.size() - 1)){
  NumPick = NumPick + 1;
  WatchUi.requestUpdate();}
  else if (NumPick == (Map.size() - 1) && i == (MapArr.size() - 1)){

  NumPick = NumPick + 1;
 

  WatchUi.requestUpdate();
 
}}  }}



}


function onUpdate(dc) {
	
 p = Position.getInfo().position;
 p = p.toDegrees();
 startLat = p[0];
 startLon = p[1];
 }
 View.onUpdate(dc); 








 if (Map != null && NumPick != Map.size()){
   dc.setClip(0, 0, gw, 40);   
   dc.setClip(0, 200, gw, 40); 
}
    dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_WHITE);
  dc.clear();
  dc.setColor(Graphics.COLOR_TRANSPARENT, Graphics.COLOR_WHITE);
   
   dc.clearClip();
  
if (p != null && p[0] != 180 && posnInfo != null) {

  
	
	if (updatePos == 1){
    
	Lon = p[1].toFloat();
	Lat = p[0].toFloat();
	updatePos = 0;
       NumPick = 0;
       MapviewerView.GenerateBitmap();
	}

 

 if (Map != null && NumPick != Map.size() && posnInfo != null) {

MapArr = WatchUi.loadResource(Rez.JsonData[Map[NumPick]]);
  if (oSBdc == null){
   GenerateBitmap();
  }
   drawMap(dc);}}
   
  



}
        
        

if (Map != null && oSBdc != null && NumPick == Map.size() && oSB != null && p != null && startLon != null) {

  uxl = ((Lon - p[1]) * zoom); 
  uyl = ((p[0] - Lat) * zoom);
  

  var ux = uxl.toNumber(), uy = uyl.toNumber();

   dc.drawBitmap(ux, uy, oSB);  }
 
   

if (NumPick == Map.size() && uxl != null){
if (uxl >= 120 || uyl >= 120 || uyl <= -97 || uxl <= -80){
System.println(uxl + ", " + uyl);
updatePos = 1;

var shapes = WatchUi.loadResource(Rez.JsonData[borders]);

for (var s = 0; s < shapes.length; s++) {
    var shape = shapes[s];
        var chosenCountry = containsPoint(shape);
if (chosenCountry = 1){
Map = list[s]; 
break;
}
    }
}

}

 }
    dc.clearClip();
    

 
}





 

    function setPosition(info) {
        posnInfo = info;  
        WatchUi.requestUpdate();
        
    }
    function onHide(){
        timer.stop();
    
    }

function containsPoint() {
    var count = 0;
    for (var b = 0; b < bounds.length; b += 2) {
        var vertex1 = [bounds[b], bounds[b + 1]];
        var vertex2 = [bounds[(b + 2) % bounds.length], bounds[(b + 3) % bounds.length]];
        if (west(vertex1, vertex2))
            ++count;
    }
    return count % 2;
}

    function west(A, B) {
        if (A[1]<= B[1]) {
            if (startLat <= A[1] || startLat > B[1] ||
                startLon >= A[0] && startLon >= B[0]) {
                return false;
            } else if (startLon < A[0] && startLon < B[0]) {
                return true;
            } else {
                return (startLat - A[1]) / (startLon - A[0]) > (B[1] - A[1]) / (B[0] - A[0]);
            }
        } else {
            return west(B, A);
        }
    }
}



}
    

}