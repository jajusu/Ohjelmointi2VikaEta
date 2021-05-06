package control;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.ArrayList;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import org.json.JSONObject;

import model.Asiakas;
import model.dao.Dao;


@WebServlet("/asiakkaat/*")
public class Asiakkaat extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
   
    public Asiakkaat() {
        super();
        System.out.println("Asiakkaat.Asiakkaat()");
    }
    
//  //Haetaan autojen tiedot
//    //GET  /autot/{hakusana}
//    //GET /autot/haeyksi/rekno
//	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
//		System.out.println("Autot.doGet()");
//		String pathInfo = request.getPathInfo();	//haetaan kutsun polkutiedot, esim. /audi			
//		System.out.println("polku: "+pathInfo);		
//		Dao dao = new Dao();
//		ArrayList<Auto> autot;
//		String strJSON="";
//		if(pathInfo==null) { //Haetaan kaikki autot 
//			autot = dao.listaaKaikki();
//			strJSON = new JSONObject().put("autot", autot).toString();	
//		}else if(pathInfo.indexOf("haeyksi")!=-1) {		//polussa on sana "haeyksi", eli haetaan yhden auton tiedot
//			String rekno = pathInfo.replace("/haeyksi/", ""); //poistetaan polusta "/haeyksi/", j‰ljelle j‰‰ rekno		
//			Auto auto = dao.etsiAuto(rekno);
//			JSONObject JSON = new JSONObject();
//			JSON.put("merkki", auto.getMerkki());
//			JSON.put("malli", auto.getMalli());
//			JSON.put("vuosi", auto.getVuosi());
//			JSON.put("rekno", auto.getRekno());	
//			strJSON = JSON.toString();		
//		}else{ //Haetaan hakusanan mukaiset autot
//			String hakusana = pathInfo.replace("/", "");
//			autot = dao.listaaKaikki(hakusana);
//			strJSON = new JSONObject().put("autot", autot).toString();	
//		}	
//		response.setContentType("application/json");
//		PrintWriter out = response.getWriter();
//		out.println(strJSON);		
//	}
	
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		System.out.println("Asiakkaat.doGet()");
		String pathInfo = request.getPathInfo();	//haetaan kutsun polkutiedot, esim. /teppo
		System.out.println("polku: "+pathInfo);	

		//String hakusana = pathInfo.replace("/", "");
		Dao dao = new Dao();
		ArrayList<Asiakas> asiakkaat;
		//System.out.println(asiakkaat);
		String strJSON="";
		if(pathInfo==null) { //Haetaan kaikki asiakkaat 
			asiakkaat = dao.listaaKaikki();
			strJSON = new JSONObject().put("asiakkaat", asiakkaat).toString();
			System.out.println("ladataan kaikki. polku: "+pathInfo);	
		}else if(pathInfo.indexOf("muokkaa")!=-1) {		//polussa on sana "muokkaa", eli haetaan yhden asiakkaat tiedot
			String asiakas_id = pathInfo.replace("/muokkaa/", ""); //poistetaan polusta "/muokkaa/", j‰ljelle j‰‰ asiakas_id	
			System.out.println("muokataan. polku: "+pathInfo);	
			System.out.println("asiakas_id: "+asiakas_id);
			Asiakas asiakas = dao.etsiAsiakas(asiakas_id);
			if (asiakas==null) {
				strJSON=" { } ";
			}else {
				JSONObject JSON = new JSONObject();
				JSON.put("asiakas_id", asiakas.getAsiakas_id());
				JSON.put("etunimi", asiakas.getEtunimi());
				JSON.put("sukunimi", asiakas.getSukunimi());
				JSON.put("puhelin", asiakas.getPuhelin());
				JSON.put("sposti", asiakas.getSposti());
				strJSON = JSON.toString();	
			}
	
		}else{ //Haetaan hakusanan mukaiset asiakkaat
			System.out.println("haetaan. polku: "+pathInfo);	
			String hakusana = pathInfo.replace("/", "");
			asiakkaat = dao.listaaKaikki(hakusana);
			strJSON = new JSONObject().put("asiakkaat", asiakkaat).toString();	
		}	
		response.setContentType("application/json");
		PrintWriter out = response.getWriter();
		out.println(strJSON);		
	}

	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		System.out.println("Asiakkaat.doPost()");
		JSONObject jsonObj = new JsonStrToObj().convert(request); //Muutetaan kutsun mukana tuleva json-string json-objektiksi
		Asiakas asiakas = new Asiakas();
		asiakas.setEtunimi(jsonObj.getString("etunimi"));
		asiakas.setSukunimi(jsonObj.getString("sukunimi"));
		asiakas.setPuhelin(jsonObj.getString("puhelin"));
		asiakas.setSposti(jsonObj.getString("sposti"));
		response.setContentType("application/json");
		PrintWriter out = response.getWriter();
		Dao dao = new Dao();			
		if(dao.lisaaAsiakas(asiakas)){ //metodi palauttaa true/false
			out.println("{\"response\":1}");  //Asiakkaan lis‰‰minen onnistui {"response":1}
		}else{
			out.println("{\"response\":0}");  //Asiakkaan lis‰‰minen ep‰onnistui {"response":0}
		}		
	}
	
	protected void doPut(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		System.out.println("Asiakkaat.doPut()");
		JSONObject jsonObj = new JsonStrToObj().convert(request); //Muutetaan kutsun mukana tuleva json-string json-objektiksi			
		int asId = jsonObj.getInt("asiakas_id");
		System.out.println("Asid:" + asId);
		Asiakas asiakas = new Asiakas();
		asiakas.setAsiakas_id(jsonObj.getInt("asiakas_id"));
		asiakas.setEtunimi(jsonObj.getString("etunimi"));
		asiakas.setSukunimi(jsonObj.getString("sukunimi"));
		asiakas.setPuhelin(jsonObj.getString("puhelin"));
		asiakas.setSposti(jsonObj.getString("sposti"));
		response.setContentType("application/json");
		System.out.println("Asiakas: "+asiakas);
		PrintWriter out = response.getWriter();
		Dao dao = new Dao();			
		if(dao.muutaAsiakas(asiakas, asId)){ //metodi palauttaa true/false
			out.println("{\"response\":1}");  //Auton muuttaminen onnistui {"response":1}
		}else{
			out.println("{\"response\":0}");  //Auton muuttaminen ep‰onnistui {"response":0}
		}		
	}
	
	protected void doDelete(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		System.out.println("Asiakkaat.doDelete()");	
		String pathInfo = request.getPathInfo();	//haetaan kutsun polkutiedot, esim. /1		
		System.out.println("polku: "+pathInfo);
		String poistettavaAsiakas_id = pathInfo.replace("/", "");		
		response.setContentType("application/json");
		PrintWriter out = response.getWriter();
		Dao dao = new Dao();			
		if(dao.poistaAsiakas(poistettavaAsiakas_id)){ //metodi palauttaa true/false
			out.println("{\"response\":1}");  //Auton poistaminen onnistui {"response":1}
		}else{
			out.println("{\"response\":0}");  //Auton poistaminen ep‰onnistui {"response":0}
		}	
	}

}
