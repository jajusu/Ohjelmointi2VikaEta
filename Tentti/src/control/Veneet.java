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

import model.Vene;
import model.dao.Dao;


@WebServlet("/veneet/*")
public class Veneet extends HttpServlet {
	private static final long serialVersionUID = 1L;
       

    public Veneet() {
        super();
        System.out.println("Veneet.Veneet()");
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		System.out.println("Veneet.doGet()");
		String pathInfo=request.getPathInfo(); //kutsun polkutiedot esim. /Titanic
		System.out.println("polku: "+pathInfo);
		Dao dao=new Dao();
		ArrayList<Vene> veneet;
		String strJSON="";
	    if(pathInfo==null) { //Haetaan kaikki veneet 
			veneet = dao.listaaKaikki();
			strJSON = new JSONObject().put("veneet", veneet).toString();
			System.out.println("ladataan kaikki. polku: "+pathInfo);
	    }else if(pathInfo.indexOf("muokkaa")!=-1) {		//polussa on sana "muokkaa", eli haetaan yhden asiakkaat tiedot
	    	String tunnus=pathInfo.replace("/muokkaa/", "");// poista stringist‰ /muokkaa/, j‰ljelle j‰‰ haettu tunnus
	    	int tunnusInt=Integer.parseInt(tunnus);
	    	Vene vene=dao.etsiVene(tunnusInt);
	    	JSONObject JSON=new JSONObject();
	    	JSON.put("nimi", vene.getNimi());
	    	JSON.put("merkkimalli", vene.getMerkkimalli());
	    	JSON.put("pituus", vene.getPituus());
	    	JSON.put("leveys", vene.getLeveys());
	    	JSON.put("hinta", vene.getHinta());
	    	JSON.put("tunnus", vene.getTunnus());
	    	strJSON=JSON.toString();
	    }else { //haku hakusanan kanssa
	    	String hakusana=pathInfo.replace("/", "");
	    	veneet=dao.listaaKaikki(hakusana);
	    	strJSON=new JSONObject().put("veneet", veneet).toString();
	    }
		response.setContentType("application/json");
		PrintWriter out = response.getWriter();
		out.println(strJSON);	
	}

	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		System.out.println("Veneet.doPost()");
		JSONObject jsonObj = new JsonStrToObj().convert(request); //Muutetaan kutsun mukana tuleva json-string json-objektiksi
		Vene vene = new Vene();
		vene.setNimi(jsonObj.getString("nimi"));
		vene.setMerkkimalli(jsonObj.getString("merkkimalli"));
		vene.setPituus(jsonObj.getDouble("pituus"));
		vene.setLeveys(jsonObj.getDouble("leveys"));
		vene.setHinta(jsonObj.getInt("hinta"));
		response.setContentType("application/json");
		System.out.println("Vene doPostissa "+ vene);
		PrintWriter out = response.getWriter();
		Dao dao = new Dao();			
		if(dao.lisaaVene(vene)){ //metodi palauttaa true/false
			out.println("{\"response\":1}");  //Veneen lis‰‰minen onnistui {"response":1}
		}else{
			out.println("{\"response\":0}");  //Veneen lis‰‰minen ep‰onnistui {"response":0}
		}
	}
	
	protected void doPut(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		System.out.println("Veneet.doPut()");
		JSONObject jsonObj = new JsonStrToObj().convert(request); //Muutetaan kutsun mukana tuleva json-string json-objektiksi			
		int tunnusInt = jsonObj.getInt("tunnus");
		System.out.println("Tunnus:" + tunnusInt);
		Vene vene = new Vene();
		vene.setTunnus(jsonObj.getInt("tunnus"));
		vene.setNimi(jsonObj.getString("nimi"));
		vene.setMerkkimalli(jsonObj.getString("merkkimalli"));
		vene.setPituus(jsonObj.getDouble("pituus"));
		vene.setLeveys(jsonObj.getDouble("leveys"));
		vene.setHinta(jsonObj.getInt("hinta"));
		response.setContentType("application/json");
		System.out.println("Vene: "+vene);
		PrintWriter out = response.getWriter();
		Dao dao = new Dao();			
		if(dao.muutaVene(vene, tunnusInt)){ //metodi palauttaa true/false
			out.println("{\"response\":1}");  //Veneen muuttaminen onnistui {"response":1}
		}else{
			out.println("{\"response\":0}");  //Veneen muuttaminen ep‰onnistui {"response":0}
		}	
	}

	protected void doDelete(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		System.out.println("Veneet.doDelete()");
		String pathInfo = request.getPathInfo();	//haetaan kutsun polkutiedot, esim. /1		
		System.out.println("polku: "+pathInfo);
		String poistettavaTunnus = pathInfo.replace("/", "");
		int poistettavaTunnusInt=Integer.parseInt(poistettavaTunnus);
		response.setContentType("application/json");
		PrintWriter out = response.getWriter();
		Dao dao = new Dao();			
		if(dao.poistaVene(poistettavaTunnusInt)){ //metodi palauttaa true/false
			out.println("{\"response\":1}");  //Veneen poistaminen onnistui {"response":1}
		}else{
			out.println("{\"response\":0}");  //Veneen poistaminen ep‰onnistui {"response":0}
		}	
	}

}
