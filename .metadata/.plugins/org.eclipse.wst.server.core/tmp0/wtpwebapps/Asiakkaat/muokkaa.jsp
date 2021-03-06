<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<link rel="stylesheet" type="text/css" href="css/tyylit.css">
<script src="scripts/main.js"></script>

<title>Muokkaa asiakasta</title>
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
	<input type="button" id="tallenna" value="Tallenna" onclick="vieTiedot()"><br>
			<input type="hidden" name="asiakas_id" id="asiakas_id">	
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

//Haetaan muutettavan asiakkaan tiedot. Kutsutaan backin GET-metodia ja v?litet??n kutsun mukana muutettavan tiedon id
//GET /asiakkaat/muokkaa/id
var asiakas_id = requestURLParam("asiakas_id"); //Funktio l?ytyy scripts/main.js 
fetch("asiakkaat/muokkaa/" + asiakas_id,{//L?hetet??n kutsu backendiin
    method: 'GET'	      
  })
.then( function (response) {//Odotetaan vastausta ja muutetaan JSON-vastausteksti objektiksi
	return response.json()
})
.then( function (responseJson) {//Otetaan vastaan objekti responseJson-parametriss?	
	console.log(responseJson);
	document.getElementById("etunimi").value = responseJson.etunimi;		
	document.getElementById("sukunimi").value = responseJson.sukunimi;	
	document.getElementById("puhelin").value = responseJson.puhelin;	
	document.getElementById("sposti").value = responseJson.sposti;	
	document.getElementById("asiakas_id").value = responseJson.asiakas_id;	
});	

//Funktio tietojen muuttamista varten. Kutsutaan backin PUT-metodia ja v?litet??n kutsun mukana muutetut tiedot json-stringin?.
//PUT /asiakkaat/
function vieTiedot(){	
	var ilmo="";
	var d = new Date();
	if(document.getElementById("etunimi").value.length<3){
		ilmo="Etunimi ei kelpaa!";		
	}else if(document.getElementById("sukunimi").value.length<2){
		ilmo="Sukunimi ei kelpaa!";		
	}else if(document.getElementById("puhelin").value.length<1){
		ilmo="Puhelin ei kelpaa!";		
	}else if(document.getElementById("sposti").value.length<1){
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
	console.log(formJsonStr);
	//L?het??n muutetut tiedot backendiin
	fetch("asiakkaat",{//L?hetet??n kutsu backendiin
	      method: 'PUT',
	      body:formJsonStr
	    })
	.then( function (response) {//Odotetaan vastausta ja muutetaan JSON-vastaus objektiksi
		return response.json();
	})
	.then( function (responseJson) {//Otetaan vastaan objekti responseJson-parametriss?	
		var vastaus = responseJson.response;		
		if(vastaus==0){
			document.getElementById("ilmo").innerHTML= "Tietojen p?ivitys ep?onnistui";
      }else if(vastaus==1){	        	
      	document.getElementById("ilmo").innerHTML= "Tietojen p?ivitys onnistui";			      	
		}	
		setTimeout(function(){ document.getElementById("ilmo").innerHTML=""; }, 5000);
	});	
	document.getElementById("tiedot").reset(); //tyhjennet??n tiedot -lomake
}

//jostain syyst? ei l?yd? scriptsist? main.js-file?



</script>
</html>