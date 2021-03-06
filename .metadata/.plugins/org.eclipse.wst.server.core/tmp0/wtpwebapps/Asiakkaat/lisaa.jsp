<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<link rel="stylesheet" type="text/css" href="css/tyylit.css">
<script src="scripts/main.js"></script>
<title>Lis?? uusi asiakas</title>
<style>
body{
	max-width:300px
}
</style>
</head>

<body onkeydown="tutkiKey(event)">

<a href="listaa.jsp">Takaisin</a><br><br>

<form id="tiedot">
	Etunimi: <input type="text" id="etunimi" name="etunimi"><br><br>
	Sukunimi: <input type="text" id="sukunimi"name="sukunimi"><br><br>
    Puhelin: <input type="text" id="puhelin"name="puhelin"><br><br>
	S?hk?posti: <input type="text" id="sposti" name="sposti"><br><br>
	<input type="button" id="tallenna" value="Lis??" onclick="lisaaTiedot()"><br>
</form><br>
<span id="ilmo"></span><br>

</body>
<script>
function tutkiKey(event){
	if(event.keyCode==13){//Enter
		lisaaTiedot();
	}
}
document.getElementById("etunimi").focus();//vied??n kursori etunimi-kentt??n sivun latauksen yhteydess?

//funktio tietojen lis??mist? varten. Kutsutaan backin POST-metodia ja v?litet??n kutsun mukana uudet tiedot json-stringin?.
//POST /autot/
function lisaaTiedot(){	
	var ilmo="";
	if(document.getElementById("etunimi").value.length<2){
		ilmo="Etunimi ei kelpaa!";		
	}else if(document.getElementById("sukunimi").value.length<2){
		ilmo="Sukunimi ei kelpaa!";		
	}else if(document.getElementById("puhelin").value.length<5){
		ilmo="Puhelin ei kelpaa!";		
	}else if(document.getElementById("sposti").value.length<6){
		ilmo="S?hk?posti ei kelpaa!";		
	}
	if(ilmo!=""){
		document.getElementById("ilmo").innerHTML=ilmo;
		setTimeout(function(){ document.getElementById("ilmo").innerHTML=""; }, 3000);
		return;
	}
	document.getElementById("etunimi").value=siivoa(document.getElementById("etunimi").value);
	document.getElementById("sukunimi").value=siivoa(document.getElementById("sukunimi").value);
	document.getElementById("puhelin").value=siivoa(document.getElementById("puhelin").value);
	document.getElementById("sposti").value=siivoa(document.getElementById("sposti").value);	
	var formJsonStr=formDataToJSON(document.getElementById("tiedot")); //muutetaan lomakkeen tiedot json-stringiksi
	//L?het??n uudet tiedot backendiin
	console.log(formJsonStr);
	fetch("asiakkaat",{//L?hetet??n kutsu backendiin
	      method: 'POST',
	      body:formJsonStr
	    })
	.then( function (response) {//Odotetaan vastausta ja muutetaan JSON-vastaus objektiksi		
		return response.json()
	})
	.then( function (responseJson) {//Otetaan vastaan objekti responseJson-parametriss?	
		var vastaus = responseJson.response;		
		if(vastaus==0){
			document.getElementById("ilmo").innerHTML= "Asiakkaan lis??minen ep?onnistui";
    	}else if(vastaus==1){	        	
    		document.getElementById("ilmo").innerHTML= "Asiakkaan lis??minen onnistui";			      	
		}
		setTimeout(function(){ document.getElementById("ilmo").innerHTML=""; }, 5000);
	});	
 	document.getElementById("tiedot").reset(); //tyhjennet??n tiedot -lomake
}

//jostain syyst? ei l?yd? scriptsist? main.js-file?


function requestURLParam(sParam){
    var sPageURL = window.location.search.substring(1);
    var sURLVariables = sPageURL.split("&");
    for (var i = 0; i < sURLVariables.length; i++){
        var sParameterName = sURLVariables[i].split("=");
        if(sParameterName[0] == sParam){
            return sParameterName[1];
        }
    }
}
function formDataToJSON(data){
	var returnStr="{";
	for(var i=0; i<data.length; i++){		
		returnStr+="\"" +data[i].name + "\":\"" + data[i].value + "\",";
	}	
	returnStr = returnStr.substring(0, returnStr.length - 1); //poistetaan viimeinen pilkku
	returnStr+="}";
	return returnStr;
}	

function siivoa(teksti){
	teksti=teksti.replace("<","");
	teksti=teksti.replace(";","");
	teksti=teksti.replace("'","''");
	return teksti;
}

</script>
</html>