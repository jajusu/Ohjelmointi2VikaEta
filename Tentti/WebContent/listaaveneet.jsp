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
<title>Veneet</title>

</head>
<body id="listaa">
<div id="wrapper">
	<div id="linkki"><a href="lisaavene.jsp" class="btn btn-success">Lisää uusi vene</a></div>
	<div id="hae">  Hakusana:  <input type="text" id="hakusana"> <input type="button" value="Hae" id="hakunappi" class="btn btn-primary"> </div>
	<div id="linkki"></div>
</div>
<br>
<table class="table table-hover" id="listaus" border="1">
	<thead>	
		<tr>
			<th>Nimi</th>
			<th>Merkkimalli</th>
			<th>Pituus</th>
			<th>Leveys</th>	
			<th>Hinta</th>		
			<th colspan=2>Muokkaa / Poista</th>
		</tr>
	</thead>
	<tbody>
	</tbody>
</table>
</body>

<script>
$(document).ready(function(){
	haeVeneet();
	$("#hakunappi").click(function(){
		console.log($("#hakusana").val());
		haeVeneet();
	});
	$(document.body).on("keydown", function(event){
		  if(event.which==13){ //Enteriä painettu, ajetaan haku
			  haeVeneet();
		  }
	});
	$("#hakusana").focus();//viedään kursori hakusana-kenttään sivun latauksen yhteydessä
});
	
function haeVeneet(){
	$("#listaus tbody").empty();
	$.ajax({url:"veneet/"+$("#hakusana").val(), type:"GET", dataType:"json", success:function(result){//Funktio palauttaa tiedot json-objektina		
		console.log(result);
		$.each(result.veneet, function(i, field){  
        	var htmlStr;
        	htmlStr+="<tr id='rivi_"+field.tunnus+"'>"
        	htmlStr+="<td>"+field.nimi+"</td>";
        	htmlStr+="<td>"+field.merkkimalli+"</td>";
        	htmlStr+="<td>"+field.pituus+" metriä</td>";
        	htmlStr+="<td>"+field.leveys+" metriä</td>";
        	htmlStr+="<td>"+field.hinta+" euroa</td>";
        	htmlStr+="<td><input type='button' class='btn btn-warning' onclick=location.href='muokkaavene.jsp?tunnus="+field.tunnus+"' value='Muokkaa' />&nbsp;	";
        	htmlStr+="<input type='button' value='Poista' class='poista btn btn-danger' onclick=poista('"+field.tunnus+"')></td>";
        	console.log(field.tunnus)
        	htmlStr+="</tr>";
        	$("#listaus tbody").append(htmlStr);
        });	
    }});
}

function poista(tunnus){
	if(confirm("Poista vene " + tunnus +"?")){
		$.ajax({url:"veneet/"+tunnus, type:"DELETE", dataType:"json", success:function(result) { //result on joko {"response:1"} tai {"response:0"}
	        if(result.response==0){
	        	$("#ilmo").html("Veneen poisto epäonnistui.");
	        }else if(result.response==1){
	        	$("#rivi_"+tunnus).css("background-color", "red"); //Värjätään poistetun asiakkaan rivi
	        	alert("Vene tunnuksella " + tunnus +" poistettu.");
				haeVeneet();        	
			}
	    }});
	}
}
</script>
</body>
</html>