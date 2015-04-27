var E;
function prepare(r){
   var S=document.getElementById("sv")
   var SD=S.getSVGDocument();
   E=SD.getElementById(r);
}
function change(v){
	document.getElementById("range").innerHTML=v;
   E.setAttribute("stroke-width", v);
}

