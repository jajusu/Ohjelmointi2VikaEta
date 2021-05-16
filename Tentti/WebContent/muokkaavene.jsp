<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<script src="scripts/main.js"></script>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.4.1/jquery.min.js"></script>
<script src="http://ajax.aspnetcdn.com/ajax/jquery.validate/1.15.0/jquery.validate.min.js"></script>
<script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.4.1/js/bootstrap.min.js"></script>
<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.4.1/css/bootstrap.min.css">
<link rel="stylesheet" type="text/css" href="css/tyylit.css">
<title>Muokkaa veneen tietoja</title>
</head>

<body id="muokkaa">
<a href="listaaveneet.jsp">&lt; Takaisin listaukseen</a><br><br>

<form id="tiedot">
	<label for="nimi">Nimi: </label><input type="text"  id="nimi" name="nimi" class="form-control"><br><br>
	<label for="merkkimalli">Merkkimalli: </label><input type="text" class="form-control" id="merkkimalli"name="merkkimalli"><br><br>
    <label for="pituus">Pituus:</label><input type="text" class="form-control" id="pituus" name="pituus"><br><br>
	<label for="leveys">Leveys: </label><input type="text" class="form-control" id="leveys" name="leveys"><br><br>
	<label for="hinta">Hinta: </label><input type="text" class="form-control" id="hinta" name="hinta"><br><br>
	<input class="btn btn-success" type="submit" id="tallenna" value="Tallenna"><br>
	<input type="hidden" name="tunnus" id="tunnus">	
</form>
<span id="ilmo"></span>
</body>

<script>
$(document).ready(function(){
	$("#takaisin").click(function(){
		document.location="listaaveneet.jsp";
	});
	
	//Haetaan muutettavan veneen tiedot. Kutsutaan backin GET-metodia ja välitetään kutsun mukana muutettavan tiedon id
	//GET /veneet/muokkaa/tunnus
	var tunnus = requestURLParam("tunnus"); //Funktio löytyy scripts/main.js 	
	$.ajax({url:"veneet/muokkaa/"+tunnus, type:"GET", dataType:"json", success:function(result){	
		$("#tunnus").val(result.tunnus);		
		$("#nimi").val(result.nimi);	
		$("#merkkimalli").val(result.merkkimalli);
		$("#pituus").val(result.pituus);
		$("#leveys").val(result.leveys);
		$("#hinta").val(result.hinta);			
    }});
	
	$("#tiedot").validate({	//lomakkeen validointi
		rules: {
			nimi:  {
				required: true,
				minlength: 2				
			},	
			merkkimalli:  {
				required: true,
				minlength: 2				
			},
			pituus:  {
				number:true,
				required: true,
			},	
			leveys:  {
				number:true,
				required: true,
			},
			hinta:  {
				digits:true,
				required: true,
				minlength: 1,
			}	
		},
		messages: {
			nimi: {     
				required: "Nimi puuttuu",
				minlength: "Nimi liian lyhyt"			
			},
			merkkimalli: {
				required: "Merkkimalli puuttuu",
				minlength: "Merkkimalli liian lyhyt"
			},
			pituus: {
				required: "Pituus puuttuu",
				number: "Pituus lukuna"
			},
			leveys: {
				required: "Leveys puuttuu",
				number: "Leveys lukuna"
			},
			hinta: {
				required: "Hinta puuttuu",
				digits: "Hinta vain kokonaislukuna"
			}
		},			
		submitHandler: function(form) {	
			paivitaTiedot();
		}		
	}); 	
});
//funktio tietojen lisäämistä varten. Kutsutaan backin PUT-metodia ja välitetään kutsun mukana uudet tiedot json-stringinä.
//POST /veneet/
function paivitaTiedot(){	
	var formJsonStr = formDataJsonStr($("#tiedot").serializeArray()); //muutetaan lomakkeen tiedot json-stringiksi
	$.ajax({url:"veneet", data:formJsonStr, type:"PUT", dataType:"json", success:function(result) { //result on joko {"response:1"} tai {"response:0"}       
		if(result.response==0){
			$("#ilmo").html("Veneen päivittäminen epäonnistui.");
		}else if(result.response==1){			
	      	$("#ilmo").html("Veneen päivittäminen onnistui.");
		}
  	}});	
}
</script>
</html>